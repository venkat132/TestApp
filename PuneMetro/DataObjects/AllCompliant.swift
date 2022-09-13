//
//  AllCompliant.swift
//  PuneMetro
//
//  Created by Venkat Rao Sandhi on 29/05/22.
//

import Foundation
class AllCompliant {
    
    public var id: String = ""
    public var idUser: String = ""
    public var sourceType: String = ""
    public var stationName: String = ""
    public var description: String = ""
    public var articleDescription: String = ""
    public var status: String = ""
    public var remarks: String = ""
    public var ticketID: String = ""
    public var ticketSerialNumber: String = ""
    public var location: String = ""
    public var createdOn: String = ""
    public var updatedOn: String = ""
    public var createdBy: String = ""
    public var updatedBy: String = ""
    public var createdAt: String = ""
    public var updatedAt: String = ""
    
    public func initWithDictionary(bannerObj: [AnyHashable: Any]) {
        if let id: String = bannerObj["id"] as? String {
            self.id = id
        }
        if let idUser: String = bannerObj["idUser"] as? String {
            self.idUser = idUser
        }
        if let sourceType: String = bannerObj["sourceType"] as? String {
            self.sourceType = sourceType
        }
        if let stationName: String = bannerObj["stationName"] as? String {
            self.stationName = stationName
        }
        if let description: String = bannerObj["description"] as? String {
            self.description = description
        }
        if let articleDescription: String = bannerObj["articleDescription"] as? String {
            self.articleDescription = articleDescription
        }
        if let location: String = bannerObj["location"] as? String {
            self.location = location
        }
        if let updatedOn: String = bannerObj["updatedOn"] as? String {
            self.updatedOn = updatedOn
        }
        if let createdOn: String = bannerObj["createdOn"] as? String {
            self.createdOn = createdOn
        }
        if let createdBy: String = bannerObj["createdBy"] as? String {
            self.createdBy = createdBy
        }
        if let updatedBy: String = bannerObj["updatedBy"] as? String {
            self.updatedBy = updatedBy
        }
        if let createdAt: String = bannerObj["createdAt"] as? String {
            self.createdAt = createdAt
        }
        if let updatedAt: String = bannerObj["updatedAt"] as? String {
            self.updatedAt = updatedAt
        }
        if let ticketID: String = bannerObj["tktID"] as? String {
            self.ticketID = ticketID
        }
        if let remarks: String = bannerObj["remarks"] as? String {
            self.remarks = remarks
        }
        if let status: String = bannerObj["status"] as? String {
            self.status = status
        }
        if let ticketSerialNumber: String = bannerObj["ticketSerialNumber"] as? String {
            self.ticketSerialNumber = ticketSerialNumber
        }
        
    }
    
}
