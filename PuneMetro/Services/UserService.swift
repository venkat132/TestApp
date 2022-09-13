//
//  UserService.swift
//  PuneMetro
//
//  Created by Admin on 19/04/21.
//

import Foundation

class UserService: GenericService {
    public func checkDeviceTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_CHECK_DEVICE)!)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        
        request.httpBody = params.data(using: .utf8)

        MLog.log(string: "Check Device data:", params)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }
        task?.resume()
    }
    
    public func initiateLoginTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_INITIATE_LOGIN)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Initiate Login data:", request)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }
        
        task?.resume()
    }

    public func validateLoginTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_VALIDATE_LOGIN)!)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        
        request.httpBody = params.data(using: .utf8)

        MLog.log(string: "Validate Login data:", request)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }

        task?.resume()
    }

    public func resendOtpTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_RESEND_OTP)!)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        
        request.httpBody = params.data(using: .utf8)

        MLog.log(string: "Resend OTP data:", request)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }

        task?.resume()
    }

    public func verifyTokenTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_VERIFY_TOKEN)!)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Verify Token data:", params)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }

            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }

        task?.resume()
    }
    
    public func updateProfileTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_UPDATE_PROFILE)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Update Profile data:", params)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }
        
        task?.resume()
    }
    public func updateOptingCampaigns(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_SETTINGS)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Update Profile data:", params)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }
        
        task?.resume()
    }
    
    public func getProfileTask() {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_GET_PROFILE)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }
        
        task?.resume()
    }

    public func requestMPinResetTask() {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_RESET_MPIN_REQUEST_OTP)!)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")

        MLog.log(string: "Reset mPin Request data:", request)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }

        task?.resume()
    }

    public func resetMPinValidateOTPTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_RESET_MPIN_VALIDATE_OTP)!)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.httpBody = params.data(using: .utf8)

        MLog.log(string: "Reset MPin Validate data:", request)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }

        task?.resume()
    }

    public func updateMPinTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_UPDATE_MPIN)!)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.httpBody = params.data(using: .utf8)

        MLog.log(string: "Update MPin data:", request)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }
        task?.resume()
    }
    
    public func sendVerifyEmailTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_SEND_VERIFY_EMAIL)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Send Verify Email data:", request)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }
        task?.resume()
    }
    public func getBanners(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_USER_SEND_VERIFY_EMAIL)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Send Verify Email data:", request)
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }
        task?.resume()
    }
}
