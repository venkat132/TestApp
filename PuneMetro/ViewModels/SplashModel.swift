//
//  UserEnterOTPModel.swift
//  PuneMetro
//
//  Created by Admin on 19/04/21.
//

import Foundation
import LocalAuthentication
protocol SplashModelProtocol {
    var deviceDidChecked: ((Bool) -> Void)? {get set}
    var goToLogin: (() -> Void)? {get set}
    var goToAuth: (() -> Void)? {get set}
    var goToSetMPin: (() -> Void)? {get set}
    var goToHome: (() -> Void)? {get set}
    var goToProfile: (() -> Void)? {get set}
    var validateBiometric:(() -> Void)? {get set}
    var onHaltTrue: ((String) -> Void)? {get set}
    var shownetworktimeout: (() -> Void)? {get set}
}

class SplashModel: NSObject, SplashModelProtocol, GenericServiceDelegate {
    var shownetworktimeout: (() -> Void)?
    
    var userService: UserService?

    var deviceDidChecked: ((Bool) -> Void)?
    
    var setLoading: ((Bool) -> Void)?

    var goToLogin: (() -> Void)?

    var goToAuth: (() -> Void)?

    var goToSetMPin: (() -> Void)?

    var goToHome: (() -> Void)?
    
    var goToProfile: (() -> Void)?

    var validateBiometric: (() -> Void)?
    
    var onHaltTrue: ((String) -> Void)?
    func checkDevice(deviceId: String) {
        setLoading!(true)
        if userService == nil {
            userService = UserService(delegate: self)
        }
        let params: String = DaosManager.DAO_USER_VERIFY_TOKEN.replacingOccurrences(of: "[DEVICE_ID]", with: deviceId).replacingOccurrences(of: "[FCM_TOKEN]", with: LocalDataManager.dataMgr().fcmToken).replacingOccurrences(of: "[DEVICE_TYPE]", with: "ios").replacingOccurrences(of: "[VERSION_CODE]", with: "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)")
        userService?.checkDeviceTask(params: params)
    }
    
    func validateToken(deviceId: String) {
        setLoading!(true)
        if LocalDataManager.dataMgr().user.token.lengthOfBytes(using: .utf8) > 0 {
            if userService == nil {
                userService = UserService(delegate: self)
            }
            let params: String = DaosManager.DAO_USER_VERIFY_TOKEN.replacingOccurrences(of: "[DEVICE_ID]", with: deviceId).replacingOccurrences(of: "[FCM_TOKEN]", with: LocalDataManager.dataMgr().fcmToken).replacingOccurrences(of: "[DEVICE_TYPE]", with: "ios").replacingOccurrences(of: "[VERSION_CODE]", with: "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)")
            userService?.verifyTokenTask(params: params)
        } else {
            goToLogin!()
        }
    }
    // MARK: - check haltMessage
    func checkHaltMessage(completion: @escaping (_ result: Bool) -> () ) {
        setLoading!(true)
        if LocalDataManager.dataMgr().user.token.lengthOfBytes(using: .utf8) > 0 {
            if userService == nil {
                userService = UserService(delegate: self)
            }
            var request = URLRequest(url: URL.init(string: UrlsManager.API_GETHALTMESSAGE)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
            request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
            // insert json data to the request
            let task = session?.dataTask(with: request) {data, _, error in
                self.setLoading!(false)
                guard let data = data, error == nil else {
                    MLog.log(string: error?.localizedDescription ?? "No data")
                    completion(false)
                    return
                }
                print(request.url?.absoluteString)
                if request.url?.absoluteString == UrlsManager.API_GETHALTMESSAGE {
                        do {
                            let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                            guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                                completion(false)
                                return
                            }
                            if responseObj["code"] as! Int == 200 {
                                let bookingHaltMsg = responseObj["bookingHaltMessage"] as! String
                                LocalDataManager.dataMgr().savebookingHaltMessage(bookingHalt: bookingHaltMsg)
                                     let BookingHalt = responseObj["bookingHalt"] as! Bool
                                    LocalDataManager.dataMgr().saveBookingHalt(bookingHalt: BookingHalt)
                                completion(BookingHalt)
                                return
                            }

                        } catch let e {
                            MLog.log(string: "Verify Token Error 1:", e.localizedDescription, String(data: data, encoding: .utf8))
                            completion(false)
                            return
                        }
                    }
            }

            task?.resume()
        }
    }
    
