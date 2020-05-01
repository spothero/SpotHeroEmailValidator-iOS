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
        self.emailTextField.setMessage("Email address syntax is invalid.", forErrorCode: Int(SpotHeroEmailValidator.Error.invalidSyntax.rawValue))
        
        // Uncomment these lines to configure the look and feel of the suggestion popup
//        self.emailTextField.bubbleFillColor = .white
//        self.emailTextField.bubbleTitleColor = .black
//        self.emailTextField.bubbleSuggestionColor = .red
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
