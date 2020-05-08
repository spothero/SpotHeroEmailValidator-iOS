//
//  SHAutocorrectSuggestionView.swift
//  SpotHeroEmailValidator
//
//  Created by Brian Drelling on 5/7/20.
//  Copyright © 2020 SpotHero, Inc. All rights reserved.
//

import Foundation
import UIKit

public typealias SetupBlock = (SHAutocorrectSuggestionView?) -> Void

// Work In Progress -- This is a boilerplate file for Swift conversion. It is not included in the target.
public class SHAutocorrectSuggestionView {
    weak var delegate: AutocorrectSuggestionViewDelegate?

    public var suggestedText: String?
    public var fillColor: UIColor?
    public var titleColor: UIColor?
    public var suggestionColor: UIColor?

    public static func defaultFillColor() -> UIColor { return .black }
    public static func defaultTitleColor() -> UIColor { return .white }
    public static func defaultSuggestionColor() -> UIColor { return UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0) }
    
    public static func show(from target: UIView,
                            title: String?,
                            autocorrectSuggestion suggestion: String?,
                            withSetupBlock block: SetupBlock) -> SHAutocorrectSuggestionView { return SHAutocorrectSuggestionView() }

    public static func show(from target: UIView,
                            inContainerView container: UIView,
                            title: String?,
                            autocorrectSuggestion suggestion: String?,
                            withSetupBlock block: SetupBlock) -> SHAutocorrectSuggestionView { return SHAutocorrectSuggestionView() }

    public func updatePosition() { }

    public func dismiss() { }
}
