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

#if canImport(UIKit)

import Foundation
import UIKit

class EmailTextFieldDelegate: NSObject {
    weak var target: SHEmailValidationTextField?
    @objc weak var subDelegate: UITextFieldDelegate?
    
    @objc init(target: SHEmailValidationTextField) {
        self.target = target
    }
}

extension EmailTextFieldDelegate: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.target?.dismissSuggestionView()
        
        return self.subDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.subDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.target?.validateInput()
        
       return  self.subDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.subDelegate?.textFieldDidEndEditing?(textField)
    }
    
    func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        return self.subDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.subDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.subDelegate?.textFieldShouldReturn?(textField) ?? true
    }
}

#endif
