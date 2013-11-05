//
//  ValidatorTestModel.m
//  EmailValidatorDemo
//
//  Created by Eric Kuck on 10/21/13.
//  Copyright (c) 2013 SpotHero. All rights reserved.
//

#import "ValidatorTestModel.h"

@implementation ValidatorTestModel

- (instancetype)initWithEmailAddress:(NSString *)emailAddress errorCode:(NSInteger)errorCode
{
    if (self = [super init]) {
        self.emailAddress = emailAddress;
        self.errorCode = errorCode;
    }
    return self;
}

- (instancetype)initWithEmailAddress:(NSString *)emailAddress suggestion:(NSString *)suggestion
{
    if (self = [super init]) {
        self.emailAddress = emailAddress;
        self.suggestion = suggestion;
    }
    return self;
}

@end
