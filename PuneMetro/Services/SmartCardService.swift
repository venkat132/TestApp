//
//  SmartCardService.swift
//  PuneMetro
//
//  Created by Admin on 02/08/21.
//

import Foundation
class SmartCardService: GenericService {
    public func getLinkedCardTask() {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_SMART_CARD_GET_LINKED)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")

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
    
    public func requestTokenTask() {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_SMART_CARD_REQUEST_TOKEN)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        
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
    
    public func generateTokenTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_SMART_CARD_GENERATE_TOKEN)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Generate Card Token data:", params)
        
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
    
    public func balanceEnquiryTask() {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_SMART_CARD_BALANCE_ENQUIRY)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        
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
    
    public func validateDebitTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_SMART_CARD_VALIDATE_DEBIT)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Validate Debit Transaction data:", params)
        
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
    
    public func processDebitTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_SMART_CARD_PROCESS_DEBIT)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Process Debit Transaction data:", params)
        
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
    
    public func validateTopupTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_SMART_CARD_VALIDATE_TOPUP)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Validate Topup data:", params)
        
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
    
    public func processTopupTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_SMART_CARD_PROCESS_TOPUP)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Process Topup data:", params)
        
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
    
    public func getTransactionTask(params: String) {
        var request = URLRequest(url: URL.init(string: UrlsManager.API_SMART_CARD_GET_TRANSACTION)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = params.data(using: .utf8)
        
        MLog.log(string: "Get Transaction data:", params)
        
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
