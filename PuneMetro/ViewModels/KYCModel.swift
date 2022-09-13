//
//  KYCModel.swift
//  PuneMetro
//
//  Created by Admin on 20/09/21.
//

import UIKit

protocol KYCModelProtocol {

    var didRequestKYCToken: ((String) -> Void)? {get set}
    var goToHome:(() -> Void)? {get set}
}

class KYCModel: NSObject, GenericServiceDelegate, KYCModelProtocol {
    var didRequestKYCToken: ((String) -> Void)?
    var goToHome: (() -> Void)?
    var KYCservice: KYCService?

    func ProcessImageUpload(KYC_Type: String, Image_Name: String, Image: UIImage) {
        if KYCservice == nil {
            KYCservice = KYCService(delegate: self)
        }
        let params = DaosManager.DAO_KYC_UPLOAD.replacingOccurrences(of: "[TYPE]", with: KYC_Type).replacingOccurrences(of: "[KYC]", with: "\(Image_Name)")
        
        KYCservice?.UploadImageToServer(params: params, image: Image)
        
    }
    
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if service == KYCservice {
           if params == UrlsManager.API_KYC_MULTIPART {
                MLog.log(string: "KYC Upload Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        MLog.log(string: "KYC Upload Success")
                        goToHome!()
                    }
                } catch let e {
                    MLog.log(string: "KYC Upload Error:", e.localizedDescription)
                }
            }
        }
    }
    func onDataError(error: Error, service: GenericService, params: String) {
      
    }
}
