//
//  SHEmailValidator.m
//  SHEmailValidator
//
//  Created by Eric Kuck on 10/12/13.
//  Copyright (c) 2013 SpotHero.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "SHEmailValidator.h"
#import "NSString+LevenshteinDistance.h"

NSString *const SHValidatorErrorDomain = @"com.spothero.SHEmailValidator";

@interface SHEmailValidator ()

@property (nonatomic, strong, readonly) NSArray *ianaRegisteredTLDs;
@property (nonatomic, strong, readonly) NSArray *commonTLDs;
@property (nonatomic, strong, readonly) NSArray *commonDomains;

@end

@implementation SHEmailValidator

+ (instancetype)validator
{
    return [[SHEmailValidator alloc] init];
}

- (instancetype)init
{
    if ((self = [super init])) {
        
        NSString *plistPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"DomainData" ofType:@"plist"];
        NSDictionary *dataDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        // All TLDs registered with IANA as of Wed May 11 07:07:01 2016 UTC (latest list at: http://data.iana.org/TLD/tlds-alpha-by-domain.txt)
        _ianaRegisteredTLDs = dataDictionary[@"IANARegisteredTLDs"];

        _commonTLDs = dataDictionary[@"CommonTLDs"];

        _commonDomains = dataDictionary[@"CommonDomains"];
    }
    return self;
}

- (SHValidationResult *)validateAndAutocorrectEmailAddress:(NSString *)emailAddress withError:(NSError **)error
{
    NSArray *emailParts = [self splitEmailAddress:emailAddress];

    if (![self validateSyntaxOfEmailAddress:emailAddress withParts:emailParts withError:error]) {
        return [[SHValidationResult alloc] initWithPassedValidation:NO autocorrectSuggestion:nil];
    } else {
        return [[SHValidationResult alloc] initWithPassedValidation:YES autocorrectSuggestion:[self autocorrectSuggestionForEmailAddress:emailAddress withParts:emailParts]];
    }
}

- (BOOL)validateSyntaxOfEmailAddress:(NSString *)emailAddress withParts:(NSArray *)emailParts withError:(NSError **)error
{
    if (emailAddress.length == 0) {
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey: @"The email address entered was blank."};

        if (error != NULL) {
            *error = [NSError errorWithDomain:SHValidatorErrorDomain code:SHBlankAddressError userInfo:errorDictionary];
        }

        return NO;
    }

    NSPredicate *fullEmailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\b.+@.+\\..+\\b$"];
    if (![fullEmailPredicate evaluateWithObject:emailAddress]) {
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey: @"The syntax of the entered email address is invalid."};

        if (error != NULL) {
            *error = [NSError errorWithDomain:SHValidatorErrorDomain code:SHInvalidSyntaxError userInfo:errorDictionary];
        }

        return NO;
    }

    NSString *username = emailParts[0];
    NSString *domain = emailParts[1];
    NSString *tld = emailParts[2];

    NSPredicate *usernamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z.!#$%&'*+-/=?^_`{|}~]+"];
    NSPredicate *domainPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z.-]+"];
    NSPredicate *tldPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Za-z][A-Z0-9a-z-]{0,22}[A-Z0-9a-z]"];

    if (username.length == 0 || ![usernamePredicate evaluateWithObject:username] || [username hasPrefix:@"."] || [username hasSuffix:@"."] || ([username rangeOfString:@".."].location != NSNotFound)) {
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey: @"The username section of the entered email address is invalid."};

        if (error != NULL) {
            *error = [NSError errorWithDomain:SHValidatorErrorDomain code:SHInvalidUsernameError userInfo:errorDictionary];
        }

        return NO;
    } else if (domain.length == 0 || ![domainPredicate evaluateWithObject:domain]) {
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey: @"The domain name section of the entered email address is invalid."};

        if (error != NULL) {
            *error = [NSError errorWithDomain:SHValidatorErrorDomain code:SHInvalidDomainError userInfo:errorDictionary];
        }

        return NO;
    } else if (![tldPredicate evaluateWithObject:tld]) {
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey: @"The TLD section of the entered email address is invalid."};

        if (error != NULL) {
            *error = [NSError errorWithDomain:SHValidatorErrorDomain code:SHInvalidTLDError userInfo:errorDictionary];
        }

        return NO;
    } else {
        return YES;
    }
}

