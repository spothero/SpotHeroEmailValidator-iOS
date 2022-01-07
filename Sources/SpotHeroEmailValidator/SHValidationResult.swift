// Copyright © 2022 SpotHero, Inc. All rights reserved.

import Foundation

public class SHValidationResult: NSObject {
    /// Indicates whether or not the email address being analyzed is in valid syntax and format.
    public let passedValidation: Bool
    
    /// The autocorrect suggestion to be applied. Nil if there no suggestion.
    public let autocorrectSuggestion: String?
    
    public init(passedValidation: Bool, autocorrectSuggestion: String?) {
        self.passedValidation = passedValidation
        self.autocorrectSuggestion = autocorrectSuggestion
    }
}
