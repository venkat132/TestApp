//
//  UserProfileInputModel.swift
//  PuneMetro
//
//  Created by Admin on 19/05/21.
//

import Foundation
protocol UserProfileConfirmModelProtocol {
    var showError: ((String) -> Void)? {get set}
    var goToHome:(() -> Void)? {get set}
}

class UserProfileConfirmModel: NSObject, UserProfileConfirmModelProtocol, GenericServiceDelegate {
    
    var showError: ((String) -> Void)?
    
    var goToHome: (() -> Void)?
    
    var userService: UserService?
    
    func updateProfile(user: User) {
        userService = UserService(delegate: self)
        
        let params = DaosManager.DAO_USER_UPDATE_PROFILE.replacingOccurrences(of: "[NAME]", with: user.name).replacingOccurrences(of: "[ID_USER]", with: "\(LocalDataManager.dataMgr().user.idUser)").replacingOccurrences(of: "[EMAIL]", with: user.email).replacingOccurrences(of: "[GENDER]", with: "\(user.gender!.toIntVal())").replacingOccurrences(of: "[DOB_DATE]", with: "\(user.dob.get(.day))").replacingOccurrences(of: "[DOB_MONTH]", with: "\(user.dob.get(.month))").replacingOccurrences(of: "[DOB_YEAR]", with: "\(user.dob.get(.year))").replacingOccurrences(of: "[LOCALE]", with: "\(LocalDataManager.dataMgr().userLanguage.localeVal())").replacingOccurrences(of: "[CAMPAIGNOPTED]", with: "\(user.campaignOpted)")
        userService?.updateProfileTask(params: params)
    }
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if service == userService {
            if params == UrlsManager.API_USER_UPDATE_PROFILE {
                MLog.log(string: "Update Profile Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        goToHome!()
                        return
                    } else {
                        MLog.log(string: "Update Profile Error 1")
                    }
                } catch let e {
                    MLog.log(string: "Update Profile Error:", e.localizedDescription)
                }
            }
        } else if service == service {
            if params == UrlsManager.API_USER_UPDATE_PROFILE {
                MLog.log(string: "Update Profile Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        goToHome!()
                        return
                    } else {
                        MLog.log(string: "Update Profile Error 1")
                    }
                } catch let e {
                    MLog.log(string: "Update Profile Error:", e.localizedDescription)
                }
            }
        }
    }
    
    func onDataError(error: Error, service: GenericService, params: String) {
        if service == userService {
            if params == UrlsManager.API_USER_UPDATE_PROFILE {
                MLog.log(string: "Update Profile Error:", error.localizedDescription)
            }
        }
    }
}
