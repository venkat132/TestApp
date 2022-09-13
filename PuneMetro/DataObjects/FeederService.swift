//
//  FeederService.swift
//  PuneMetro
//
//  Created by Admin on 15/07/21.
//

import Foundation

class FeederService {
    var title: String = ""
    var details: String = ""
    var logoImage: String = ""
    var category: FeederServiceCategory?
    var url: String = ""
    
    init(serviceObj: [AnyHashable: Any]) {
        self.title = serviceObj["title"] as! String
        self.details = serviceObj["details"] as! String
        self.logoImage = serviceObj["logoImage"] as! String
        self.category = FeederServiceCategory(rawValue: serviceObj["category"] as! String)!
        self.url = serviceObj["url"] as! String
    }
}

enum FeederServiceCategory: String {
    case rail = "Rail"
    case bus = "Bus"
    case cab = "Cab"
    case rickshaw = "Rickshaw"
    case bike = "Bike"
    case cycle = "Cycle"
    case other = "Other"
    case all = "All"
    
    func iconImageName() -> String {
        switch self {
        case .rail:
            return "fs-rail"
        case .bus:
            return "fs-bus"
        case .cab:
            return "fs-cab"
        case .rickshaw:
            return "fs-rickshaw"
        case .bike:
            return "fs-bike"
        case .cycle:
            return "fs-cycle"
        case .other:
            return "fs-other"
        case .all:
            return ""
        }
    }
}
