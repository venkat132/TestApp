//
//  APIClient.swift
//  PuneMetro
//
//  Created by Venkat Rao Sandhi on 03/05/22.
//
enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    
    public var value: String {
        return self.rawValue
    }
}
import Foundation
private var _SingletonSharedInstance: APIClient! = APIClient()
open class APIClient: NSObject, URLSessionDelegate{
    class var sharedInstance: APIClient {
        return _SingletonSharedInstance
    }
    
    fileprivate override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }
    
    func startSyncProcessWithUrl(iUrl:String,params: String, method: HTTPMethod, completion:@escaping (_ responseDict:NSDictionary) -> Void) {
        print("Requested Url:\(iUrl)")
        
        var request = URLRequest(url: URL.init(string: UrlsManager.API_TICKETING_GET_ACTIVE_TRIPS)!)
        
        request.httpMethod = method.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        if method == .POST {
            request.httpBody = params.data(using: .utf8)
        }
        // insert json data to the request
        let task = session?.dataTask(with: request) {data, _, error in
            var jsonData : NSDictionary = NSDictionary()
            if error == nil && data != nil {
                do {
                    jsonData = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                } catch {
                    print("Error in parsing\(error)")
                    return
                }
                
                completion(jsonData)
            } else {
                print("Error in parsing\(error)")
                return
            }
        }
        task?.resume()
        
    }
    
}
