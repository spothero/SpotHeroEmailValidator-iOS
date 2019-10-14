//
//  ViewController.swift
//  SpotHeroEmailValidatorSwiftDemo
//
//  Created by Brian Drelling on 10/13/19.
//  Copyright © 2019 SpotHero, Inc. All rights reserved.
//

import SpotHeroEmailValidator
import UIKit

class ViewController: UIViewController {
    @IBOutlet private var explanationLabel: UILabel!
    @IBOutlet private var emailTextField: SHEmailValidationTextField!
    @IBOutlet private var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.explanationLabel.text = "Enter an email address into the UITextField, then proceed to the password field for validation. Addresses such as test@gamil.con will produce an autocorrect suggestion."
        
        self.emailTextField.delegate = self
        self.emailTextField.setMessage("Email address syntax is invalid.", forErrorCode: Int(SHInvalidSyntaxError.rawValue))
        
        // Uncomment these lines to configure the look and feel of the suggestion popup
    //    self.emailTextField.bubbleFillColor = [UIColor whiteColor];
    //    self.emailTextField.bubbleTitleColor = [UIColor blackColor];
    //    self.emailTextField.bubbleSuggestionColor = [UIColor redColor];
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.emailTextField.hostWillAnimateRotation(to: toInterfaceOrientation)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField == self.emailTextField else {
            return false
        }
        
        return self.passwordTextField.becomeFirstResponder()
    }
}
