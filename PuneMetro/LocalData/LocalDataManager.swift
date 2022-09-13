//
//  StorageManager.swift
//  PuneMetro
//
//  Created by Admin on 20/04/21.
//

import Foundation
import UIKit

// value keys
let metroTokenKey: String! = "metroTokenKey"
let metroUserIDKey: String! = "metroUserIDKey"
let metroVerifiedEmailKey: String! = "metroVerifiedEmailKey"
let metroVerifiedDobKey: String! = "metroVerifiedDobKey"
let metroVerifiedNameKey: String! = "metroVerifiedNameKey"
let metroProfileUpdatedKey: String! = "metroProfileUpdatedKey"
let metroPinSetupKey: String! = "metroPinSetupKey"
let metroPinKey: String! = "metroPinKey"
let metroStationsKey: String! = "metroStationsKey"
let metroSetKey: String! = "metroSetKey"
let metroActiveTicketsKey: String! = "metroActiveTicketsKey"
let metroPGKey: String! = "metroPGKey"
let metroPGHashPaymentDetailsKey: String! = "metroPGHashPaymentDetailsKey"
let metroPGHashVasForMobileKey: String! = "metroPGHashVasForMobileKey"
let metroWrongMPinAttemptsKey: String! = "metroWrongMPinAttemptsKey"
let metroBlockMPinTimeKey: String! = "metroBlockMPinTimeKey"
let metroUserLanguageKey: String! = "metroUserLanguageKey"

// Encryption Key
let metroEncryptionKey: String! = "metroIOSSwift916"

class LocalDataManager: NSObject {

    static var sharedInstance: LocalDataManager? = LocalDataManager()

    public static func dataMgr() -> LocalDataManager {
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.async {
            if sharedInstance == nil {
                MLog.log(string: "storageMgr: Initializing storage manager")
                sharedInstance = .init()
            }
        }
        return sharedInstance!
    }

    public var user: User
    public var sets: [Sets]
    public var stations: [Station]
    public var aquaStations: [Station]
    public var purpleStations: [Station]
    public var PGKey: String
    public var PGHashVasForMobile: String
    public var PGHashPaymentDetails: String
    public var PGEncryptedToken: String
    public var touristPlaces: [TourPlace]
    public var activeTicketsStr: String = "[]"
    public var userLanguage: Language = .english
    public var fcmToken: String
    public var wrongMPins: Int = 0
    public var blockMPinTime: Date?
    public var brightness: CGFloat = 1.0
    public var BookingHalt: Bool = true
    override init() {
        user = User()
        sets = []
        stations = []
        aquaStations = []
        purpleStations = []
        touristPlaces = []
        PGKey = ""
        PGHashVasForMobile = ""
        PGHashPaymentDetails = ""
        PGEncryptedToken = ""
        fcmToken = ""
        super.init()
        _ = self.loadFromDefaults()
    }

