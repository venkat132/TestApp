//
//  KYCService.swift
//  PuneMetro
//
//  Created by Admin on 20/09/21.
//

import UIKit

class KYCService: GenericService {
    
    public func UploadImageToServer(params: String, image: UIImage) {
       
        let url = URL(string: UrlsManager.API_KYC_MULTIPART)
        
        let TWITTERFON_FORM_BOUNDARY: String = "AaB03x"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let MPboundary: String = "--\(TWITTERFON_FORM_BOUNDARY)"
        let endMPboundary: String = "\(MPboundary)--"
        /// convert UIImage to NSData
        let data: NSData = image.pngData()! as NSData
        let body: NSMutableString = NSMutableString()
        // with other params
      
        let parameters = convertStringToDictionary(text: params)
        
        if parameters != nil {
                   for (key, value) in parameters! {
                    MLog.log(string: key)
                    MLog.log(string: value)
                        body.appendFormat("\(MPboundary)\r\n" as NSString)
                        body.appendFormat("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" as NSString)
                        body.appendFormat("\(value)\r\n" as NSString)
                   }
               }
        
//
//        body.appendFormat("\(MPboundary)\r\n" as NSString)
//        body.appendFormat("Content-Disposition: form-data; name=\"\("type")\"\r\n\r\n" as NSString)
//        body.appendFormat("\("aadhar")\r\n" as NSString)
//
//        body.appendFormat("\(MPboundary)\r\n" as NSString)
//        body.appendFormat("Content-Disposition: form-data; name=\"\("kyc")\"\r\n\r\n" as NSString)
//        body.appendFormat("\("sample.png")\r\n" as NSString)
        
        // set upload image, name is the key of image
        body.appendFormat("%@\r\n", MPboundary)
        body.appendFormat("Content-Disposition: form-data; name=\"\("kyc")\"; filename=\"pen111.png\"\r\n" as NSString)
        body.appendFormat("Content-Type: image/png\r\n\r\n")
        let end: String = "\r\n\(endMPboundary)"
        var myRequestData = Data()
        myRequestData.append(body.data(using: String.Encoding.utf8.rawValue)!)
        myRequestData.append(data as Data)
        myRequestData.append(end.data(using: .utf8)!)
        let content: String = "multipart/form-data; boundary=\(TWITTERFON_FORM_BOUNDARY)"
        request.setValue(content, forHTTPHeaderField: "Content-Type")
        request.setValue("\(myRequestData.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("Bearer " + LocalDataManager.dataMgr().user.token, forHTTPHeaderField: "Authorization")
        request.addValue("Auth-Scheme \(UrlsManager.API_KEY)", forHTTPHeaderField: "METROKEY")
        request.httpBody = myRequestData
        request.httpMethod = "POST"
        //        var conn:NSURLConnection = NSURLConnection(request: request, delegate: self)!
      
        let task = session?.dataTask(with: request as URLRequest) {data, _, error in
             guard let data = data, error == nil else {
                 MLog.log(string: error?.localizedDescription ?? "No data")
                 self.selfDelegate?.onDataError(error: error!, service: self, params: request.url!.absoluteString)
                 return
             }
             self.selfDelegate?.onDataReceived(data: data, service: self, params: request.url!.absoluteString)
 
         }
 
         task?.resume()
  
    }
    
    func convertStringToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
        
}
