//
//  SmartCardTopUpModel.swift
//  PuneMetro
//
//  Created by Admin on 02/08/21.
//

import Foundation
protocol SmartCardTopUpModelProtocol {
    var didTopUpValidated: ((String, String) -> Void)? {get set}
    var didTransactionReceived: ((String) -> Void)? {get set}
}
class SmartCardTopUpModel: NSObject, SmartCardTopUpModelProtocol, GenericServiceDelegate {
    var didTopUpValidated: ((String, String) -> Void)?
    var didTransactionReceived: ((String) -> Void)?
    var smartCardService: SmartCardService?
    var ticketingService: TicketingService?
    func validateTopUp(amount: Double) {
        if smartCardService == nil {
            smartCardService = SmartCardService(delegate: self)
        }
        let params = DaosManager.DAO_SMART_CARD_VALIDATE_TOPUP.replacingOccurrences(of: "[AMOUNT]", with: "\(amount)")
        smartCardService?.validateTopupTask(params: params)
    }
    func getPaymentGatewayKey() {
        ticketingService = TicketingService(delegate: self)
        ticketingService?.getPaymentGatewayKeyTask()
    }
    func getTransaction(idTransaction: String) {
        if smartCardService == nil {
            smartCardService = SmartCardService(delegate: self)
        }
        let params = DaosManager.DAO_SMART_CARD_GET_TRANSACTION.replacingOccurrences(of: "[ID_TRANSACTION]", with: "\(idTransaction)")
        smartCardService?.getTransactionTask(params: params)
    }
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if service == smartCardService {
            if params == UrlsManager.API_SMART_CARD_VALIDATE_TOPUP {
                MLog.log(string: "Validate Topup Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        let transaction = body["transaction"] as! [AnyHashable: Any]
                        let id = Int(transaction["id"] as! String)
                        let serial = transaction["serial"] as! String
                        MLog.log(string: "Validate TopUp Transaction Id:", id, serial)
                        self.didTopUpValidated!("\(id!)", serial)
                        return
                    }
                } catch let e {
                    MLog.log(string: "Request mPin Reset Error:", e.localizedDescription)
                }
            } else if params == UrlsManager.API_SMART_CARD_GET_TRANSACTION {
                MLog.log(string: "Get Transaction Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        let transaction = body["transaction"] as! [AnyHashable: Any]
                        if transaction["refTxnId"] != nil {
                            didTransactionReceived!(transaction["refTxnId"] as! String)
                            return
                        }
                    }
                } catch let e {
                    MLog.log(string: "Get Transaction Error:", e.localizedDescription)
                }
            }
        } else if service == ticketingService {
            MLog.log(string: "Get Payment Gateway Key Response:", String(data: data, encoding: .utf8))
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                    return
                }
                if responseObj["code"] as! Int == 200 {
                    let body = responseObj["body"] as! [AnyHashable: Any]
                    LocalDataManager.dataMgr().PGKey = body["key"] as! String
                    LocalDataManager.dataMgr().PGHashPaymentDetails = body["hash_payment_details"] as! String
                    LocalDataManager.dataMgr().PGHashVasForMobile = body["hash_vas_for_mobile"] as! String
                    LocalDataManager.dataMgr().PGEncryptedToken = body["token"] as! String
                    LocalDataManager.dataMgr().saveToDefaults()
                }
            } catch let e {
                MLog.log(string: "Fetch Stations Error:", e.localizedDescription)
            }
        }
    }
    func onDataError(error: Error, service: GenericService, params: String) {
        
    }
}
