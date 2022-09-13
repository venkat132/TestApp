//
//  PGLoadingModel.swift
//  PuneMetro
//
//  Created by Admin on 11/05/21.
//

import Foundation
import PayUCheckoutProKit
import PayUCheckoutProBaseKit
import PayUParamsKit
import UIKit

protocol PGLoadingModelProtocol {
    var didCompletePayment: (() -> Void)? {get set}
    var didPaymentError: ((String) -> Void)? {get set}
    var didPaymentCancel: ((String) -> Void)? {get set}
    var didFetchTicket: ((Ticket) -> Void)? {get set}
    var didCreatedTicket: ((Ticket) -> Void)? {get set}
}

class PGLoadingModel: NSObject, GenericServiceDelegate, PGLoadingModelProtocol, PayUCheckoutProDelegate {
    var didPaymentError: ((String) -> Void)?
    var didCompletePayment: (() -> Void)?
    var didFetchTicket: ((Ticket) -> Void)?
    var didCreatedTicket: ((Ticket) -> Void)?
    var didPaymentCancel: ((String) -> Void)?
    
    var ticketingService: TicketingService?
    
    var ticket: Ticket?
    var paymentParams: PayUPaymentParam?
    var vc: UIViewController?
    
    var payUCheckoutConfig: PayUCheckoutProConfig?
    var payUHashHandler: PayUHashGenerationCompletion?
    
    func createTicket(trip: Trip, paymentMethod: PaymentMethod) {
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        let params = DaosManager.DAO_TICKETING_CREATE_TICKET.replacingOccurrences(of: "[IDSRCSTATION]", with: "\(trip.fromStn.idStation)").replacingOccurrences(of: "[NAMESRCSTATION]", with: trip.fromStn.name).replacingOccurrences(of: "[IDDSTSTATION]", with: "\(trip.toStn.idStation)").replacingOccurrences(of: "[NAMEDSTSTATION]", with: trip.toStn.name).replacingOccurrences(of: "[GROUPTICKET]", with: "\(trip.groupSize > 1)").replacingOccurrences(of: "[RETURN]", with: "false").replacingOccurrences(of: "[PRODUCTID]", with: trip.tripType.rawValue).replacingOccurrences(of: "[PAYMENT_METHOD]", with: paymentMethod.rawValue).replacingOccurrences(of: "[FARE]", with: "\(trip.fare)").replacingOccurrences(of: "[GROUPOSIZE]", with: "\(trip.groupSize)").replacingOccurrences(of: "[LAT]", with: "4444").replacingOccurrences(of: "[LON]", with: "4444")
        ticketingService?.createTicketTask(params: params)
    }
    
