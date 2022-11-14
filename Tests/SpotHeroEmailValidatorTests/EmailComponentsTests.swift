// Copyright © 2022 SpotHero, Inc. All rights reserved.

@testable import SpotHeroEmailValidator
import XCTest

class EmailComponentsTests: XCTestCase {
    struct TestModel {
        enum ExpectedResult {
            case `throw`(SpotHeroEmailValidator.Error)
            case `return`(username: String, hostname: String, tld: String)
        }

        /// The email under test.
        let email: String

        /// The result expected when ran through ``EmailComponents``.
        let expectedResult: ExpectedResult

        init(email emailUnderTest: String, expectedTo result: ExpectedResult) {
            self.email = emailUnderTest
            self.expectedResult = result
        }
    }

    func testEmailComponentsInit() {
        let tests = [
            // Successful Examples
            TestModel(email: "test@email.com",
                      expectedTo: .return(username: "test", hostname: "email", tld: "com")),
            
            TestModel(email: "TEST@EMAIL.COM",
                      expectedTo: .return(username: "TEST", hostname: "email", tld: "COM")),
            
            TestModel(email: "test+-.test@email.com",
                      expectedTo: .return(username: "test+-.test", hostname: "email", tld: "com")),
            
            TestModel(email: #""JohnDoe"@email.com"#,
                      expectedTo: .return(username: #""JohnDoe""#, hostname: "email", tld: "com")),
            
            // Failing Examples
            TestModel(email: "t@st@email.com", expectedTo: .throw(.invalidSyntax)),
            TestModel(email: "test.com", expectedTo: .throw(.invalidSyntax)),
            
            // Domain Tests
            TestModel(email: "test@email", expectedTo: .throw(.invalidDomain)),
        ]

        for test in tests {
            switch test.expectedResult {
            case .throw:
                XCTAssertThrowsError(try EmailComponents(email: test.email)) { error in
                    XCTAssertEqual(error.localizedDescription,
                                   error.localizedDescription,
                                   "Test failed for email address: \(test.email)")
                }
            case let .return(username, hostname, tld):
                do {
                    let actualComponents = try EmailComponents(email: test.email)
                    XCTAssertEqual(actualComponents.username, username)
                    XCTAssertEqual(actualComponents.hostname, hostname)
                    XCTAssertEqual(actualComponents.tld, tld)
                } catch {
                    XCTFail("Test failed for email address: \(test.email). \(error.localizedDescription)")
                }
            }
        }
    }
}
