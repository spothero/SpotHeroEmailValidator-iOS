//
//  AutocorrectSuggestionViewDelegate.swift
//  SpotHeroEmailValidator
//
//  Created by Brian Drelling on 5/7/20.
//  Copyright © 2020 SpotHero, Inc. All rights reserved.
//

import Foundation

// Work In Progress -- This is a boilerplate file for Swift conversion. It is not included in the target.
protocol AutocorrectSuggestionViewDelegate: AnyObject {
    func suggestionView(_ suggestionView: SHAutocorrectSuggestionView, wasDismissedWithAccepted accepted: Bool)
}