    func startPayment(vc: UIViewController, ticket: Ticket) {
        self.ticket = ticket
        self.vc = vc
        MLog.log(string: "Transaction ID Length:", ticket.idTicket.lengthOfBytes(using: .utf8))
        MLog.log(string: "Transaction ID Length:", "\(ticket.id).\(ticket.serial)")
        
        //PMT-1290 Start
        if(UrlsManager.IS_PROD_FLAG){
            //PMT-1332 starts
            //paymentParams = PayUPaymentParam(key: LocalDataManager.dataMgr().PGKey, transactionId: "\(ticket.id)T\(ticket.serial)", amount: "\(ticket.trip.fare).0", productInfo: "1", firstName: "", email: Globals.PG_GENERIC_EMAIL, phone: Globals.PG_GENERIC_MOBILE, surl: UrlsManager.PAYU_COMPLETION_URL, furl: UrlsManager.PAYU_COMPLETION_URL, environment: .production)
            paymentParams = PayUPaymentParam(key: LocalDataManager.dataMgr().PGKey, transactionId: "\(ticket.id)T\(ticket.serial)", amount: "\(ticket.trip.fare)", productInfo: "1", firstName: "", email: Globals.PG_GENERIC_EMAIL, phone: Globals.PG_GENERIC_MOBILE, surl: UrlsManager.PAYU_S_URL, furl: UrlsManager.PAYU_F_URL, environment: .production)
            //PMT-1332 ends
        }
        else{
            //PMT-1332 starts
            //paymentParams = PayUPaymentParam(key: LocalDataManager.dataMgr().PGKey, transactionId: "\(ticket.id)T\(ticket.serial)", amount: "\(ticket.trip.fare).0", productInfo: "1", firstName: "", email: Globals.PG_GENERIC_EMAIL, phone: Globals.PG_GENERIC_MOBILE, surl: UrlsManager.PAYU_COMPLETION_URL, furl: UrlsManager.PAYU_COMPLETION_URL, environment: .test)
            paymentParams = PayUPaymentParam(key: LocalDataManager.dataMgr().PGKey, transactionId: "\(ticket.id)T\(ticket.serial)", amount: "\(ticket.trip.fare)", productInfo: "1", firstName: "", email: Globals.PG_GENERIC_EMAIL, phone: Globals.PG_GENERIC_MOBILE, surl: UrlsManager.PAYU_S_URL, furl: UrlsManager.PAYU_F_URL, environment: .test)
        //PMT-1332 ends
        }
        //PMT-1290 End
        
        paymentParams?.userCredential = LocalDataManager.dataMgr().PGKey + ":\(LocalDataManager.dataMgr().user.idUser)"
        // MeGo Log :  [Optional("Transaction ID Length:"), Optional("7rnFly:1")]
        paymentParams?.additionalParam[PaymentParamConstant.udf1] = "ticket"
        paymentParams?.additionalParam[PaymentParamConstant.udf2] = Globals.PG_GENERIC_EMAIL
        paymentParams?.additionalParam[PaymentParamConstant.udf3] = Globals.PG_GENERIC_MOBILE
        paymentParams?.additionalParam[PaymentParamConstant.udf4] = "Pune"
        paymentParams?.additionalParam[PaymentParamConstant.udf5] = LocalDataManager.dataMgr().PGEncryptedToken
        
        paymentParams?.additionalParam[HashConstant.paymentRelatedDetailForMobileSDK] = ""
        paymentParams?.additionalParam[HashConstant.vasForMobileSDK] = ""
        paymentParams?.additionalParam[HashConstant.payment] = ""
        paymentParams?.additionalParam[HashConstant.getEmiAmountAccordingToInterest] = ""
        paymentParams?.additionalParam[HashConstant.eligibleBinsForEMI] = ""
        
        payUCheckoutConfig = PayUCheckoutProConfig()
        payUCheckoutConfig?.customiseUI(primaryColor: CustomColors.COLOR_DARK_BLUE, secondaryColor: UIColor.white)
        payUCheckoutConfig?.merchantLogo = UIImage(named: "Logo")
        payUCheckoutConfig?.merchantName = "Pune Metro"
        payUCheckoutConfig?.showExitConfirmationOnPaymentScreen = true
        payUCheckoutConfig?.showExitConfirmationOnCheckoutScreen = true
        payUCheckoutConfig?.cartDetails = [["\(ticket.trip.fromStn.name) - \(ticket.trip.toStn.name)": "₹ \(ticket.trip.fare)"]]
        
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        
        generateMobileSDKHashes()
        generatePaymentHash(isTopup: false)
        generateEMIHashes()
    }
    func startTopUpPayment(vc: UIViewController, amount: Double, idTransaction: String, serial: String) {
        self.vc = vc
        //PMT-1290 Start *** The call back URL below needs to be carefully updated when smart card changes are done. ***
        if (UrlsManager.IS_PROD_FLAG){
            paymentParams = PayUPaymentParam(key: LocalDataManager.dataMgr().PGKey, transactionId: "\(idTransaction)T\(serial)", amount: "\(amount).0", productInfo: "Topup Smartcard", firstName: "", email: Globals.PG_GENERIC_EMAIL, phone: Globals.PG_GENERIC_MOBILE, surl: UrlsManager.PAYU_COMPLETION_TOPUP_URL, furl: UrlsManager.PAYU_COMPLETION_TOPUP_URL, environment: .production)
        }
        else{
            paymentParams = PayUPaymentParam(key: LocalDataManager.dataMgr().PGKey, transactionId: "\(idTransaction)T\(serial)", amount: "\(amount).0", productInfo: "Topup Smartcard", firstName: "", email: Globals.PG_GENERIC_EMAIL, phone: Globals.PG_GENERIC_MOBILE, surl: UrlsManager.PAYU_COMPLETION_TOPUP_URL, furl: UrlsManager.PAYU_COMPLETION_TOPUP_URL, environment: .test)
        }
        //PMT-1290 End
        
        paymentParams?.userCredential = LocalDataManager.dataMgr().PGKey + ":\(LocalDataManager.dataMgr().user.idUser)"
        
        paymentParams?.additionalParam[PaymentParamConstant.udf1] = "topup"
        paymentParams?.additionalParam[PaymentParamConstant.udf2] = Globals.PG_GENERIC_EMAIL
        paymentParams?.additionalParam[PaymentParamConstant.udf3] = Globals.PG_GENERIC_MOBILE
        paymentParams?.additionalParam[PaymentParamConstant.udf4] = "Pune"
        paymentParams?.additionalParam[PaymentParamConstant.udf5] = LocalDataManager.dataMgr().PGEncryptedToken
        
        paymentParams?.additionalParam[HashConstant.paymentRelatedDetailForMobileSDK] = ""
        paymentParams?.additionalParam[HashConstant.vasForMobileSDK] = ""
        paymentParams?.additionalParam[HashConstant.payment] = ""
        paymentParams?.additionalParam[HashConstant.getEmiAmountAccordingToInterest] = ""
        paymentParams?.additionalParam[HashConstant.eligibleBinsForEMI] = ""
        
        payUCheckoutConfig = PayUCheckoutProConfig()
        payUCheckoutConfig?.customiseUI(primaryColor: CustomColors.COLOR_DARK_BLUE, secondaryColor: UIColor.white)
        payUCheckoutConfig?.merchantLogo = UIImage(named: "Logo")
        payUCheckoutConfig?.merchantName = "Pune Metro"
        payUCheckoutConfig?.showExitConfirmationOnPaymentScreen = true
        payUCheckoutConfig?.showExitConfirmationOnCheckoutScreen = true
        payUCheckoutConfig?.cartDetails = [["TopUp": "₹ \(amount)"]]
        
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        
        generateMobileSDKHashes()
        generatePaymentHash(isTopup: true)
        generateEMIHashes()
    }
    func verifyPaymentFunc(id: String) {
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        let params = DaosManager.VERIFY_PAYMENT.replacingOccurrences(of: "[ID]", with: id)
        ticketingService?.createVerifyPaymentFunc(params: params)
    }
    func generateMobileSDKHashes() {
        var hashStr = LocalDataManager.dataMgr().PGKey + "|"
        hashStr.append(HashConstant.paymentRelatedDetailForMobileSDK + "|")
        hashStr.append((paymentParams?.userCredential!)! + "|")
        let params = DaosManager.DAO_TICKENTING_GET_HASH.replacingOccurrences(of: "[PARAM]", with: hashStr)
        ticketingService?.getHashTask(params: params, hashName: HashConstant.paymentRelatedDetailForMobileSDK)
        
        hashStr = LocalDataManager.dataMgr().PGKey + "|"
        hashStr.append(HashConstant.vasForMobileSDK + "|default|")
        let paramsVas = DaosManager.DAO_TICKENTING_GET_HASH.replacingOccurrences(of: "[PARAM]", with: hashStr)
        ticketingService?.getHashTask(params: paramsVas, hashName: HashConstant.vasForMobileSDK)
    }
    
