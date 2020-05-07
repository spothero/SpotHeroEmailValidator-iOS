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

import Foundation
import UIKit

public class SHEmailValidationTextField: UITextField {
    var suggestionView: SHAutocorrectSuggestionView?
    var emailValidator: SpotHeroEmailValidator?
    var delegateProxy: EmailTextFieldDelegate?
    var messageDictionary: [Int: String]?
    
    public var defaultErrorMessage: String?
    public var messageForSuggestion: String?
    public var validationError: Error?
    
    public var bubbleFillColor: UIColor? {
        didSet {
            self.suggestionView?.fillColor = self.bubbleFillColor
        }
    }
    
    public var bubbleTitleColor: UIColor? {
        didSet {
            self.suggestionView?.titleColor = self.bubbleTitleColor
        }
    }
    
    public var bubbleSuggestionColor: UIColor? {
        didSet {
            self.suggestionView?.suggestionColor = self.bubbleSuggestionColor
        }
    }
    
    override public var delegate: UITextFieldDelegate? {
        get {
            return super.delegate
        }
        set {
            if newValue is EmailTextFieldDelegate {
                super.delegate = newValue
            } else {
                self.delegateProxy?.subDelegate = newValue
            }
        }
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.initialize()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    private func initialize() {
        self.delegateProxy = EmailTextFieldDelegate(target: self)
        self.delegate = self.delegateProxy
        self.emailValidator = SpotHeroEmailValidator.shared
        self.autocapitalizationType = .none
        self.keyboardType = .emailAddress
        self.autocorrectionType = .no
        self.messageDictionary = [:]
        self.defaultErrorMessage = "Please enter a valid email address"
        self.messageForSuggestion = "Did you mean"
        
        self.bubbleFillColor = SHAutocorrectSuggestionView.defaultFillColor()
        self.bubbleTitleColor = SHAutocorrectSuggestionView.defaultTitleColor()
        self.bubbleSuggestionColor = SHAutocorrectSuggestionView.defaultSuggestionColor()
    }
    
    public func dismissSuggestionView() {
        self.suggestionView?.dismiss()
    }
    
    public func validateInput() {
        guard let text = self.text, text.count > 0 else {
            return
        }
        
        // TODO: This method can be drastically reduced, lots of redundant code
        do {
            let validationResult = try self.emailValidator?.validateAndAutocorrect(emailAddress: text)
            
            self.validationError = nil
            
            if let autocorrectSuggestion = validationResult?.autocorrectSuggestion {
                self.suggestionView = SHAutocorrectSuggestionView.show(from: self,
                                                                       title: self.messageForSuggestion,
                                                                       autocorrectSuggestion: autocorrectSuggestion,
                                                                       withSetupBlock: { [weak self] view in
                                                                        view?.fillColor = self?.bubbleFillColor
                                                                        view?.titleColor = self?.bubbleTitleColor
                                                                        view?.suggestionColor = self?.bubbleSuggestionColor
                })
                
                self.suggestionView?.delegate = self
            }
        } catch {
            self.validationError = error
            
            var message = self.messageDictionary?[(error as NSError).code]
            
            if message?.isEmpty == true {
                message = self.defaultErrorMessage
            }

            self.suggestionView = SHAutocorrectSuggestionView.show(from: self,
                                                                   title: message,
                                                                   autocorrectSuggestion: nil,
                                                                   withSetupBlock: { [weak self] view in
                                                                    view?.fillColor = self?.bubbleFillColor
                                                                    view?.titleColor = self?.bubbleTitleColor
                                                                    view?.suggestionColor = self?.bubbleSuggestionColor
            })
            
            self.suggestionView?.delegate = self
        }
    }

    public func setMessage(_ message: String, forErrorCode errorCode: Int) {
        self.messageDictionary?[errorCode] = message
    }
}

extension SHEmailValidationTextField: AutocorrectSuggestionViewDelegate {
    public func suggestionView(_ suggestionView: SHAutocorrectSuggestionView!, wasDismissedWithAccepted accepted: Bool) {
        if accepted {
            self.text = suggestionView.suggestedText
        }
    }
}

#if !os(tvOS)

extension SHEmailValidationTextField {
    public func hostWillAnimateRotation(to interfaceOrientation: UIInterfaceOrientation) {
        self.suggestionView?.updatePosition()
    }
}

#endif
