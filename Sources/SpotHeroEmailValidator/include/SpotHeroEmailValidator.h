//  Copyright © 2019 SpotHero, Inc. All rights reserved.
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

@import CoreGraphics;

#import "SHValidationResult.h"
#import "NSString+LevenshteinDistance.h"
#import "SHAutocorrectSuggestionView.h"
#import "SHEmailValidationTextField.h"

FOUNDATION_EXPORT NSString *const SHValidatorErrorDomain;

typedef enum {
    SHBlankAddressError = 1000,
    SHInvalidSyntaxError,
    SHInvalidUsernameError,
    SHInvalidDomainError,
    SHInvalidTLDError,
} SHValidatorErrorCode;

@interface SpotHeroEmailValidator : NSObject

+ (instancetype)validator;

- (SHValidationResult *)validateAndAutocorrectEmailAddress:(NSString *)emailAddress withError:(NSError **)error;
- (BOOL)validateSyntaxOfEmailAddress:(NSString *)emailAddress withError:(NSError **)error;
- (NSString *)autocorrectSuggestionForEmailAddress:(NSString *)emailAddress withError:(NSError **)error;

@end
