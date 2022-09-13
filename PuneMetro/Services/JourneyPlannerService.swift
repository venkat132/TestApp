//
//  SmartCardService.swift
//  PuneMetro
//
//  Created by Admin on 02/08/21.
//

import Foundation
class JourneyPlannerService: GenericService {
    public func getGetPlaceSuggestionsTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_GET_PLACE_SUGGESTIONS)!)
       
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Place Suggestions data:", params)
        
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }
        
        task?.resume()
    }
    public func getGetPlaceDetailsTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_GET_PLACE_DETAILS)!)
       
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Place Details data:", params)
        
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }
        
        task?.resume()
    }
    public func getGetJourneyPartsTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_GET_JOURNEY_PARTS)!)
       
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = params.data(using: .utf8)
        MLog.log(string: "User Token:", LocalDataManager.dataMgr().user.token)
        MLog.log(string: "Journey Parts data:", params)
        
        let task = session?.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                MLog.log(string: error?.localizedDescription ?? "No data")
                self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                return
            }
            self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
        }
        
        task?.resume()
    }
  
}
