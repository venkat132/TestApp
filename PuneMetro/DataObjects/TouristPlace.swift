//
//  TouristPlace.swift
//  PuneMetro
//
//  Created by Admin on 12/05/21.
//

import Foundation
class TourPlace {
    var title: String = ""
    var details: String = ""
    var imageUrl: String = ""
    var nearStn: Station = Station()
    var distance: Double = 0
    
    init(jsonObj: [AnyHashable: Any]) {
        title = jsonObj["name"] as! String
        details = jsonObj["details"] as! String
        imageUrl = jsonObj["image"] as! String
        nearStn.shortName = jsonObj["nearStn"] as! String
        for stn in LocalDataManager.dataMgr().aquaStations where stn.shortName == jsonObj["nearStn"] as! String {
            nearStn = stn
        }
        for stn in LocalDataManager.dataMgr().purpleStations where stn.shortName == jsonObj["nearStn"] as! String {
            nearStn = stn
        }
        distance = jsonObj["distance"] as! Double
    }
    
}
