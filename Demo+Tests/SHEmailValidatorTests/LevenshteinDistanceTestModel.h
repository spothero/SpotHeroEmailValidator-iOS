//
//  LevenshteinDistanceTestModel.h
//  EmailValidatorDemo
//
//  Created by Eric Kuck on 10/21/13.
//  Copyright (c) 2013 SpotHero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevenshteinDistanceTestModel : NSObject

@property (nonatomic, strong) NSString *stringA;
@property (nonatomic, strong) NSString *stringB;
@property (nonatomic) NSUInteger distance;

- (instancetype)initWithA:(NSString *)stringA B:(NSString *)stringB distance:(NSInteger)distance;

@end
