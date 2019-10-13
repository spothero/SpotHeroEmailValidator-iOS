//
//  SHValidationResult.swift
//  SpotHeroEmailValidator
//
//  Created by Brian Drelling on 10/12/19.
//  Copyright © 2019 SpotHero, Inc. All rights reserved.
//

import Foundation

@objc public class SHValidationResult: NSObject {
    @objc public let passedValidation: Bool
    @objc public let autocorrectSuggestion: String?
    
    @objc public init(passedValidation: Bool, autocorrectSuggestion: String?) {
        self.passedValidation = passedValidation
        self.autocorrectSuggestion = autocorrectSuggestion
    }
}
