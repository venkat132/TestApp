//
//  User.swift
//  PuneMetro
//
//  Created by Admin on 20/04/21.
//

import Foundation

class User {
    public var idUser: Int = 0
    public var token: String = ""
    public var verifiedEmail: Bool = false
    public var verifiedDob: Bool = false
    public var verifiedName: Bool = false
    public var profileUpdated: Bool = false
    public var pinSetup: Bool = false
    public var pin: String = ""
    // KYC
    public var mobile: String = ""
    public var name: String = ""
    public var email: String = ""
    public var gender: Gender?
    public var dob: Date = Date()
    public var KYCStatus: Int = 0
    public var BookingHalt: Bool = true
    public var campaignOpted: String = ""
    func initWithDictionary(userInfoJSON: [AnyHashable: Any]) {
        if userInfoJSON["idUser"] is Int {
            self.idUser = userInfoJSON["idUser"] as! Int
        } else {
            self.idUser = Int(userInfoJSON["idUser"] as! String)!
        }
        self.mobile = userInfoJSON["mobile"] as! String
        self.name = (userInfoJSON["name"] ?? "") as! String
        self.token = userInfoJSON["token"] as! String
        self.verifiedEmail = userInfoJSON["verifiedEmail"] as! Bool
        self.verifiedDob = userInfoJSON["verifiedDob"] as! Bool
        self.verifiedName = userInfoJSON["verifiedName"] as! Bool
        self.profileUpdated = (userInfoJSON["updatedProfile"] ?? false) as! Bool
        self.pinSetup = userInfoJSON["pinSetup"] as! Bool
        if userInfoJSON["pin"] is NSNull {
            self.pin = ""
        } else {
            self.pin = userInfoJSON["pin"] as! String
        }
        if userInfoJSON["kyc"] is NSNull {
            self.KYCStatus = 0
        } else {
            self.KYCStatus = userInfoJSON["kyc"] as! Int
        }
        LocalDataManager.sharedInstance?.saveUserId(userId: "\(self.idUser)")
        LocalDataManager.sharedInstance?.saveUserMobileNumber(mobileNumber: self.mobile)
        MLog.log(string: "User Initiated:", userInfoJSON)
    }
    
    func initWithProfileDictionary(profileJSON: [AnyHashable: Any]) {
        if profileJSON["idUser"] is Int {
            self.idUser = profileJSON["idUser"] as? Int ?? 0
        } else {
            self.idUser = Int(profileJSON["idUser"] as? String ?? "") ?? 0
        }
        self.name = profileJSON["name"] as? String ?? ""
        switch profileJSON["gender"] as? Int ?? 0 {
        case 0:
            self.gender = .Male
        case 1:
            self.gender = .Female
        case 2:
            self.gender = .Transgender
        default:
            MLog.log(string: "Gender Invalid")
        }
        self.email = profileJSON["email"] as? String ?? ""
        self.dob = DateUtils.returnDate("\(profileJSON["dobDate"] as? Int ?? 0)-\(Globals.MONTHS[profileJSON["dobMonth"] as? Int ?? 0 - 1])-\(profileJSON["dobYear"] as? Int ?? 0)")!
//        {\"id\":3,\"idUser\":2,\"name\":\"Ninad Thatte \",\"dobDate\":3,\"dobMonth\":7,\"dobYear\":1986,\"email\":\"megotechnologies@gmail.com\",\"gender\":0,\"emailVerificationCode\":\"5746\",\"emailVerificationExpiry\":1625379995,\"createdAt\":\"2021-07-03T06:26:35.000Z\",\"updatedAt\":\"2021-07-05T06:52:53.000Z\"}
    }
}

enum Gender: String {
    case Male
    case Female
    case Transgender
    
    func toIntVal() -> Int {
        switch self {
        case .Male: return 0
        case .Female: return 1
        case .Transgender: return 2
        }
    }
}
