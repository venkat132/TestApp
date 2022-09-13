//
//  UserProfileInputModel.swift
//  PuneMetro
//
//  Created by Admin on 19/05/21.
//

import Foundation
protocol UserProfileInputModelProtocol {
    var showError: ((String) -> Void)? {get set}
    var didInputChanged: ((Bool) -> Void)? {get set}
}

class UserProfileInputModel: NSObject, UserProfileInputModelProtocol {
    var didInputChanged: ((Bool) -> Void)?
    
    var showError: ((String) -> Void)?
    
    var name: String? {
        didSet {
//            evaluateInput()
        }
    }
    
    var email: String? {
        didSet {
//            evaluateInput()
        }
    }
    
    var gender: Gender? {
        didSet {
            evaluateInput()
        }
    }
    
    var dobDate: String = "" {
        didSet {
            evaluateInput()
        }
    }
    
    var dobMonth: String = "" {
        didSet {
            evaluateInput()
        }
    }
    
    var dobYear: String = "" {
        didSet {
            evaluateInput()
        }
    }
    
    func evaluateInput() {
        let msgName = isNameInputValid()
        let msgEmail = isEmailTextInputValid()
        let date = DateUtils.returnDate("\(dobDate)-\(dobMonth)-\(dobYear)")
        MLog.log(string: "Evaluating:", msgName, msgEmail, gender?.rawValue, date)
        didInputChanged!(msgName == nil && msgEmail == nil && gender != nil && date != nil)
        if name != nil {
            if (name?.lengthOfBytes(using: .utf8))! > 3 && msgName != nil {
                showError!("Invalid Name".localized(using: "Localization"))
            }
        }
        if email != nil {
            if (email?.lengthOfBytes(using: .utf8))! > 3 && msgEmail != nil {
                showError!("Invalid Email".localized(using: "Localization"))
            }
        }
    }
    
    func isNameInputValid() -> String? {
        var msg: String?
        
        let textInvalid = name == nil || name!.lengthOfBytes(using: String.Encoding.utf8) == 0
        
        if textInvalid {
            msg = NSLocalizedString("NAME_INVALID", comment: "")
        } else {
            let laxString = "^[a-zA-Z\\s,.'-]+$"
            let nameRegex = laxString
            let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
            msg = nameTest.evaluate(with: name) ? nil : NSLocalizedString("NAME_INVALID", comment: "")
        }
        MLog.log(string: "Name Validation:", name, textInvalid)
        return msg
    }
    
    func isEmailTextInputValid() -> String? {
        var msg: String?
        
        let textInvalid = email == nil || email!.lengthOfBytes(using: String.Encoding.utf8) == 0 || email!.contains(" ")
        
        if textInvalid {
            msg = NSLocalizedString("EMAIL_INVALID", comment: "")
        } else {
            
            let laxString = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
            let emailRegex = laxString
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            msg = emailTest.evaluate(with: email) ? nil : NSLocalizedString("EMAIL_INVALID", comment: "")
            if msg != nil {
                self.showError!("Invalid Email".localized(using: "Localization"))
            }
        }
        
        return msg
    }
}
