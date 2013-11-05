//
//  ValidatorTestModel.h
//  EmailValidatorDemo
//
//  Created by Eric Kuck on 10/21/13.
//  Copyright (c) 2013 SpotHero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidatorTestModel : NSObject

@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic) NSInteger errorCode;
@property (nonatomic, strong) NSString *suggestion;

- (instancetype)initWithEmailAddress:(NSString *)emailAddress errorCode:(NSInteger)errorCode;
- (instancetype)initWithEmailAddress:(NSString *)emailAddress suggestion:(NSString *)suggestion;

@end
