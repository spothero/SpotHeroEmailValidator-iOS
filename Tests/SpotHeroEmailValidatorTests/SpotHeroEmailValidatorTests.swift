// Copyright © 2021 SpotHero, Inc. All rights reserved.

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
    
    func testValidEmailAddressPassesValidation() throws {
        let email = "test@spothero.com"
        
        let validationResult = try SpotHeroEmailValidator.shared.validateAndAutocorrect(emailAddress: email)

        XCTAssertTrue(validationResult.passedValidation)
        XCTAssertNil(validationResult.autocorrectSuggestion)
    }
    
    func testInvalidEmailAddressPassesValidation() throws {
        let email = "test@gamil.con"
        
        let validationResult = try SpotHeroEmailValidator.shared.validateAndAutocorrect(emailAddress: email)

        XCTAssertTrue(validationResult.passedValidation)
        XCTAssertNotNil(validationResult.autocorrectSuggestion)
    }

    func testEmailSuggestions() throws {
        let tests = [
            // Emails with NO Autocorrect Suggestions
            ValidatorTestModel(emailAddress: "test@gmail.com", suggestion: nil),
            ValidatorTestModel(emailAddress: "test@yahoo.co.uk", suggestion: nil),
            ValidatorTestModel(emailAddress: "test@googlemail.com", suggestion: nil),
            
            // Emails with Autocorrect Suggestions
            ValidatorTestModel(emailAddress: "test@gamil.con", suggestion: "test@gmail.com"),
            ValidatorTestModel(emailAddress: "test@yaho.com.uk", suggestion: "test@yahoo.co.uk"),
            ValidatorTestModel(emailAddress: "test@yahooo.co.uk", suggestion: "test@yahoo.co.uk"),
            ValidatorTestModel(emailAddress: "test@goglemail.coj", suggestion: "test@googlemail.com"),
            ValidatorTestModel(emailAddress: "test@goglemail.com", suggestion: "test@googlemail.com"),
            
            // Emails with invalid syntax
            ValidatorTestModel(emailAddress: "blorp", error: .invalidSyntax),
        ]
        
        for test in tests {
            do {
                let autocorrectSuggestion = try SpotHeroEmailValidator.shared.autocorrectSuggestion(for: test.emailAddress)
                XCTAssertEqual(autocorrectSuggestion, test.suggestion, "Test failed for email address: \(test.emailAddress)")
            } catch let error as SpotHeroEmailValidator.Error {
                // If the test fails with an error, make sure the error was expected
                XCTAssertEqual(test.error, error)
            } catch {
                XCTFail("Unexpected error has occurred: \(error.localizedDescription)")
            }
        }
    }
}
