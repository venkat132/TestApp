//
//  SmartCardHomeModel.swift
//  PuneMetro
//
//  Created by Admin on 02/08/21.
//

import Foundation
protocol SmartCardHomeModelProtocol {
    var didLinkedCardFound: ((Bool) -> Void)? {get set}
    var didBalanceReceived: ((Double) -> Void)? {get set}
    var didRequestCardToken: ((String) -> Void)? {get set}
}
class SmartCardHomeModel: NSObject, SmartCardHomeModelProtocol, GenericServiceDelegate {
    var didLinkedCardFound: ((Bool) -> Void)?
    var didBalanceReceived: ((Double) -> Void)?
    var didRequestCardToken: ((String) -> Void)?
    var smartCardService: SmartCardService?
    func getLinkedCard() {
        if smartCardService == nil {
            smartCardService = SmartCardService(delegate: self)
        }
        smartCardService?.getLinkedCardTask()
    }
    func getCardBalance() {
        if smartCardService == nil {
            smartCardService = SmartCardService(delegate: self)
        }
        smartCardService?.balanceEnquiryTask()
    }
    func requestCardToken() {
        if smartCardService == nil {
            smartCardService = SmartCardService(delegate: self)
        }
        smartCardService?.requestTokenTask()
    }
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if service == smartCardService {
            if params == UrlsManager.API_SMART_CARD_GET_LINKED {
                MLog.log(string: "Get Linked Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        MLog.log(string: "Get Linked Body", body["linkedCard"])
                        if body["linkedCard"] != nil {
                            guard let _: [AnyHashable: Any] = body["linkedCard"] as? [AnyHashable: Any] else {
                                didLinkedCardFound!(false)
                                return
                            }
                            didLinkedCardFound!(true)
                            return
                        }
                    }
                } catch let e {
                    MLog.log(string: "Request mPin Reset Error:", e.localizedDescription)
                }
                didLinkedCardFound!(false)
            } else if params == UrlsManager.API_SMART_CARD_BALANCE_ENQUIRY {
                MLog.log(string: "Balance Enquiry Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        MLog.log(string: "Get Linked Body", body)
                        if body["balance"] != nil {
                            didBalanceReceived!(Double(body["balance"] as! String)!)
                            return
                        }
                    }
                } catch let e {
                    MLog.log(string: "Request mPin Reset Error:", e.localizedDescription)
                }
            } else if params == UrlsManager.API_SMART_CARD_REQUEST_TOKEN {
                MLog.log(string: "Request Token Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        if body["refTxnId"] != nil {
                            didRequestCardToken!(body["refTxnId"] as! String)
                            return
                        }
                    }
                } catch let e {
                    MLog.log(string: "Request mPin Reset Error:", e.localizedDescription)
                }
            }
        }
    }
    func onDataError(error: Error, service: GenericService, params: String) {
        
    }
}
