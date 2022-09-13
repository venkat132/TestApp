//
//  UserLoginViewModel.swift
//  PuneMetro
//
//  Created by Admin on 19/04/21.
//

import Foundation
protocol UserLoginViewModelProtocol {
    var deviceDidChecked: ((Bool) -> Void)? {get set}
    var dataDidChange: ((Bool, Bool, Bool) -> Void)? { get set }
    var setLoading: ((Bool) -> Void)? { get set }
    var goToPin: ((String, Double) -> Void)? { get set }
    var showError: ((String) -> Void)? {get set}
    var showErrorNoTimeout: ((Double) -> Void)? {get set}
    var shownetworktimeout: (() -> Void)? {get set}
}

class UserLoginViewModel: NSObject, UserLoginViewModelProtocol, GenericServiceDelegate {
    var shownetworktimeout: (() -> Void)?
    
    var deviceDidChecked: ((Bool) -> Void)?
    
    var userService: UserService?

    var dataDidChange: ((Bool, Bool, Bool) -> Void)?

    var setLoading: ((Bool) -> Void)?

    var goToPin: ((String, Double) -> Void)?

    var showError: ((String) -> Void)?
    
    var showErrorNoTimeout: ((Double) -> Void)?

    var isTermsAccepted: Bool? {
        didSet {
            let msg = isMobileTextInputValid()
            dataDidChange!(isTermsAccepted ?? false, isInfoAccepted ?? false, (msg == nil))
        }
    }

    var isInfoAccepted: Bool? {
        didSet {
            let msg = isMobileTextInputValid()
            dataDidChange!(isTermsAccepted ?? false, isInfoAccepted ?? false, (msg == nil))
        }
    }

    var mobileNumber: String? {
        didSet {
            let msg = isMobileTextInputValid()
            dataDidChange!(isTermsAccepted ?? false, isInfoAccepted ?? false, (msg == nil))
        }
    }

    func isMobileTextInputValid() -> String? {
        var msg: String?

        let textInvalid = mobileNumber == nil || mobileNumber!.lengthOfBytes(using: String.Encoding.utf8) == 0 || mobileNumber!.contains(" ")

        if textInvalid {
            msg = NSLocalizedString("MOBILE_INVALID", comment: "")
        } else {

            let mobileRegex = "^[6789]\\d{9}$"
            let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
            msg = mobileTest.evaluate(with: mobileNumber) ? nil : NSLocalizedString("MOBILE_INVALID", comment: "")
        }

        return msg
    }
    
    func checkDevice(deviceId: String) {
        setLoading!(true)
        userService = UserService(delegate: self)
        let params: String = DaosManager.DAO_USER_CHECK_DEVICE.replacingOccurrences(of: "[DEVICE_ID]", with: deviceId).replacingOccurrences(of: "[FCM_TOKEN]", with: LocalDataManager.dataMgr().fcmToken)
        userService?.checkDeviceTask(params: params)
    }

    func initiateLogin(mobileInput: String) {
        setLoading!(true)
        let mobile = "+91" + mobileInput
        userService = UserService(delegate: self)
        let params: String = DaosManager.DAO_USER_INITIATE_LOGIN.replacingOccurrences(of: "[MOBILE]", with: mobile)
        userService?.initiateLoginTask(params: params)
    }

    func onDataReceived(data: Data, service: GenericService, params: String) {
        setLoading!(false)
        if service == userService {
            if params == UrlsManager.API_USER_INITIATE_LOGIN {
                MLog.log(string: "Initiate Login Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        if body["idUser"] is Int {
                            goToPin!("\((body["idUser"] as! Int))", (body["timestampOtpResendEnable"] as! Double))
                        } else {
                            goToPin!("\((body["idUser"] as! String))", (body["timestampOtpResendEnable"] as! Double))
                        }
                    } else if responseObj["code"] as! Int == 403 {
                        let msg = responseObj["message"] as! String
                        let msgObj = msg.split(separator: "-")
                        showErrorNoTimeout!(Double(msgObj[1])!)
                    }
                } catch let e {
                    MLog.log(string: "Initiate Login Error:", e.localizedDescription)
                }
            } else if params == UrlsManager.API_USER_CHECK_DEVICE {
                MLog.log(string: "Check Device Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        deviceDidChecked!(body["usedBefore"] as! Bool)
                        return
                    } else {
                        MLog.log(string: "Check Device Error 1")
                    }
                } catch let e {
                    MLog.log(string: "Check Device Error:", e.localizedDescription)
                }
                deviceDidChecked!(false)
            }
        }
    }

    func onDataError(error: Error, service: GenericService, params: String) {
        setLoading!(false)
        if service == userService {
            if params == UrlsManager.API_USER_INITIATE_LOGIN {
                MLog.log(string: "Initiate Login Error:", error.localizedDescription )
                showError!("Error: Try again!".localized(using: "Localization"))
            } else if params == UrlsManager.API_USER_CHECK_DEVICE {
                MLog.log(string: "Get Fare Error:", error.localizedDescription)
            }
            let code = (error as NSError).code
            switch code {
            case NSURLErrorTimedOut, NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorCannotConnectToHost:
                shownetworktimeout!()
            default:
                MLog.log(string: "Error:", error.localizedDescription, params)
            }
        }
    }
}
