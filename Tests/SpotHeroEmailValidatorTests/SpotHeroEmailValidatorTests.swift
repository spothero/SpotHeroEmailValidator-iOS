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
    struct ValidatorTestModel {
        var emailAddress: String
        var error: SpotHeroEmailValidator.Error?
        var suggestion: String?
    }
    
    func testSyntaxValidator() {
        let tests = [
            // Successful Examples
            ValidatorTestModel(emailAddress: "test@email.com", error: nil),
            ValidatorTestModel(emailAddress: "test+-.test@email.com", error: nil),
            ValidatorTestModel(emailAddress: #""JohnDoe"@email.com"#, error: nil),
            // General Syntax Tests
            ValidatorTestModel(emailAddress: "test.com", error: .invalidSyntax),
            ValidatorTestModel(emailAddress: #"test&*\"@email.com"#, error: .invalidSyntax),
            ValidatorTestModel(emailAddress: #"test&*\@email.com"#, error: .invalidSyntax),
            // Username Tests
            ValidatorTestModel(emailAddress: #"John..Doe@email.com"#, error: .invalidUsername),
            ValidatorTestModel(emailAddress: #".JohnDoe@email.com"#, error: .invalidUsername),
            ValidatorTestModel(emailAddress: #"JohnDoe.@email.com"#, error: .invalidUsername),
            // Domain Tests
            ValidatorTestModel(emailAddress: "test@.com", error: .invalidDomain),
            ValidatorTestModel(emailAddress: "test@com", error: .invalidDomain),
            ValidatorTestModel(emailAddress: "test@email+.com", error: .invalidDomain),
        ]
        
        let validator = SpotHeroEmailValidator.shared
        
        for test in tests {
            if let testError = test.error {
                XCTAssertThrowsError(try validator.validateSyntax(of: test.emailAddress)) { error in
                    XCTAssertEqual(error.localizedDescription, testError.localizedDescription, "Test failed for email address: \(test.emailAddress)")
                }
            } else {
                XCTAssertNoThrow(try validator.validateSyntax(of: test.emailAddress), "Test failed for email address: \(test.emailAddress)")
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
        
        let validator = SpotHeroEmailValidator.shared
        
        for test in tests {
            if let suggestion = test.suggestion {
                XCTAssertEqual(validator.autocorrectSuggestion(for: test.emailAddress), suggestion, "Test failed for email address: \(test.emailAddress)")
            } else {
                XCTAssertNil(validator.autocorrectSuggestion(for: test.emailAddress), "Test failed for email address: \(test.emailAddress)")
            }
        }
    }
}
