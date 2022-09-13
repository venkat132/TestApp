//
//  Station.swift
//  PuneMetro
//
//  Created by Admin on 28/04/21.
//

import Foundation
import UIKit
class Station {
    public var idStation: Int = 0
    public var name: String = ""
    public var shortName: String = ""
    public var details: String = ""
    public var imageUrl: String = ""
    public var properties: [StationProperties] = []
    public var line: StationLine = .aqua
    public var isJunction: Bool = false
    public var isActive: String = "Active"
    func initWithDictionary(stnInfoJSON: [AnyHashable: Any]) {
        self.idStation = stnInfoJSON["station_id"] as! Int
        self.name = stnInfoJSON["station_name"] as! String
        if stnInfoJSON["short_name"] == nil {
            return
        }
        self.isJunction = self.name == "Civil Court"
        self.isActive = stnInfoJSON["isActive"] as? String ?? ""
        self.shortName = stnInfoJSON["short_name"] as! String
        self.details = (stnInfoJSON["station_description"] as! String).replacingOccurrences(of: "\t", with: " ")
        self.imageUrl = (stnInfoJSON["station_image"] ?? "") as! String
        if stnInfoJSON["station_properties"] != nil {
            guard let propsObj: [String] = stnInfoJSON["station_properties"] as? [String] else {
                return
            }
            self.properties = []
            for prop in propsObj {
                self.properties.append(StationProperties(rawValue: prop)!)
            }
        }
        self.line = StationLine(rawValue: stnInfoJSON["line_id"] as! Int) ?? .red
        
        MLog.log(string: "Parsing Station:", self.name, self.shortName, self.idStation, self.line)
    }
    
    func toJson() -> String {
        var str =  "{\"station_id\":\(idStation),\"station_name\":\"\(name)\",\"short_name\":\"\(shortName)\",\"station_description\":\"\(details)\",\"station_image\":\"\(imageUrl)\",\"station_properties\":["
        for prop in self.properties {
            str.append("\"\(prop.rawValue)\",")
        }
        if !properties.isEmpty {
            str.remove(at: str.index(before: str.endIndex))
        }
        str.append("],\"line_id\":\(line.rawValue)}")
//        MLog.log(string: "Returning str stn", str)
        return str
    }
    
    public func getStationPropertyImage(prop: StationProperties) -> UIImage? {
        switch prop {
        case .disabled:
            return UIImage(named: "disabled-1")
        case .drinkingWater:
            return UIImage(named: "drinking-water-1")
        case .escalator:
            return UIImage(named: "escalator-1")
        case .junction:
            return UIImage(named: "junction-1")
        case .lift:
            return UIImage(named: "lift-1")
        case .parking:
            return UIImage(named: "parking-1")
        case .restaurant:
            return UIImage(named: "restaurant-1")
        case .shops:
            return UIImage(named: "shops-1")
        case .terminal:
            return UIImage(named: "terminal-station-1")
        case .underground:
            return UIImage(named: "underground-1")
        case .washroom:
            return UIImage(named: "washroom-1")
        }
    }
    public func getStationPropertyImageColoured(prop: StationProperties) -> UIImage? {
        switch prop {
        case .disabled:
            return UIImage(named: "disabled-2")
        case .drinkingWater:
            return UIImage(named: "drinking-water-2")
        case .escalator:
            return UIImage(named: "escalator-2")
        case .junction:
            return UIImage(named: "junction-2")
        case .lift:
            return UIImage(named: "lift-2")
        case .parking:
            return UIImage(named: "parking-2")
        case .restaurant:
            return UIImage(named: "restaurant-2")
        case .shops:
            return UIImage(named: "shops-2")
        case .terminal:
            return UIImage(named: "terminal-station-2")
        case .underground:
            return UIImage(named: "underground-2")
        case .washroom:
            return UIImage(named: "washroom-2")
        }
    }
    public func getStationPropertyImageNew(prop: StationProperties) -> UIImage? {
        switch prop {
        case .disabled:
            return UIImage(named: "disable-new")
        case .drinkingWater:
            return UIImage(named: "drinking-water-new")
        case .escalator:
            return UIImage(named: "escalator-new")
        case .junction:
            return UIImage(named: "junction-new")
        case .lift:
            return UIImage(named: "lift-new")
        case .parking:
            return UIImage(named: "parking-new")
        case .restaurant:
            return UIImage(named: "restaurant-new")
        case .shops:
            return UIImage(named: "shops-new")
        case .terminal:
            return UIImage(named: "terminal-new")
        case .underground:
            return UIImage(named: "underground-new")
        case .washroom:
            return UIImage(named: "washroom-new")
        }
    }
}

public enum StationProperties: String {
    case disabled
    case drinkingWater
    case escalator
    case junction
    case lift
    case parking
    case restaurant
    case shops
    case terminal
    case underground
    case washroom
}

public enum StationLine: Int {
    case purple = 1
    case aqua = 2
    case red = 3
}