    func generatePaymentHash(isTopup: Bool) {
        var hashStr = LocalDataManager.dataMgr().PGKey + "|"
        hashStr.append(paymentParams!.transactionId + "|")
        hashStr.append(paymentParams!.amount + (isTopup ? "|Topup Smartcard|" : "|1|"))
        hashStr.append(paymentParams!.firstName + "|")
        hashStr.append(paymentParams!.email + "|")
        hashStr.append(paymentParams!.additionalParam[PaymentParamConstant.udf1] as! String + "|")
        hashStr.append(paymentParams!.additionalParam[PaymentParamConstant.udf2] as! String + "|")
        hashStr.append(paymentParams!.additionalParam[PaymentParamConstant.udf3] as! String + "|")
        hashStr.append(paymentParams!.additionalParam[PaymentParamConstant.udf4] as! String + "|")
        hashStr.append(paymentParams!.additionalParam[PaymentParamConstant.udf5] as! String + "|")
        hashStr.append("|||||")
        MLog.log(string: "Payment Hash String", hashStr)
        let paramsPayment = DaosManager.DAO_TICKENTING_GET_HASH.replacingOccurrences(of: "[PARAM]", with: hashStr)
        ticketingService?.getHashTask(params: paramsPayment, hashName: HashConstant.payment)
    }
    
