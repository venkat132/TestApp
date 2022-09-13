//
//  JourneyPlannerDataObject.swift
//  PuneMetro
//
//  Created by Admin on 20/10/21.
//

import Foundation

// MARK: - JourneyPlannerDataObject
class JourneyPlannerDataObject: Codable {
    let code: Int?
    let timestamp: String?
    let body: Body?
    let version: String?
    let halt: Bool?
    let haltMessage: String?
    let message: String?

    init(code: Int?, timestamp: String?, body: Body?, version: String?, halt: Bool?, haltMessage: String?, message: String?) {
        self.code = code
        self.timestamp = timestamp
        self.body = body
        self.version = version
        self.halt = halt
        self.haltMessage = haltMessage
        self.message = message
    }
}

// MARK: - Body
class Body: Codable {
    let numOfParts: Int?
    let part1: Part?
    let station1, station2, station3, station4: StationData?
    let part3, part5: Part?

    init(numOfParts: Int?, part1: Part?, station1: StationData?, station2: StationData?, part3: Part?, station3: StationData?, station4: StationData?, part5: Part?) {
        self.numOfParts = numOfParts
        self.part1 = part1
        self.station1 = station1
        self.station2 = station2
        self.part3 = part3
        self.station3 = station3
        self.station4 = station4
        self.part5 = part5
    }
}

// MARK: - Part
class Part: Codable {
    let drive, walk, partPublic: OptionDetails?

    enum CodingKeys: String, CodingKey {
        case drive, walk
        case partPublic = "public"
    }

    init(drive: OptionDetails?, walk: OptionDetails?, partPublic: OptionDetails?) {
        self.drive = drive
        self.walk = walk
        self.partPublic = partPublic
    }
}

// MARK: - Drive
class OptionDetails: Codable {
    let path, directions: [String]?
    let duration, distance: Int?

    init(path: [String]?, directions: [String]?, duration: Int?, distance: Int?) {
        self.path = path
        self.directions = directions
        self.duration = duration
        self.distance = distance
    }
}

// MARK: - StationData
class StationData: Codable {
    let id, name, shortName, lineID: String?
    let stationSet, coordinates: String?

    enum CodingKeys: String, CodingKey {
        case id, name, shortName
        case lineID = "lineId"
        case stationSet = "set"
        case coordinates
    }

    init(id: String?, name: String?, shortName: String?, lineID: String?, stationSet: String?, coordinates: String?) {
        self.id = id
        self.name = name
        self.shortName = shortName
        self.lineID = lineID
        self.stationSet = stationSet
        self.coordinates = coordinates
    }
}
