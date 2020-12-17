// Copyright © 2020 SpotHero, Inc. All rights reserved.

#if canImport(UIKit)

    import Foundation
    import UIKit

    class EmailTextFieldDelegate: NSObject {
        weak var target: SHEmailValidationTextField?
        weak var subDelegate: UITextFieldDelegate?
    
        init(target: SHEmailValidationTextField) {
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
        
            return self.subDelegate?.textFieldShouldEndEditing?(textField) ?? true
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
