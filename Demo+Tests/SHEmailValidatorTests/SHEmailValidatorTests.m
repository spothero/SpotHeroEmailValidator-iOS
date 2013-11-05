//
//  SHEmailValidatorTests.m
//  SHEmailValidatorTests
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

#import <XCTest/XCTest.h>
#import "SHEmailValidator.h"
#import "NSString+LevenshteinDistance.h"
#import "LevenshteinDistanceTestModel.h"
#import "ValidatorTestModel.h"

@interface SHEmailValidatorTests : XCTestCase

@end

@implementation SHEmailValidatorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLevenshteinDistanceCategory
{
    NSArray *tests = @[[[LevenshteinDistanceTestModel alloc] initWithA:@"kitten" B:@"sitting" distance:3],
                       [[LevenshteinDistanceTestModel alloc] initWithA:@"testing" B:@"lev" distance:6],
                       [[LevenshteinDistanceTestModel alloc] initWithA:@"book" B:@"back" distance:2],
                       [[LevenshteinDistanceTestModel alloc] initWithA:@"spot" B:@"hero" distance:4],
                       [[LevenshteinDistanceTestModel alloc] initWithA:@"parking" B:@"rules" distance:6],
                       [[LevenshteinDistanceTestModel alloc] initWithA:@"lame" B:@"same" distance:1],
                       [[LevenshteinDistanceTestModel alloc] initWithA:@"same" B:@"same" distance:0]];
    
    for (LevenshteinDistanceTestModel *test in tests) {
        XCTAssertEqual([test.stringA levenshteinDistanceFromString:test.stringB], test.distance, @"Unit test failed for \"%s\"", __PRETTY_FUNCTION__);
        XCTAssertEqual([test.stringB levenshteinDistanceFromString:test.stringA], test.distance, @"Unit test failed for \"%s\"", __PRETTY_FUNCTION__);
    }
}

- (void)testSyntaxValidator
{
    NSArray *tests = @[[[ValidatorTestModel alloc] initWithEmailAddress:@"test@email.com" errorCode:0],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test+-.test@email.com" errorCode:0],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test@.com" errorCode:SHInvalidSyntaxError],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test.com" errorCode:SHInvalidSyntaxError],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test@com" errorCode:SHInvalidSyntaxError],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test@email.c" errorCode:SHInvalidTLDError],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test@email+.com" errorCode:SHInvalidDomainError],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test&*\"@email.com" errorCode:SHInvalidUsernameError],
                       ];
    
    SHEmailValidator *validator = [SHEmailValidator validator];
    NSError *error = nil;
    
    for (ValidatorTestModel *test in tests) {
        BOOL equal = test.errorCode == 0;
        XCTAssertEqual([validator validateSyntaxOfEmailAddress:test.emailAddress withError:&error], equal, @"Unit test failed for \"%s\"", __PRETTY_FUNCTION__);
        if (test.errorCode > 0) {
            XCTAssertEqual(error.code, test.errorCode, @"Unit test failed for \"%s\"", __PRETTY_FUNCTION__);
        } else {
            XCTAssertNil(error, @"Unit test failed for \"%s\"", __PRETTY_FUNCTION__);
        }
    }
}

- (void)testEmailSuggestions
{
    NSArray *tests = @[[[ValidatorTestModel alloc] initWithEmailAddress:@"test@gmail.com" suggestion:nil],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test@yahoo.co.uk" suggestion:nil],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test@googlemail.com" suggestion:nil],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test@gamil.con" suggestion:@"test@gmail.com"],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test@yaho.com.uk" suggestion: @"test@yahoo.co.uk"],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test@yahooo.co.uk" suggestion: @"test@yahoo.co.uk"],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test@goglemail.coj" suggestion:@"test@googlemail.com"],
                       [[ValidatorTestModel alloc] initWithEmailAddress:@"test@goglemail.com" suggestion:@"test@googlemail.com"]];
    
    SHEmailValidator *validator = [SHEmailValidator validator];
    NSError *error = nil;
    
    for (ValidatorTestModel *test in tests) {
        if (test.suggestion) {
            XCTAssertEqualObjects([validator autocorrectSuggestionForEmailAddress:test.emailAddress withError:&error], test.suggestion, @"Unit test failed for \"%s\"", __PRETTY_FUNCTION__);
        } else {
            XCTAssertNil([validator autocorrectSuggestionForEmailAddress:test.emailAddress withError:&error], @"Unit test failed for \"%s\"", __PRETTY_FUNCTION__);
        }
        XCTAssertNil(error, @"Unit test failed for \"%s\"", __PRETTY_FUNCTION__);
    }
}

@end
