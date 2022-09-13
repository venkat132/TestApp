//
//  Station.swift
//  PuneMetro
//
//  Created by Admin on 28/04/21.
//

import Foundation
import UIKit
class Sets {
    public var idStation: String = ""
    public var name: String = ""
    public var shortName: String = ""
    public var line: String = ""
    public var set: String = ""
    public var lat: String = ""
    public var long: String = ""
    
    // {\"id\":\"104\",\"name\":\"Kasarwadi\",\"shortName\":\"KWA\",\"lineId\":\"1\",\"set\":\"2\",\"coordinates\":\"18.606485002640454,73.82248259797692\"}
    
    func initWithDictionary(stnInfoJSON: [AnyHashable: Any]) {
        self.idStation = stnInfoJSON["id"] as! String
        self.name = stnInfoJSON["name"] as! String
        if stnInfoJSON["shortName"] == nil {
            return
        }
        self.shortName = stnInfoJSON["shortName"] as! String
        self.set = stnInfoJSON["set"] as! String
        self.line = stnInfoJSON["lineId"] as! String
        if stnInfoJSON["coordinates"] != nil {
            let coordinates = stnInfoJSON["coordinates"] as! String
            let LatLong = coordinates.components(separatedBy: ",")
            self.lat = LatLong.first!
            self.long = LatLong.last!
        }
            
        MLog.log(string: "Parsing Station:", self.name, self.shortName, self.idStation, self.line, self.lat, self.long)
    }
    
    func toJson() -> String {
        let str = "{\"id\":\(idStation),\"name\":\"\(name)\",\"shortName\":\"\(shortName)\",\"set\":\"\(set)\"\"lineId\":\(line),\"coordinates\":\"\(lat + "," + long)}"
        
//        MLog.log(string: "Returning str stn", str)
        return str
    }
}
