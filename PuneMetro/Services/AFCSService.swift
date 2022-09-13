//
//  AFCSService.swift
//  PuneMetro
//
//  Created by Admin on 27/04/21.
//

import Foundation

class AFCSService: GenericService {
    public func getFareTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_AFCS_GET_FARE)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Get Fare data:", params)
        // insert json data to the request
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
    
    public func getStationsTask() {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_AFCS_GET_STATIONS)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        MLog.log(string: "Fetch Stations Request:", request)
        // insert json data to the request
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
    
    public func issueTicketTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_AFCS_ISSUE_TICKET)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Issue Ticket data:", request)
        
        // insert json data to the request
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
