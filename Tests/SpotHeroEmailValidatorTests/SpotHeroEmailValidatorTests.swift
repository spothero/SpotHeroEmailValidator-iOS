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

@testable import SpotHeroEmailValidator
import XCTest

class SpotHeroEmailValidatorTests: XCTestCase {
    func testLevenshteinDistanceCategory() {
        let tests = [
            LevenshteinDistanceTestModel(stringA: "kitten", stringB: "sitting", distance: 3),
            LevenshteinDistanceTestModel(stringA: "testing", stringB: "lev", distance: 6),
            LevenshteinDistanceTestModel(stringA: "book", stringB: "back", distance: 2),
            LevenshteinDistanceTestModel(stringA: "spot", stringB: "hero", distance: 4),
            LevenshteinDistanceTestModel(stringA: "parking", stringB: "rules", distance: 6),
            LevenshteinDistanceTestModel(stringA: "lame", stringB: "same", distance: 1),
            LevenshteinDistanceTestModel(stringA: "same", stringB: "same", distance: 0),
        ]

        for test in tests {
            XCTAssertEqual(test.stringA.levenshteinDistance(from: test.stringB), test.distance)
            XCTAssertEqual(test.stringB.levenshteinDistance(from: test.stringA), test.distance)
        }
    }
    
    func testSyntaxValidator() {
        let tests = [
            ValidatorTestModel(emailAddress: "test@email.com", errorCode: 0),
            ValidatorTestModel(emailAddress: "test+-.test@email.com", errorCode: 0),
            ValidatorTestModel(emailAddress: "test@.com", errorCode: SHInvalidSyntaxError.rawValue),
            ValidatorTestModel(emailAddress: "test.com", errorCode: SHInvalidSyntaxError.rawValue),
            ValidatorTestModel(emailAddress: "test@com", errorCode: SHInvalidSyntaxError.rawValue),
            ValidatorTestModel(emailAddress: "test@email.c", errorCode: SHInvalidTLDError.rawValue),
            ValidatorTestModel(emailAddress: "test@email+.com", errorCode: SHInvalidDomainError.rawValue),
            ValidatorTestModel(emailAddress: "test&*\"@email.com", errorCode: SHInvalidUsernameError.rawValue),
        ]
        
        let validator = SpotHeroEmailValidator()
        
        for test in tests {
            let hasNoError = test.errorCode == 0
            
            if hasNoError {
                XCTAssertNoThrow(try validator.validateSyntax(ofEmailAddress: test.emailAddress))
            } else {
                XCTAssertThrowsError(try validator.validateSyntax(ofEmailAddress: test.emailAddress)) { error in
                    XCTAssertEqual((error as NSError).code, Int(test.errorCode))
                }
            }
        }
    }


    func testEmailSuggestions() {
        let tests = [
            ValidatorTestModel(emailAddress: "test@gmail.com", suggestion: nil),
            ValidatorTestModel(emailAddress: "test@yahoo.co.uk", suggestion: nil),
            ValidatorTestModel(emailAddress: "test@googlemail.com", suggestion: nil),
            ValidatorTestModel(emailAddress: "test@gamil.con", suggestion: "test@gmail.com"),
            ValidatorTestModel(emailAddress: "test@yaho.com.uk", suggestion: "test@yahoo.co.uk"),
            ValidatorTestModel(emailAddress: "test@yahooo.co.uk", suggestion: "test@yahoo.co.uk"),
            ValidatorTestModel(emailAddress: "test@goglemail.coj", suggestion: "test@googlemail.com"),
            ValidatorTestModel(emailAddress: "test@goglemail.com", suggestion: "test@googlemail.com"),
        ]
        
        let validator = SpotHeroEmailValidator()
        
        for test in tests {
            if let suggestion = test.suggestion {
                XCTAssertEqual(try validator.autocorrectSuggestion(forEmailAddress: test.emailAddress), suggestion)
            } else {
                XCTAssertThrowsError(try validator.autocorrectSuggestion(forEmailAddress: test.emailAddress))
            }
        }
    }
}
