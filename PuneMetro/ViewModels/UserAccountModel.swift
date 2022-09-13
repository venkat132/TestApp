//
//  UserAccountModel.swift
//  PuneMetro
//
//  Created by Admin on 06/07/21.
//

import Foundation
protocol UserAccountModelProtocol {
    var didInputChanged: ((Bool) -> Void)? {get set}
    var showError: ((String) -> Void)? {get set}
    var didChangeEdit: (() -> Void)? {get set}
    var didReceiveProfile: (() -> Void)? {get set}
    var didReceiveOptingCampaigns: (() -> Void)? {get set}
    var goBack: (() -> Void)? {get set}
}
class UserAccountModel: NSObject, UserAccountModelProtocol, GenericServiceDelegate {
    var didInputChanged: ((Bool) -> Void)?
    var showError: ((String) -> Void)?
    var didChangeEdit: (() -> Void)?
    var didReceiveProfile: (() -> Void)?
    var didReceiveOptingCampaigns: (() -> Void)?
    var goBack: (() -> Void)?
    var userService: UserService?
    var promotionResp: [String: String]?
    var user = User() {
        didSet {
            self.didReceiveProfile!()
        }
    }
    var isEdit: Bool = false {
        didSet {
            didChangeEdit!()
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
        MLog.log(string: "Evaluating:", msgName, msgEmail, user.gender?.rawValue, date)
        didInputChanged!(msgName == nil && msgEmail == nil && user.gender != nil && date != nil)
        if (user.name.lengthOfBytes(using: .utf8)) > 3 && msgName != nil {
            showError!("Invalid Name".localized(using: "Localization"))
        }
        if (user.email.lengthOfBytes(using: .utf8)) > 3 && msgEmail != nil {
            showError!("Invalid Email".localized(using: "Localization"))
        }
    }
    
    func isNameInputValid() -> String? {
        var msg: String?
        
        let textInvalid = user.name.lengthOfBytes(using: String.Encoding.utf8) == 0
        
        if textInvalid {
            msg = NSLocalizedString("NAME_INVALID", comment: "")
        } else {
            let laxString = "^[a-zA-Z\\s,.'-]+$"
            let nameRegex = laxString
            let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
            msg = nameTest.evaluate(with: user.name) ? nil : NSLocalizedString("NAME_INVALID", comment: "")
        }
        MLog.log(string: "Name Validation:", user.name, textInvalid)
        return msg
    }
    
    func isEmailTextInputValid() -> String? {
        var msg: String?
        
        let textInvalid = user.email.lengthOfBytes(using: String.Encoding.utf8) == 0 || user.email.contains(" ")
        
        if textInvalid {
            msg = NSLocalizedString("EMAIL_INVALID", comment: "")
        } else {
            
            let laxString = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
            let emailRegex = laxString
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            msg = emailTest.evaluate(with: user.email) ? nil : NSLocalizedString("EMAIL_INVALID", comment: "")
            if msg != nil {
                self.showError!("Invalid Email".localized(using: "Localization"))
            }
        }
        
        return msg
    }
    func getProfile() {
        if userService == nil {
            userService = UserService(delegate: self)
        }
        userService?.getProfileTask()
    }
    func updateProfile() {
        if userService == nil {
            userService = UserService(delegate: self)
        }
        let params = DaosManager.DAO_USER_UPDATE_PROFILE.replacingOccurrences(of: "[NAME]", with: user.name).replacingOccurrences(of: "[ID_USER]", with: "\(LocalDataManager.dataMgr().user.idUser)").replacingOccurrences(of: "[EMAIL]", with: user.email).replacingOccurrences(of: "[GENDER]", with: "\(user.gender!.toIntVal())").replacingOccurrences(of: "[DOB_DATE]", with: "\(user.dob.get(.day))").replacingOccurrences(of: "[DOB_MONTH]", with: "\(user.dob.get(.month))").replacingOccurrences(of: "[DOB_YEAR]", with: "\(user.dob.get(.year))")
        userService?.updateProfileTask(params: params)
    }
    func optingCampaigns(campaignOpted: String, enableAppLock: String) {
        if userService == nil {
            userService = UserService(delegate: self)
        }
        let params = DaosManager.DAO_USER_UPDATE_SETTINGS.replacingOccurrences(of: "[CAMPAIGNOPTED]", with: campaignOpted).replacingOccurrences(of: "[ENABLEAPPLOCK]", with: enableAppLock)
        userService?.updateOptingCampaigns(params: params)
    }
    func sendVerifyEmail() {
        if userService == nil {
            userService = UserService(delegate: self)
        }
        let params = DaosManager.DAO_USER_SEND_VERIFY_EMAIL.replacingOccurrences(of: "[LOCALE]", with: LocalDataManager.dataMgr().userLanguage.localeVal())
        userService?.sendVerifyEmailTask(params: params)
    }
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if service == userService {
            if params == UrlsManager.API_USER_GET_PROFILE {
                MLog.log(string: "Get Profile Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        let profileObj = body["profile"] as? [AnyHashable: Any]
                        if let pDataprofileObj = profileObj {
                        let enableAppLock = pDataprofileObj["enableAppLock"] as? String ?? ""
                        let campaignOpted = pDataprofileObj["campaignOpted"] as? String ?? ""
                            promotionResp = ["enableAppLock": enableAppLock, "campaignOpted": campaignOpted]
                        LocalDataManager.dataMgr().saveCampaignOpted(bookingHalt: campaignOpted)
                        LocalDataManager.dataMgr().saveEnableAppLock(bookingHalt: enableAppLock)
                        self.user.initWithProfileDictionary(profileJSON: pDataprofileObj)
                        }
                        didReceiveProfile!()
                        return
                    }
                    MLog.log(string: "Get Profile Error")
                } catch let e {
                    MLog.log(string: "Get Profile Error 1:", e.localizedDescription, String(data: data, encoding: .utf8))
                }
            } else if params == UrlsManager.API_USER_UPDATE_PROFILE {
                MLog.log(string: "Update Profile Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        LocalDataManager.dataMgr().user = self.user
                        LocalDataManager.dataMgr().saveToDefaults()
                        goBack!()
                        return
                    } else {
                        MLog.log(string: "Update Profile Error 1")
                    }
                } catch let e {
                    MLog.log(string: "Update Profile Error:", e.localizedDescription)
                }
                showError!("Something went wrong...".localized(using: "Localization"))
            } else if params == UrlsManager.API_USER_SEND_VERIFY_EMAIL {
                MLog.log(string: "Send Verify Email Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        goBack!()
                        return
                    } else {
                        MLog.log(string: "Send Verify Email Error 1")
                    }
                } catch let e {
                    MLog.log(string: "Send Verify Email Error:", e.localizedDescription)
                }
                showError!("Something went wrong...".localized(using: "Localization"))
            } else if params == UrlsManager.API_SETTINGS {
                MLog.log(string: "Setting Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        didReceiveOptingCampaigns!()
                        return
                    } else {
                        MLog.log(string: "Send Verify Email Error 1")
                    }
                } catch let e {
                    MLog.log(string: "Send Verify Email Error:", e.localizedDescription)
                }
                showError!("Something went wrong...".localized(using: "Localization"))
            }
        }
    }
    
    func onDataError(error: Error, service: GenericService, params: String) {
        
    }
    
}