    func generateEMIHashes() {
        var hashStr = LocalDataManager.dataMgr().PGKey + "|"
        hashStr.append(HashConstant.getEmiAmountAccordingToInterest + "|")
        hashStr.append(paymentParams!.amount + "|")
        let paramsEmi = DaosManager.DAO_TICKENTING_GET_HASH.replacingOccurrences(of: "[PARAM]", with: hashStr)
        ticketingService?.getHashTask(params: paramsEmi, hashName: HashConstant.getEmiAmountAccordingToInterest)
        
        hashStr = LocalDataManager.dataMgr().PGKey + "|"
        hashStr.append(HashConstant.eligibleBinsForEMI + "|default|")
        let paramsEligible = DaosManager.DAO_TICKENTING_GET_HASH.replacingOccurrences(of: "[PARAM]", with: hashStr)
        ticketingService?.getHashTask(params: paramsEligible, hashName: HashConstant.eligibleBinsForEMI)
    }
    
    func startCheckout() {
        //        flagPaymentStarted = true
        MLog.log(string: "Payu payment Params: ", paymentParams)
        MLog.log(string: "Payu params: ", paymentParams?.additionalParam)
        PayUCheckoutPro.open(on: self.vc!, paymentParam: paymentParams!, config: payUCheckoutConfig!, delegate: self)
    }
    
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if params == UrlsManager.API_VERIFYPAYMENTFUNCTION {
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                    return
                }
                
