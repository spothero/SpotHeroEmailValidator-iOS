//
//  LevenshteinDistanceTestModel.m
//  EmailValidatorDemo
//
//  Created by Eric Kuck on 10/21/13.
//  Copyright (c) 2013 SpotHero. All rights reserved.
//

#import "LevenshteinDistanceTestModel.h"

@implementation LevenshteinDistanceTestModel

- (instancetype)initWithA:(NSString *)stringA B:(NSString *)stringB distance:(NSInteger)distance
{
    if (self = [super init]) {
        self.stringA = stringA;
        self.stringB = stringB;
        self.distance = distance;
    }
    return self;
}

@end
