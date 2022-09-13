//
//  LostAndFoundModel.swift
//  PuneMetro
//
//  Created by Admin on 20/09/21.
//

import UIKit

protocol LostAndFoundProtocol {

    var goToHome:(() -> Void)? {get set}
    var didTicketGrievancesReceived: (() -> Void)? {get set}
    var didGetTicketGrievances: (() -> Void)? {get set}
}

class LostAndFoundModel: NSObject, GenericServiceDelegate, LostAndFoundProtocol {
    var goToHome: (() -> Void)?
    var didTicketGrievancesReceived: (() -> Void)?
    var LostAndFoundservice: LostAndFoundService?
    var didGetTicketGrievances: (() -> Void)?
    var ticketGrievance: [AllCompliant] = []
    func fetchTicketGrievances(id: String) {
        if LostAndFoundservice == nil {
            LostAndFoundservice = LostAndFoundService(delegate: self)
        }
        let param = DaosManager.DAO_LOST_AND_FOUND_GET.replacingOccurrences(of: "[IDUSER]", with:  id)
        LostAndFoundservice?.FetchTicketGrievances(params: param)
    }
    func ProcessImageUpload(parameters: [String: String], Image: UIImage, From: String) {
        if LostAndFoundservice == nil {
            LostAndFoundservice = LostAndFoundService(delegate: self)
        }
        
        var params = ""
        if From ==  UrlsManager.API_LOSTNDFOUND_MULTIPART {
            params = DaosManager.DAO_LOST_AND_FOUND_UPLOAD.replacingOccurrences(of: "[IDUSER]", with: parameters["idUser"] ?? "").replacingOccurrences(of: "[STATIONNAME]", with: "\(parameters["stationName"] ?? "")").replacingOccurrences(of: "[LOCATION]", with: "\(parameters["location"] ?? "")").replacingOccurrences(of: "[DESCRIPTION]", with: "\(parameters["description"] ?? "")").replacingOccurrences(of: "[SOURCETYPE]", with: "\(parameters["sourceType"] ?? "")").replacingOccurrences(of: "[ARTICALDESCRIPTION]", with: "\(parameters["articleDescription"] ?? "")").replacingOccurrences(of: "[TICKETID]", with: "\(parameters["ticketSerialNumber"] ?? "")")
        }
//        if From ==  UrlsManager.API_GRIEVENCES_MULTIPART {
//            params = DaosManager.DAO_GRIEVENCES_UPLOAD.replacingOccurrences(of: "[MESSAGE]", with: "\(Description)")
//        }
//        if From ==  UrlsManager.API_FEEDBACK_MULTIPART {
//            params = DaosManager.DAO_FEEDBACK_UPLOAD.replacingOccurrences(of: "[MESSAGE]", with: "\(Description)")
//        }
        LostAndFoundservice?.sendAddCompliant(params: params)
       // LostAndFoundservice?.UploadImageToServer(params: params, image: Image, From: From)
        
    }
    
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if service == LostAndFoundservice {
           if params == UrlsManager.API_LOSTNDFOUND_MULTIPART {
                MLog.log(string: "LOST_AND_FOUND Upload Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        MLog.log(string: "LOST_AND_FOUND Upload Success")
                        goToHome!()
                    }
                } catch let e {
                    MLog.log(string: "LOST_AND_FOUND Upload Error:", e.localizedDescription)
                }
            }
            if params == UrlsManager.API_GRIEVENCES_MULTIPART {
                 MLog.log(string: "GRIEVENCES Upload Response:", String(data: data, encoding: .utf8))
                 do {
                     let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                     guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                         return
                     }
                     if responseObj["code"] as! Int == 200 {
                         MLog.log(string: "GRIEVENCES Upload Success")
                         goToHome!()
                     }
                 } catch let e {
                     MLog.log(string: "GRIEVENCES Upload Error:", e.localizedDescription)
                 }
             }
            if params == UrlsManager.API_FEEDBACK_MULTIPART {
                 MLog.log(string: "FEEDBACK Upload Response:", String(data: data, encoding: .utf8))
                 do {
                     let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                     guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                         return
                     }
                     if responseObj["code"] as! Int == 200 {
                         MLog.log(string: "FEEDBACK Upload Success")
                         goToHome!()
                     }
                 } catch let e {
                     MLog.log(string: "FEEDBACK Upload Error:", e.localizedDescription)
                 }
             }
            if params == UrlsManager.API_LOSTNDFOUND_FETCH {
                 MLog.log(string: "FEEDBACK Upload Response:", String(data: data, encoding: .utf8))
                 do {
                     let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                     guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                         return
                     }
                     if responseObj["code"] as! Int == 200 {
                         let body = responseObj["body"] as! [AnyHashable: Any]
                         if let bodyObj = body["result"] as? [[AnyHashable: Any]] {
                         self.ticketGrievance = []
                         for obj in bodyObj {
                             let compliant = AllCompliant()
                             compliant.initWithDictionary(bannerObj: obj)
                             ticketGrievance.append(compliant)
                         }
                         didGetTicketGrievances!()
                     }
                     }
                 } catch let e {
                     MLog.log(string: "FEEDBACK Upload Error:", e.localizedDescription)
                 }
             }
        }
    }
    func onDataError(error: Error, service: GenericService, params: String) {
      
    }
}