                if responseObj["code"] as! Int == 200 {
                    didCompletePayment!()
                } else {
                    didPaymentError!("Payment error. Try again...")
                }
            } catch let e {
                MLog.log(string: "Active Ticket Error:", e.localizedDescription)
                didCompletePayment!()
            }
        } else if service == ticketingService {
            do {
                MLog.log(string: "Ticket Response:", String(data: data, encoding: .utf8), params)
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                    return
                }
                if responseObj["code"] as! Int == 200 {
                    let body = responseObj["body"] as! [AnyHashable: Any]
                    if body["ticket"] == nil {
                        MLog.log(string: "Hash Rec:", [params: body["hash"] as! String])
                        if payUHashHandler != nil {
                            MLog.log(string: "in", body)
                            payUHashHandler!([params: body["hash"] as! String])
                        } else {
                            MLog.log(string: "out")
                            paymentParams?.additionalParam[params] = body["hash"] as! String
                            if paymentParams?.additionalParam[HashConstant.paymentRelatedDetailForMobileSDK] as! String != "" && paymentParams?.additionalParam[HashConstant.vasForMobileSDK] as! String != "" && paymentParams?.additionalParam[HashConstant.payment] as! String != "" && paymentParams?.additionalParam[HashConstant.getEmiAmountAccordingToInterest] as! String != "" && paymentParams?.additionalParam[HashConstant.eligibleBinsForEMI] as! String != "" {
                                self.startCheckout()
                            }
                        }
                    } else {
                        let ticketObj = body["ticket"] as! [AnyHashable: Any]
                        MLog.log(string: "Get Ticket TicketObj:", ticketObj)
                        let ticket = Ticket()
                        ticket.initWithDictionary(ticketObj: ticketObj)
                        if params == UrlsManager.API_TICKETING_CREATE_TICKET {
                            didCreatedTicket!(ticket)
                        } else if params == UrlsManager.API_TICKETING_GET_TICKET {
                            didFetchTicket!(ticket)
                        }
                    }
                } else {
                    MLog.log(string: "Ticket Service Error:", String(data: data, encoding: .utf8), params)
                }
            } catch let e {
                MLog.log(string: "Create Ticket Error:", e.localizedDescription)
            }
        }
    }
    
    func onDataError(error: Error, service: GenericService, params: String) {
        if service == ticketingService {
            MLog.log(string: "Ticket Service Error:", error.localizedDescription, params)
        }
    }
    
    /// This function is called when we successfully process the payment
    /// - Parameter response: success response
    func onPaymentSuccess(response: Any?) {
        MLog.log(string: "Success Response:", response)
        didCompletePayment!()
        
    }
    
    /// This function is called when we get failure while processing the payment
    /// - Parameter response: failure response
    func onPaymentFailure(response: Any?) {
        MLog.log(string: "Failure Response:", response)
        let resp = response as? NSDictionary
        let str = resp?["payuResponse"] as? Any
        let aryIds = str as? NSString
        let ids = aryIds?.components(separatedBy: ",")
        var TxnId = ""
        for id in 0..<(ids?.count ?? 0) {
            if let IDs = ids?[id], IDs.contains("txnid") {
                let txn = ids?[id].components(separatedBy: ":")
                if txn?.count ?? 0 > 1, let txnId = txn?[1] {
                    var TId = txnId.dropFirst(1)
                    TId = TId.dropLast(1)
                    TxnId = String(TId)
                }
            }
        }
       // didPaymentError!("Payment error. Try again...")
        verifyPaymentFunc(id: TxnId)
    }
    
    /// This function is called when the user cancel’s the transaction
    /// - Parameter isTxnInitiated: tells whether payment cancelled after reaching bankPage
    func onPaymentCancel(isTxnInitiated: Bool) {
        MLog.log(string: "Cancel Response:", isTxnInitiated)
        didPaymentCancel!("Payment cancelled...")
    }
    
    /// This function is called when we encounter some error while fetching payment options or there is some validation error
    /// - Parameter error: This contains error information
    func onError(_ error: Error?) {
        MLog.log(string: "Error Response:", error?.localizedDescription)
    }
    
    /// Use this function to provide hashes
    /// - Parameters:
    ///   - param: Dictionary that contains key as HashConstant.hashName & HashConstant.hashString
    ///   - onCompletion: Once you fetch the hash from server, pass that hash with key as param[HashConstant.hashName]
    func generateHash(for param: DictOfString, onCompletion: @escaping PayUHashGenerationCompletion) {
        
        // Send this string to your backend and append the salt at the end and send the sha512 back to us, do not calculate the hash at your client side, for security is reasons, hash has to be calculated at the server side
        payUHashHandler = onCompletion
        let hashStringWithoutSalt = param[HashConstant.hashString] ?? ""
        // Or you can send below string hashName to your backend and send the sha512 back to us, do not calculate the hash at your client side, for security is reasons, hash has to be calculated at the server side
        let hashName = param[HashConstant.hashName] ?? ""
        
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        MLog.log(string: "Dynamic Hash generation:", param)
        let params = DaosManager.DAO_TICKENTING_GET_HASH.replacingOccurrences(of: "[PARAM]", with: hashStringWithoutSalt.replacingOccurrences(of: "\"", with: "\\\"", options: .literal, range: nil))
        ticketingService?.getHashTask(params: params, hashName: hashName)
    }
    
    func getTicketDetails() {
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        let params = DaosManager.DAO_TICKENTING_GET_TICKET.replacingOccurrences(of: "[ID]", with: "\(self.ticket!.id)")
        ticketingService?.getTicketTask(params: params)
    }
    
}
