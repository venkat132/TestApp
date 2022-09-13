//
//  JourneyPlannerModel.swift
//  PuneMetro
//
//  Created by Admin on 18/10/21.
//

import UIKit
protocol JourneyPlannerProtocol {

    var didReveivePlace: (([[AnyHashable: Any]]) -> Void)? {get set}
    var didReveivePlaceDetails: ((String, String, String) -> Void)? {get set}
    var didReveiveJourneyParts: ((JourneyPlannerDataObject) -> Void)? {get set}
    var didReveiveJourneyResponse: ((String) -> Void)? {get set}
}
class JourneyPlannerModel: NSObject, GenericServiceDelegate, JourneyPlannerProtocol {
    var didReveiveJourneyResponse: ((String) -> Void)?
    
    var didReveiveJourneyParts: ((JourneyPlannerDataObject) -> Void)?
    
    var didReveivePlaceDetails: ((String, String, String) -> Void)?
    var didReveivePlace: (([[AnyHashable: Any]]) -> Void)?
    var JourneyPlannerServ: JourneyPlannerService?
    var SuggestPlaces = [[AnyHashable: Any]]()
    var JPResultDataObj: JourneyPlannerDataObject?

    func GetPlaceSuggestions(SearchStr: String, UUID: String) {
        if JourneyPlannerServ == nil {
            JourneyPlannerServ = JourneyPlannerService(delegate: self)
        }
        let params = DaosManager.DAO_JOURNEY_PLANNER.replacingOccurrences(of: "[SEARCHSTRING]", with: SearchStr).replacingOccurrences(of: "[UUID]", with: UUID)
        JourneyPlannerServ?.getGetPlaceSuggestionsTask(params: params)
    }
    
    func GetPlaceDetails(PlaceId: String, UUID: String) {
        if JourneyPlannerServ == nil {
            JourneyPlannerServ = JourneyPlannerService(delegate: self)
        }
        let params = DaosManager.DAO_GET_PLACE_DETAILS.replacingOccurrences(of: "[IDPLACE]", with: PlaceId).replacingOccurrences(of: "[UUID]", with: UUID)
        JourneyPlannerServ?.getGetPlaceDetailsTask(params: params)
    }
    
    func GetJourneyParts(FromLat: String, FromLong: String, ToLat: String, ToLong: String, Place1: String, PlaceName1: String, Place2: String, PlaceName2: String) {
        if JourneyPlannerServ == nil {
            JourneyPlannerServ = JourneyPlannerService(delegate: self)
        }
        let params = DaosManager.DAO_GET_JOURNEY_PARTS.replacingOccurrences(of: "[LATITUDE1]", with: FromLat).replacingOccurrences(of: "[LONGITUDE1]", with: FromLong).replacingOccurrences(of: "[LATITUDE2]", with: ToLat).replacingOccurrences(of: "[LONGITUDE2]", with: ToLong).replacingOccurrences(of: "[PLACE1]", with: Place1).replacingOccurrences(of: "[PLACENAME1]", with: PlaceName1).replacingOccurrences(of: "[PLACE2]", with: Place2).replacingOccurrences(of: "[PLACENAME2]", with: PlaceName2)
        JourneyPlannerServ?.getGetJourneyPartsTask(params: params)
        
    }
    
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if service == JourneyPlannerServ {
           if params == UrlsManager.API_GET_PLACE_SUGGESTIONS {
                MLog.log(string: "Place Suggestions Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        self.SuggestPlaces = body["suggestions"] as! [[AnyHashable: Any]]
                        MLog.log(string: "Place Suggestions:", self.SuggestPlaces)
//                        let idPlace = suggestions["idPlace"] as! String
//                        let description = suggestions["description"] as! String
//                        MLog.log(string: "Place Suggestions:", idPlace, description)
                        self.didReveivePlace!(self.SuggestPlaces)
                    }
                } catch let e {
                    MLog.log(string: "Place Suggestions Error:", e.localizedDescription)
                }
            } else if  params == UrlsManager.API_GET_PLACE_DETAILS {
                 MLog.log(string: "Place Details:", String(data: data, encoding: .utf8))
                 do {
                     let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                     guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                         return
                     }
                     if responseObj["code"] as! Int == 200 {
                         let body = responseObj["body"] as! [AnyHashable: Any]
                         let place = body["place"] as! [AnyHashable: Any]
                        self.didReveivePlaceDetails!("\(place["latitude"]!)", "\(place["longitude"]!)", "\(place["namePlace"]!)")
                     }
                 } catch let e {
                     MLog.log(string: "Place details Error:", e.localizedDescription)
                 }
             } else if  params == UrlsManager.API_GET_JOURNEY_PARTS {
                 MLog.log(string: "Journey Parts:", String(data: data, encoding: .utf8))
                 do {
                    let responseDataObj = try JSONDecoder().decode(JourneyPlannerDataObject.self, from: data)
                    if responseDataObj.code == 200 {
                        JPResultDataObj = responseDataObj
                        self.didReveiveJourneyParts!(responseDataObj)
                    } else {
                        didReveiveJourneyResponse!(responseDataObj.message!)
                    }
                 } catch let e {
                     MLog.log(string: "Journey Parts Error:", e.localizedDescription)
                 }
             }
        }
    }
    func onDataError(error: Error, service: GenericService, params: String) {
     if params == UrlsManager.API_GET_PLACE_SUGGESTIONS {
            MLog.log(string: "Place Suggestions Error", error.localizedDescription)
        } else if params == UrlsManager.API_GET_PLACE_DETAILS {
            MLog.log(string: "Place details Error", error.localizedDescription)
        } else if params == UrlsManager.API_GET_JOURNEY_PARTS {
            MLog.log(string: "Journey Parts Error", error.localizedDescription)
        }
        
    }
}