    func loadFromDefaults() -> Bool {
        let defaults: UserDefaults = UserDefaults.standard
        if defaults.data(forKey: metroTokenKey) == nil {
            MLog.log(string: "Defaults nil")
            return true
        }

        do {
            let idUser = try (StorageUtils.decryptData(data: defaults.data(forKey: metroUserIDKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "0")
            let token = try (StorageUtils.decryptData(data: defaults.data(forKey: metroTokenKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "")

            let verifiedEmail = try (StorageUtils.decryptData(data: defaults.data(forKey: metroVerifiedEmailKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "0")
            let verifiedDob = try (StorageUtils.decryptData(data: defaults.data(forKey: metroVerifiedDobKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "0")
            let verifiedName = try (StorageUtils.decryptData(data: defaults.data(forKey: metroVerifiedNameKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "0")
            
            let profileUpdated = try (StorageUtils.decryptData(data: defaults.data(forKey: metroProfileUpdatedKey), keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "0")
            
            let pinSetup = try (StorageUtils.decryptData(data: defaults.data(forKey: metroPinSetupKey), keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "0")
            let pin = try (StorageUtils.decryptData(data: defaults.data(forKey: metroPinKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "")
            
            let pgKey = try (StorageUtils.decryptData(data: defaults.data(forKey: metroPGKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "")

            let pgHashPaymentDetails = try (StorageUtils.decryptData(data: defaults.data(forKey: metroPGHashPaymentDetailsKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "")
            
            let pgHashVasForMobile = try (StorageUtils.decryptData(data: defaults.data(forKey: metroPGHashVasForMobileKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "")
            if defaults.data(forKey: metroActiveTicketsKey) != nil {
                activeTicketsStr = try (StorageUtils.decryptData(data: defaults.data(forKey: metroActiveTicketsKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "")
            }
            
            user.idUser = Int(idUser)!
            user.token = token
            user.verifiedEmail = (verifiedEmail == "1")
            user.verifiedDob = (verifiedDob == "1")
            user.verifiedName = (verifiedName == "1")
            user.profileUpdated = (profileUpdated == "1")
            user.pinSetup = (pinSetup == "1")
            user.pin = pin
            
            PGKey = pgKey
            PGHashPaymentDetails = pgHashPaymentDetails
            PGHashVasForMobile = pgHashVasForMobile
            
            if defaults.data(forKey: metroStationsKey) != nil {
                var strStations = try (StorageUtils.decryptData(data: defaults.data(forKey: metroStationsKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "")
                MLog.log(string: "Saved Stations:", strStations)
//                let jsonData = Data(strStations.utf8)
//                let startIndex = strStations.index(strStations.startIndex, offsetBy: 1396)
//                MLog.log(string: "Stations Prsing ", strStations[startIndex])
                strStations = strStations.replacingOccurrences(of: "\n", with: "\\n")
                if strStations != "" {
                    let stnObj = try JSONSerialization.jsonObject(with: strStations.data(using: .utf8)!, options: []) as! [Any]
                    if !stnObj.isEmpty {
                        stations.removeAll()
                        for obj in stnObj {
                            let station = Station()
                            station.initWithDictionary(stnInfoJSON: obj as! [AnyHashable: Any])
                            stations.append(station)
                        }
                    }
                    MLog.log(string: "Stations loaded", stations.count)
                }
            } else {
                stations = []
            }
          // Sets
            if defaults.data(forKey: metroSetKey) != nil {
                var strsets = try (StorageUtils.decryptData(data: defaults.data(forKey: metroSetKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "")
                MLog.log(string: "Saved Sets:", strsets)
//                let jsonData = Data(strStations.utf8)
//                let startIndex = strStations.index(strStations.startIndex, offsetBy: 1396)
//                MLog.log(string: "Stations Prsing ", strStations[startIndex])
                strsets = strsets.replacingOccurrences(of: "\n", with: "\\n")
                if strsets != "" {
                    let stnObj = try JSONSerialization.jsonObject(with: strsets.data(using: .utf8)!, options: []) as! [Any]
                    if !stnObj.isEmpty {
                        sets.removeAll()
                        for obj in stnObj {
                            let set = Sets()
                            set.initWithDictionary(stnInfoJSON: obj as! [AnyHashable: Any])
                            sets.append(set)
                        }
                    }
                    MLog.log(string: "Sets loaded", sets.count)
                }
            } else {
                sets = []
            }
            
            wrongMPins = (defaults.object(forKey: metroWrongMPinAttemptsKey) ?? 0 ) as! Int
            
            if defaults.object(forKey: metroBlockMPinTimeKey) != nil {
                blockMPinTime = (defaults.object(forKey: metroBlockMPinTimeKey) as! Date)
            }
            
            if defaults.data(forKey: metroUserLanguageKey) != nil {
                let userLanguageStr = try (StorageUtils.decryptData(data: defaults.data(forKey: metroUserLanguageKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "English")
                
                userLanguage = Language(rawValue: userLanguageStr)!
            }
        } catch let error {
            MLog.log(string: "Defaults Parsing", error.localizedDescription)
            return false
        }
        return true
    }

    func saveToDefaults() {
        MLog.log(string: "Saving Default")
        let defaults: UserDefaults! = UserDefaults.standard
        do {
            defaults.set(try StorageUtils.encryptString(string: String(user.idUser), keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroUserIDKey)
            defaults.set(try StorageUtils.encryptString(string: String(user.token), keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroTokenKey)

            if user.verifiedEmail {
                defaults.set(try StorageUtils.encryptString(string: "1", keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroVerifiedEmailKey)
            } else {
                defaults.set(try StorageUtils.encryptString(string: "0", keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroVerifiedEmailKey)
            }

            if user.verifiedDob {
                defaults.set(try StorageUtils.encryptString(string: "1", keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroVerifiedDobKey)
            } else {
                defaults.set(try StorageUtils.encryptString(string: "0", keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroVerifiedDobKey)
            }

            if user.verifiedName {
                defaults.set(try StorageUtils.encryptString(string: "1", keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroVerifiedNameKey)
            } else {
                defaults.set(try StorageUtils.encryptString(string: "0", keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroVerifiedNameKey)
            }
            
            if user.profileUpdated {
                defaults.set(try StorageUtils.encryptString(string: "1", keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroProfileUpdatedKey)
            } else {
                defaults.set(try StorageUtils.encryptString(string: "0", keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroProfileUpdatedKey)
            }

            if user.pinSetup {
                defaults.set(try StorageUtils.encryptString(string: "1", keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroPinSetupKey)
            } else {
                defaults.set(try StorageUtils.encryptString(string: "0", keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroPinSetupKey)
            }

            defaults.set(try StorageUtils.encryptString(string: user.pin, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroPinKey)
            
            defaults.set(try StorageUtils.encryptString(string: PGKey, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroPGKey)
            
            defaults.set(try StorageUtils.encryptString(string: PGHashPaymentDetails, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroPGHashPaymentDetailsKey)
            
            defaults.set(try StorageUtils.encryptString(string: PGHashVasForMobile, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroPGHashVasForMobileKey)
            
            var strStations = "["
            for stn in stations {
                strStations.append(stn.toJson())
                strStations.append(",")
            }
            if !stations.isEmpty {
                strStations.removeLast()
            }
            strStations.append("]")
            strStations = strStations.replacingOccurrences(of: "\n", with: "")
//            MLog.log(string: "Staions List:", strStations)
            defaults.set(try StorageUtils.encryptString(string: strStations, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroStationsKey)
            // For sets
            var strSets = "["
            for sets in sets {
                strSets.append(sets.toJson())
                strSets.append(",")
            }
            if !sets.isEmpty {
                strSets.removeLast()
            }
            strSets.append("]")
            strSets = strSets.replacingOccurrences(of: "\n", with: "")
            defaults.set(try StorageUtils.encryptString(string: strSets, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroSetKey)
         
            defaults.set(try StorageUtils.encryptString(string: activeTicketsStr, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroActiveTicketsKey)
            
            defaults.set(wrongMPins, forKey: metroWrongMPinAttemptsKey)
            
            if blockMPinTime == nil {
                defaults.removeObject(forKey: metroBlockMPinTimeKey)
            } else {
                defaults.set(blockMPinTime, forKey: metroBlockMPinTimeKey)
            }
            
            defaults.set(try StorageUtils.encryptString(string: userLanguage.rawValue, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()), forKey: metroUserLanguageKey)
            
        } catch let error {
            MLog.log(string: "Save Prefs", error)
        }
//        MLog.log(string: defaults)
        defaults.synchronize()
    }
    func saveEnableAppLock(appLock: Bool) {
        UserDefaults.standard.set(appLock, forKey: "EnableAppLock")
        UserDefaults.standard.synchronize()
    }
    func getEnableAppLock() -> Bool {
        return UserDefaults.standard.bool(forKey: "EnableAppLock")
    }
    func saveBookingHalt(bookingHalt: Bool) {
        UserDefaults.standard.set(bookingHalt, forKey: "BookingHalt")
        UserDefaults.standard.synchronize()
    }
    func getBookingHalt() -> Bool {
        return UserDefaults.standard.bool(forKey: "BookingHalt")
    }
    func savebookingHaltMessage(bookingHalt: String) {
        UserDefaults.standard.set(bookingHalt, forKey: "bookingHaltMessage")
        UserDefaults.standard.synchronize()
    }
    func getbookingHaltMessage() -> String {
        return UserDefaults.standard.string(forKey: "bookingHaltMessage") ?? ""
    }
    func saveCampaignOpted(bookingHalt: String) {
        UserDefaults.standard.set(bookingHalt, forKey: "campaignOpted")
        UserDefaults.standard.synchronize()
    }
    func geCampaignOpted() -> String {
        return UserDefaults.standard.string(forKey: "campaignOpted") ?? ""
    }
    
    func saveUserId(userId: String) {
        UserDefaults.standard.set(userId, forKey: "NEWUSERID")
        UserDefaults.standard.synchronize()
    }
    func geUserId() -> String {
        return UserDefaults.standard.string(forKey: "NEWUSERID") ?? "0"
    }
    
    func saveUserMobileNumber(mobileNumber: String) {
        UserDefaults.standard.set(mobileNumber, forKey: "USERMOBILENUMBER")
        UserDefaults.standard.synchronize()
    }
    func getUserMobileNumber() -> String {
        return UserDefaults.standard.string(forKey: "USERMOBILENUMBER") ?? ""
    }
    
    func saveEnableAppLock(bookingHalt: String) {
        UserDefaults.standard.set(bookingHalt, forKey: "enableAppLock")
        UserDefaults.standard.synchronize()
    }
    func geEnableAppLock() -> String {
        return UserDefaults.standard.string(forKey: "enableAppLock") ?? ""
    }
    func getStationID(stationName: String) -> Int {
        for stn in stations where stn.name == stationName {
            return stn.idStation
        }
        return 0
    }
    
    func getStationFromParticular(particular: Any) -> Station? {
        if particular is String {
            MLog.log(string: "Returning Station from name", particular, stations.count)
            for stn in stations where stn.name == particular as! String {
                return stn
            }
        } else if particular is Int {
            MLog.log(string: "Returning Station from id", particular, stations.count)
            for stn in stations where stn.idStation == particular as! Int {
                return stn
            }
        }
        return nil
    }
    
    func loadTouristPlaces() {
        do {
            let responseJSON = try JSONSerialization.jsonObject(with: StaticData.STATIC_TOUR_PLACES.data(using: .utf8)!, options: [])
            guard let responseObj = responseJSON as? [[AnyHashable: Any]] else {
                MLog.log(string: "tourist Places Abort")
                return
            }
            for placeObj in responseObj {
                touristPlaces.append(TourPlace(jsonObj: placeObj))
            }
            MLog.log(string: "Tourist Places Found:", touristPlaces.count)
        } catch let e {
            MLog.log(string: "tourist Places Error:", e.localizedDescription)
        }
    }
    
    func loadStationLines() {
        do {
            let responseJSON = try JSONSerialization.jsonObject(with: StaticData.STATIC_STATIONS.data(using: .utf8)!, options: [])
            guard let responseObj = responseJSON as? [[AnyHashable: Any]] else {
                MLog.log(string: "static stations Abort")
                return
            }
            for stnObj in responseObj {
                let stn = Station()
                stn.initWithDictionary(stnInfoJSON: stnObj)
                if stn.line == .aqua {
                    aquaStations.append(stn)
                } else if stn.line == .purple {
                    purpleStations.append(stn)
                }
            }
            MLog.log(string: "Stations Found:", aquaStations.count, purpleStations.count)
        } catch let e {
            MLog.log(string: "Stations Error:", e.localizedDescription)
        }
    }
    
    func isOnSameLine(stationName1: String, stationName2: String) -> Bool {
        for set in sets where set.name == stationName1 {
            for set2 in sets where set2.name == stationName2 {
                MLog.log(string: "sets:", set.set, set2.set)
                return set.set == set2.set
            }
        }
        return false
    }
    
    func getCurrentYear() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = " yyyy"
            return dateFormatter.string(from: Date())
        }
}
