//
//  UserEnterOTPModel.swift
//  PuneMetro
//
//  Created by Admin on 19/04/21.
//

import Foundation
protocol UserEnterOTPModelProtocol {
    var dataDidChange: ((Bool) -> Void)? { get set }
    var setLoading: ((Bool) -> Void)? {get set}
    var showError: ((String) -> Void)? {get set}
    var showErrorNoTimeout: ((Double) -> Void)? {get set}
    var enableResend: ((Double) -> Void)? {get set}
    var goToMPin:(() -> Void)? {get set}
    var goToProfile:(() -> Void)? {get set}
    var goToHome:(() -> Void)? {get set}
}

class UserEnterOTPModel: NSObject, UserEnterOTPModelProtocol, GenericServiceDelegate {

    var userService: UserService?

    var dataDidChange: ((Bool) -> Void)?

    var setLoading: ((Bool) -> Void)?

    var enableResend: ((Double) -> Void)?
    
    var showError: ((String) -> Void)?
    
    var showErrorNoTimeout: ((Double) -> Void)?

    var goToMPin: (() -> Void)?
    
    var goToProfile: (() -> Void)?

    var goToHome: (() -> Void)?

    var otp: String? {
        didSet {
            dataDidChange!(otp!.trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 4)
        }
    }

    func validateLogin(idUser: String, deviceId: String) {
        setLoading!(true)
        userService = UserService(delegate: self)
        let params = DaosManager.DAO_USER_VALIDATE_LOGIN.replacingOccurrences(of: "[ID_USER]", with: idUser).replacingOccurrences(of: "[OTP]", with: otp!).replacingOccurrences(of: "[DEVICE_ID]", with: deviceId)
        userService?.validateLoginTask(params: params)
    }

    func resendOtp(idUser: String) {
        setLoading!(true)
        userService = UserService(delegate: self)
        let params = DaosManager.DAO_USER_RESEND_OTP.replacingOccurrences(of: "[ID_USER]", with: idUser)
        userService?.resendOtpTask(params: params)
    }

    func resetMPinValidateOTP() {
        setLoading!(true)
        userService = UserService(delegate: self)
        let params = DaosManager.DAO_USER_RESET_MPIN_VALIDATE_OTP.replacingOccurrences(of: "[OTP]", with: otp!)
        userService?.resetMPinValidateOTPTask(params: params)
    }

    func onDataReceived(data: Data, service: GenericService, params: String) {

        setLoading!(false)
        if service == userService {
            MLog.log(string: "Validate Login Response:", String(data: data, encoding: .utf8))
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                    return
                }
                if responseObj["code"] as! Int == 200 {
                    if params == UrlsManager.API_USER_RESET_MPIN_VALIDATE_OTP {
                        goToMPin!()
                    } else {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        if params == UrlsManager.API_USER_RESEND_OTP {
                            enableResend!(body["timestampOtpResendEnable"] as! Double)
                        } else {
                            LocalDataManager.dataMgr().user.initWithDictionary(userInfoJSON: body)
                            LocalDataManager.dataMgr().saveToDefaults()
                            if !LocalDataManager.dataMgr().user.pinSetup {
                                goToMPin!()
                            } else if !LocalDataManager.dataMgr().user.profileUpdated {
                                goToProfile!()
                            } else {
                                goToHome!()
                            }
                        }
                    }
                } else if responseObj["code"] as! Int == 401 {
                    showError!("Wrong OTP entered")
                } else if responseObj["code"] as! Int == 403 {
                    let msg = responseObj["message"] as! String
                    let msgObj = msg.split(separator: "-")
                    showErrorNoTimeout!(Double(msgObj[1])!)
//                    showError!("Because of multiple incorrect OTP entries, yout account weill remain blocked for \(Date(timeIntervalSince1970: Double(msgObj[1])!).timeAgoSimple()!) as a security measure.")
                }
            } catch let e {
                MLog.log(string: "Validate Login Error:", e.localizedDescription)
            }
        }
    }

    func onDataError(error: Error, service: GenericService, params: String) {
        MLog.log(string: "Validate Login Error:", error.localizedDescription)
        setLoading!(false)
    }
}