- (BOOL)validateSyntaxOfEmailAddress:(NSString *)emailAddress withError:(NSError **)error
{
    return [self validateSyntaxOfEmailAddress:emailAddress withParts:[self splitEmailAddress:emailAddress] withError:error];
}

- (NSString *)closestStringFor:(NSString *)string fromArray:(NSArray *)array withTolerance:(CGFloat)tolerance
{
    if ([array containsObject:string]) {
        return nil;
    } else {
        NSString *closestString;
        CGFloat closestDistance = MAXFLOAT;

        for (NSString *arrayString in array) {
            CGFloat distance = [string levenshteinDistanceFromString:arrayString];
            if (distance < closestDistance && ((distance / string.length) < tolerance)) {
                closestDistance = distance;
                closestString = arrayString;
            }
        }

        return closestString;
    }
}

- (NSString *)autocorrectSuggestionForEmailAddress:(NSString *)emailAddress withParts:(NSArray *)emailParts
{
    NSString *username = emailParts[0];
    NSString *domain = emailParts[1];
    NSString *tld = emailParts[2];

    NSString *suggestedTld;
    if (![self.ianaRegisteredTLDs containsObject:tld]) {
        suggestedTld = [self closestStringFor:tld fromArray:self.commonTLDs withTolerance:0.5f];
    }
    if (!suggestedTld) {
        suggestedTld = tld;
    }

    NSString *fullDomain = [NSString stringWithFormat:@"%@.%@", domain, suggestedTld];
    NSString *suggestedDomain;
    if (![self.commonDomains containsObject:fullDomain]) {
        suggestedDomain = [self closestStringFor:fullDomain fromArray:self.commonDomains withTolerance:0.25f];
    }
    if (!suggestedDomain) {
        suggestedDomain = fullDomain;
    }

    NSString *suggestedEmailAddress = [NSString stringWithFormat:@"%@@%@", username, suggestedDomain];
    if ([suggestedEmailAddress isEqualToString:emailAddress]) {
        return nil;
    } else {
        return suggestedEmailAddress;
    }
}

- (NSString *)autocorrectSuggestionForEmailAddress:(NSString *)emailAddress withError:(NSError **)error
{
    NSArray *emailParts = [self splitEmailAddress:emailAddress];

    if (![self validateSyntaxOfEmailAddress:emailAddress withParts:emailParts withError:error]) {
        return nil;
    } else {
        return [self autocorrectSuggestionForEmailAddress:emailAddress withParts:emailParts];
    }
}

- (NSArray *)splitEmailAddress:(NSString *)emailAddress
{
    NSString *username;
    NSString *domain;
    NSString *tld;

    NSUInteger atLocation = [emailAddress rangeOfString:@"@"].location;
    if (atLocation != NSNotFound) {
        username = [emailAddress substringToIndex:atLocation];

        NSUInteger periodLocation = [emailAddress rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(atLocation, emailAddress.length - atLocation)].location;

        if (periodLocation != NSNotFound) {
            domain = [[emailAddress substringWithRange:NSMakeRange(atLocation + 1, periodLocation - atLocation - 1)] lowercaseString];
            tld = [[emailAddress substringFromIndex:periodLocation + 1] lowercaseString];
        }
    }

    if (!username) {
        username = @"";
    }
    if (!domain) {
        domain = @"";
    }
    if (!tld) {
        tld = @"";
    }

    return @[username, domain, tld];
}

@end
