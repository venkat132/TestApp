//
//  UserAuthModel.swift
//  PuneMetro
//
//  Created by Admin on 20/04/21.
//

import Foundation
import LocalAuthentication
protocol UserAuthModelProtocol {
    var didMPinChanged: ((Bool) -> Void)? {get set}
    var goToHome:(() -> Void)? {get set}
    var goToAuth:(() -> Void)? {get set}
    var showError: ((String) -> Void)? {get set}
    var wrongMpinEntered: (() -> Void)? {get set}
    var goToPin: ((String, String) -> Void)? {get set}
}

class UserAuthModel: NSObject, UserAuthModelProtocol, GenericServiceDelegate {
    var userService: UserService?

    var showError: ((String) -> Void)?
    
    var wrongMpinEntered: (() -> Void)?
    
    var didMPinChanged: ((Bool) -> Void)?

    var goToHome: (() -> Void)?
    var goToAuth: (() -> Void)?

    var goToPin: ((String, String) -> Void)?

    var mPin: String? {
        didSet {
            didMPinChanged!(mPin?.trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 4)
        }
    }

    func checkOtp() {
        if LocalDataManager.dataMgr().user.pin == mPin?.trimmingCharacters(in: .whitespacesAndNewlines) {
            goToHome!()
        } else {
            showError!("Incorrect mPin")
            wrongMpinEntered!()
        }
    }
    func requestReset() {
        userService = UserService(delegate: self)
        userService?.requestMPinResetTask()
    }
    func onDataReceived(data: Data, service: GenericService, params: String) {
        MLog.log(string: "Request mPin reset response: ", String(data: data, encoding: .utf8))
        do {
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
            guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                return
            }
            if responseObj["code"] as! Int == 200 {
                let body = responseObj["body"] as! [AnyHashable: Any]
                if body["idUser"] is Int {
                    goToPin!("\((body["idUser"] as! Int))", "\((body["mobile"] as! String).replacingOccurrences(of: "+91", with: ""))")
                } else {
                    goToPin!("\((body["idUser"] as! String))", "\((body["mobile"] as! String).replacingOccurrences(of: "+91", with: ""))")
                }
            }
        } catch let e {
            MLog.log(string: "Request mPin Reset Error:", e.localizedDescription)
        }

    }
    func onDataError(error: Error, service: GenericService, params: String) {
        MLog.log(string: "Request mPin reset error: ", error.localizedDescription)
    }
    
    // TouchID;
    func oldAuthenticateUserTouchID() {
        let context: LAContext = LAContext()
        // Declare a NSError variable.
        let myLocalizedReasonString = "Authenticate using biometrics to go to Home."
        var authError: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            context.localizedCancelTitle = "Use mPin"
            context.localizedFallbackTitle = "Try mPin"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString, reply: {success, evaluateError in
                if success // IF TOUCH ID AUTHENTICATION IS SUCCESSFUL, NAVIGATE TO NEXT VIEW CONTROLLER
                {
                    MLog.log(string: "Touch Successful")
                    self.goToHome!()
                } else // IF TOUCH ID AUTHENTICATION IS FAILED, PRINT ERROR MSG
                {
                    if let error: LAError = evaluateError as? LAError {
                        let message = self.showErrorMessageForLAErrorCode(errorCode: error.errorCode)
                        MLog.log(string: "Touch Error:", message)
//                        self.goToHome!()
                    }
                }
                
            })
        }
    }
    func authenticateUserTouchID() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            // Device can use biometric authentication
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Access requires authentication",
                reply: {(success, error) in
                        if let err = error  // IF TOUCH ID AUTHENTICATION IS FAILED, PRINT ERROR MSG
                        {
                            if let error: LAError = err as? LAError {
                                let message = self.showErrorMessageForLAErrorCode(errorCode: error.errorCode)
                                MLog.log(string: "Touch Error:", message)
                                self.goToAuth!()
                                
                            }
                        } else {
                            MLog.log(string: "Touch Successful")
                            self.goToHome!()
                        }
                })
            
        }
    }
    func showErrorMessageForLAErrorCode( errorCode: Int ) -> String {
        
        var message = ""
        if errorCode == kLAErrorBiometryLockout {
            message = "Too many failed attempts."
        } else if errorCode == kLAErrorBiometryNotEnrolled {
            message = "TouchID is not enrolled on the device"
        } else if errorCode == kLAErrorBiometryNotAvailable {
            message = "TouchID is not available on the device"
        } else {
            switch errorCode {
                
            case LAError.appCancel.rawValue:
                message = "Authentication was cancelled by application"
                
            case LAError.authenticationFailed.rawValue:
                message = "The user failed to provide valid credentials"
                
            case LAError.invalidContext.rawValue:
                message = "The context is invalid"
                
            case LAError.passcodeNotSet.rawValue:
                message = "Passcode is not set on the device"
                
            case LAError.systemCancel.rawValue:
                message = "Authentication was cancelled by the system"
                   
    //        case LAError.touchIDLockout.rawValue:
    //            message = "Too many failed attempts."
    //
    //        case LAError.touchIDNotAvailable.rawValue:
    //            message = "TouchID is not available on the device"
    //
    //        case LAError.touchIDNotEnrolled.rawValue:
    //            message = "TouchID is not enrolled on the device"
                
            case LAError.userCancel.rawValue:
                message = "The user did cancel"
                
            case LAError.userFallback.rawValue:
                message = "The user chose to use the fallback"
                
            default:
                message = "Did not find error code on LAError object"
                
            }
        }
        
        return message
        
    }
}
