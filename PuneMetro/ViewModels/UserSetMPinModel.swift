//
//  UserEnterOTPModel.swift
//  PuneMetro
//
//  Created by Admin on 19/04/21.
//

import Foundation

protocol UserSetMPinModelProtocol {
    var dataDidChange: ((Bool) -> Void)? { get set }
    var showError: ((String) -> Void)? {get set}
    var setLoading: ((Bool) -> Void)? {get set}
    var confChange: ((Bool) -> Void)? {get set}
    var goToHome:(() -> Void)? {get set}
    var goToProfile:(() -> Void)? {get set}
}

class UserSetMPinModel: NSObject, UserSetMPinModelProtocol, GenericServiceDelegate {

    var userService: UserService?

    var dataDidChange: ((Bool) -> Void)?
    
    var showError: ((String) -> Void)?

    var setLoading: ((Bool) -> Void)?

    var confChange: ((Bool) -> Void)?

    var goToHome: (() -> Void)?
    
    var goToProfile: (() -> Void)?

    var isConf: Bool? {
        didSet {
            confChange!(isConf!)
            dataDidChange!((isConf! ? (otpConf ?? "") : (otp ?? "")).trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 4)
        }
    }

    var otp: String? {
        didSet {
            dataDidChange!((isConf! ? otpConf! : otp!).trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 4)
        }
    }

    var otpConf: String? {
        didSet {
            dataDidChange!(((isConf! ? otpConf! : otp!).trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 4) && (isConf! ? (otpConf! == otp!) : true))
        }
    }

    func updateMPin() {
        setLoading!(true)
        userService = UserService(delegate: self)
        let params = DaosManager.DAO_USER_UPDATE_MPIN.replacingOccurrences(of: "[MPIN]", with: otpConf!)
        userService?.updateMPinTask(params: params)

    }

    func onDataReceived(data: Data, service: GenericService, params: String) {

        setLoading!(false)
        if service == userService {
            MLog.log(string: "Update MPin Response:", String(data: data, encoding: .utf8))
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                    return
                }
                if responseObj["code"] as! Int == 200 {
                    if LocalDataManager.dataMgr().user.profileUpdated {
                        goToHome!()
                    } else {
                        goToProfile!()
                    }
                }
            } catch let e {
                MLog.log(string: "Update MPin Error:", e.localizedDescription)
            }
        }
    }

    func onDataError(error: Error, service: GenericService, params: String) {
        MLog.log(string: "Update MPin Error:", error.localizedDescription)
        setLoading!(false)
    }
}