    // MARK: - get time table
    func getTimeTable(completion: @escaping (_ result: [TimeTable]) -> Void ) {
        setLoading!(true)
        if LocalDataManager.dataMgr().user.token.lengthOfBytes(using: .utf8) > 0 {
            if userService == nil {
                userService = UserService(delegate: self)
            }
            var request = URLRequest(url: URL.init(string: UrlsManager.API_TIMETABLE)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
            request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
            // insert json data to the request
            let task = session?.dataTask(with: request) {data, _, error in
                self.setLoading!(false)
                guard let data = data, error == nil else {
                    MLog.log(string: error?.localizedDescription ?? "No data")
                    return
                }
                print(request.url?.absoluteString)
                if request.url?.absoluteString == UrlsManager.API_TIMETABLE {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                            return
                        }
                        if responseObj["code"] as! Int == 200 {
                            var TTable = [TimeTable]()
                            let titmeTableObj = responseObj["tableList"] as? NSArray ?? []
                            for TT in 0..<titmeTableObj.count {
                                let tt = TimeTable()
                                tt.initWithDictionary(TTObj: titmeTableObj[TT] as? [AnyHashable : Any] ?? [:])
                                TTable.append(tt)
                            }
                            completion(TTable)
                            return
                        }
                        
                    } catch let e {
                        MLog.log(string: "Verify Token Error 1:", e.localizedDescription, String(data: data, encoding: .utf8))
                        return
                    }
                }
            }
            
            task?.resume()
        }
    }
    
    func onDataReceived(data: Data, service: GenericService, params: String) {

        setLoading!(false)
        if service == userService {
            if params == UrlsManager.API_USER_VERIFY_TOKEN {
                MLog.log(string: "Verify Token Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        LocalDataManager.dataMgr().user.initWithDictionary(userInfoJSON: body)
                        LocalDataManager.dataMgr().saveToDefaults()
                        if responseObj["halt"] != nil || responseObj["forceUpdate"] != nil {
                            if (responseObj["halt"] as! Bool || responseObj["forceUpdate"] as! Bool) {
                                onHaltTrue!(responseObj["haltMessage"] as! String)
                                return
                            }
                        }
                        if responseObj["bookingHalt"] != nil {
                            let bookingHalt = responseObj["bookingHalt"] as! Bool
                            LocalDataManager.dataMgr().saveBookingHalt(bookingHalt: bookingHalt)
                        }
                        let bookingHalt = responseObj["bookingHaltMessage"] as! String
                        LocalDataManager.dataMgr().savebookingHaltMessage(bookingHalt: bookingHalt)
                        MLog.log(string: "Splash Pin Setup:", LocalDataManager.dataMgr().user.pinSetup, LocalDataManager.dataMgr().user.profileUpdated)
//                        if !LocalDataManager.dataMgr().user.pinSetup {
//                            goToSetMPin!()
//                        } else
                        let updatedProfile = body["updatedProfile"] as? Bool ?? false
                        if updatedProfile {
                            let enableAppLock = body["enableAppLock"] as? String ?? ""
                                if enableAppLock == "1" {
                                    LocalDataManager.dataMgr().saveEnableAppLock(appLock: true)
                                    validateBiometric!()
                                } else {
                                    LocalDataManager.dataMgr().saveEnableAppLock(appLock: false)
                                    goToHome!()
                                }
                        } else {
                            goToSetMPin!()
                        }
//                        if !LocalDataManager.dataMgr().user.profileUpdated {
//                            goToProfile!()
//                        }
                            
                        return
                    }
                    goToLogin!()

                } catch let e {
                    MLog.log(string: "Verify Token Error 1:", e.localizedDescription, String(data: data, encoding: .utf8))
                    goToLogin!()
                }
            } else if params == UrlsManager.API_USER_CHECK_DEVICE {
                MLog.log(string: "Check Device Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        if responseObj["halt"] != nil {
                            if(responseObj["halt"] as! Bool) {
                                onHaltTrue!(responseObj["haltMessage"] as! String)
                                return
                            }
                        }
                        if responseObj["bookingHalt"] != nil {
                            let bookingHalt = responseObj["bookingHalt"] as! Bool
                            LocalDataManager.dataMgr().saveBookingHalt(bookingHalt: bookingHalt)
                            let bookingHaltMsg = responseObj["bookingHaltMessage"] as! String
                            LocalDataManager.dataMgr().savebookingHaltMessage(bookingHalt: bookingHaltMsg)
                        }
                       
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
        MLog.log(string: "Verify Token Error 2:", error.localizedDescription, params)
        setLoading!(false)
        if params == UrlsManager.API_USER_CHECK_DEVICE {
            if LocalDataManager.dataMgr().user.token.lengthOfBytes(using: .utf8) > 2 {
                validateBiometric!()// Offline
            } else {
                
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
                    MLog.log(string: "Biometric Error:", evaluateError?.localizedDescription)
                    if let error: LAError = evaluateError as? LAError {
                        let message = self.showErrorMessageForLAErrorCode(errorCode: error.errorCode)
                        MLog.log(string: "Touch Error:", message)
                        if LocalDataManager.dataMgr().user.profileUpdated {
                            self.goToAuth!()
                        } else {
                            self.goToProfile!()
                        }
                    }
                }

            })
        } else {
            MLog.log(string: "Biometric not available")
            self.goToAuth!()
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
                        if let err = error {
                            MLog.log(string: "Biometric Error:", err.localizedDescription)
                            if let error: LAError = err as? LAError {
                                let message = self.showErrorMessageForLAErrorCode(errorCode: error.errorCode)
                                MLog.log(string: "Touch Error:", message)
                                if LocalDataManager.dataMgr().user.profileUpdated {
                                    self.goToAuth!()
                                } else {
                                    self.goToProfile!()
                                }
                            }
                        } else {
                            MLog.log(string: "Touch Successful")
                            self.goToHome!()
                        }
                })
            
        } else {
            MLog.log(string: "Biometric not available")
            self.goToAuth!()
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
