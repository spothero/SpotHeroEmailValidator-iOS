// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public class SHValidationResult: NSObject {
    /// Indicates whether or not the email address being analyzed is in valid syntax and format.
    @objc public let passedValidation: Bool
    
    /// The autocorrect suggestion to be applied. Nil if there no suggestion.
    @objc public let autocorrectSuggestion: String?
    
    @objc public init(passedValidation: Bool, autocorrectSuggestion: String?) {
        self.passedValidation = passedValidation
        self.autocorrectSuggestion = autocorrectSuggestion
    }
}
