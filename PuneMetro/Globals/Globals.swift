//
//  Globals.swift
//  PuneMetro
//
//  Created by Admin on 16/04/21.
//

import Foundation
class Globals {

    static let LOG: Bool = true
    
    static let SPLASH_DELAY: Double = 3.0
    
    static let SNACKBAR_TIMEOUT: Double = 7.0
    
    static let REFRESH_TIMEOUT_SEC = 40
    
    static let MIN_GROUP_SIZE = 10
    static let MAX_GROUP_SIZE = 40
    
    // PayU Generic Credentials
    static let PG_GENERIC_EMAIL: String = "abc@example.com"
    static let PG_GENERIC_MOBILE: String = "8989898989"
    
    // mPin Charectoristics
    static let PROHIBITED_MPINS: [String] = ["1234", "1111", "0000", "7777", "1004",
                                             "2000", "4444", "2222", "9999", "3333", "5555", "6666", "1122", "8888", "4321"]
    static let WRONG_MPIN_ATTEMPTS: Int = 3
    static let BLOCK_MPIN_MINUTES = 20
    
    // Branch names
    static let BRANCH_DEV: String = "dev"
    static let BRANCH_RELEASE: String = "testing"
    static let BRANCH_TESTING: String = "testing"
    static let BRANCH_MASTER: String = "master"
    static let BRANCH_HOTFIX: String = "hotfix"
    static let BRANCH_FEATURE: String = "feature"

    // Months
    
    static let MONTHS: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    // Ticket Exit Validity
    static let TICKET_ENTRY_EXPIRY_MINUTES: Int = 30
    static let TICKET_EXIT_EXPIRY_MINUTES: Int = 480
    
    // QR Update Interval
    static let QR_UPDATE_INTERVAL = 60
    static let TICKET_REFRESH_INTERVAL = 60
    
    // Customer Care
    static let CC_PHONE = "18002705501"
    
    // Google Map API KEY
    static let GOOGLE_MAP_API_KEY = "AIzaSyAyljBnrip5dRe_0FoZT8Ed8tqk0Vn-eyM"
    
    // SERVICE PROVIDER and SERVICE TYPE For get fare
    static let IDSERVICEPROVIDER = "0"
    static let IDSERVICETYPE = "0"
    
}

enum Language: String {
    case marathi = "मराठी"
    case hindi = "हिंदी"
    case english = "English"
    
    func localeVal() -> String {
        switch self {
        case .marathi: return "mr"
        case .hindi: return "hi"
        case .english: return "en"
        }
    }
}
