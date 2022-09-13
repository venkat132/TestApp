//
//  StationList.swift
//  PuneMetro
//
//  Created by Venkat Rao Sandhi on 28/08/22.
//

import Foundation
/*
// MARK: - StationList
class StationList {
    let stationsList: StationsList
    
    init(stationsList: StationsList) {
        self.stationsList = stationsList
    }
}

// MARK: - StationsList
class StationsList {
    let purpleStationsList, aquaStationList: [List]
    
    init(StationsList:[AnyHashable: Any] ) {
        var ptationsList = [List]()
        let pSList = StationsList["purpleStationsList"] as? Array ?? []
        for p in 0..<pSList.count {
            ptationsList.append(List(pSList[p] as? [AnyHashable: Any] ?? [:]))
        }
        self.purpleStationsList = ptationsList
        
        var aquatationsList = [List]()
        let aSList = StationsList["aquaStationList"] as? Array ?? []
        for a in 0..<aSList.count {
            aquatationsList.append(List(aSList[a] as? [AnyHashable: Any] ?? [:]))
        }
        self.aquaStationList = aquatationsList
    }
}

// MARK: - List
class List {
    let stationImageLink: String
    let stationName, stationShortName, address, pinCode: String
    let listDescription: String
    let type: String
    let stationVisible: Bool
    let availableFacilties: [String]
    
    init(_ dict: [AnyHashable: Any]) {
        if let stationImageLink: String = dict["stationImageLink"] as? String {
            self.stationImageLink = stationImageLink
        }
        if let stationName: String = dict["stationName"] as? String {
            self.stationName = stationName
        }
        if let stationShortName: String = dict["stationShortName"] as? String {
            self.stationShortName = stationShortName
        }
        if let address: String = dict["address"] as? String {
            self.address = address
        }
        if let pinCode: String = dict["pinCode"] as? String {
            self.pinCode = pinCode
        }
        if let listDescription: String = dict["listDescription"] as? String {
            self.listDescription = listDescription
        }
        if let type: String = dict["type"] as? String {
            self.type = type
        }
        if let stationVisible: Bool = dict["stationVisible"] as? Bool {
            self.stationVisible = stationVisible
        }
        if let availableFacilties: [String] = dict["availableFacilties"] as? [String] {
            var resp = [String]()
            for data in 0..<availableFacilties.count {
                resp.append(availableFacilties[data])
            }
            self.availableFacilties = resp
        }
    }
}

*/
