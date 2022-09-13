//
//  SmartCardOTPModel.swift
//  PuneMetro
//
//  Created by Admin on 03/08/21.
//

import Foundation
protocol SmartCardOTPModelProtocol {
    var didBalanceReceived: ((Double) -> Void)? {get set}
    var dataDidChange: ((Bool) -> Void)? {get set}
    var showError: ((String) -> Void)? {get set}
    var didDebitProccessed: (() -> Void)? {get set}
    var goBack: (() -> Void)? {get set}
}
class SmartCardOTPModel: NSObject, GenericServiceDelegate, SmartCardOTPModelProtocol {
    var didBalanceReceived: ((Double) -> Void)?
    var dataDidChange: ((Bool) -> Void)?
    var showError: ((String) -> Void)?
    var didDebitProccessed: (() -> Void)?
    var goBack: (() -> Void)?
    var smartCardService: SmartCardService?
    var ticketingService: TicketingService?
    var otp: String? {
        didSet {
            dataDidChange!(otp!.trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 4)
        }
    }
    func getCardBalance() {
        if smartCardService == nil {
            smartCardService = SmartCardService(delegate: self)
        }
        smartCardService?.balanceEnquiryTask()
    }
    func generateCardToken(txnId: String) {
        if smartCardService == nil {
            smartCardService = SmartCardService(delegate: self)
        }
        let params = DaosManager.DAO_SMART_CARD_GENERATE_TOKEN.replacingOccurrences(of: "[TXN_ID]", with: txnId).replacingOccurrences(of: "[OTP]", with: otp!)
        smartCardService?.generateTokenTask(params: params)
    }
    func processTopUp(txnId: String, amount: Double) {
        if smartCardService == nil {
            smartCardService = SmartCardService(delegate: self)
        }
        let params = DaosManager.DAO_SMART_CARD_PROCESS_TOPUP.replacingOccurrences(of: "[TXN_ID]", with: txnId).replacingOccurrences(of: "[OTP]", with: otp!).replacingOccurrences(of: "[AMOUNT]", with: "\(amount)")
        smartCardService?.processTopupTask(params: params)
    }
    func issueAndUpdate(txnId: String, idTicket: String) {
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        let params = DaosManager.DAO_TICKETING_ISSUE_AND_UPDATE_QR_TICKET.replacingOccurrences(of: "[TXN_ID]", with: txnId).replacingOccurrences(of: "[OTP]", with: otp!).replacingOccurrences(of: "[ID]", with: "\(idTicket)")
        ticketingService?.issueAndUpdateQrTicketTask(params: params)
    }
    func processDebit(txnId: String, amount: Double) {
        if smartCardService == nil {
            smartCardService = SmartCardService(delegate: self)
        }
        let params = DaosManager.DAO_SMART_CARD_PROCESS_DEBIT.replacingOccurrences(of: "[TXN_ID]", with: txnId).replacingOccurrences(of: "[OTP]", with: otp!).replacingOccurrences(of: "[AMOUNT]", with: "\(amount)")
        smartCardService?.processDebitTask(params: params)
    }
    
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if service == smartCardService {
            if params == UrlsManager.API_SMART_CARD_GENERATE_TOKEN {
                MLog.log(string: "Smart Card Generate Token Response", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        goBack!()
                        return
                    } else {
                        showError!(responseObj["message"] as! String)
                        return
                    }
                } catch let e {
                    MLog.log(string: "Balance Enquiry Error:", e.localizedDescription)
                }
                showError!("Wrong OTP entered")
            } else if params == UrlsManager.API_SMART_CARD_PROCESS_TOPUP {
                MLog.log(string: "Smart Card Process Topup Response", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        goBack!()
                        return
                    }
                } catch let e {
                    MLog.log(string: "Balance Enquiry Error:", e.localizedDescription)
                }
                showError!("Wrong OTP entered")
            } else if params == UrlsManager.API_SMART_CARD_PROCESS_DEBIT {
                MLog.log(string: "Smart Card Process Debit Response", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
//                        goBack!()
                        didDebitProccessed!()
                        return
                    }
                } catch let e {
                    MLog.log(string: "Balance Enquiry Error:", e.localizedDescription)
                }
                showError!("Wrong OTP entered")
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
                    MLog.log(string: "Balance Enquiry Error:", e.localizedDescription)
                }
                showError!("Balance Enquiry error")
            }
        } else if service == ticketingService {
            if params == UrlsManager.API_TICKETING_ISSUE_AND_UPDATE_QR_TICKET {
                MLog.log(string: "Issue and Update Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        goBack!()
                        return
                    }
                } catch let e {
                    MLog.log(string: "Balance Enquiry Error:", e.localizedDescription)
                }
                showError!("Something went wrong")
            }
        }
    }
    func onDataError(error: Error, service: GenericService, params: String) {
        if service == smartCardService {
            if params == UrlsManager.API_SMART_CARD_GENERATE_TOKEN {
                MLog.log(string: "Smart Card Generate Token Error", error.localizedDescription)
            } else if params == UrlsManager.API_SMART_CARD_PROCESS_TOPUP {
                MLog.log(string: "Smart Card Process Topup Error", error.localizedDescription)
            } else if params == UrlsManager.API_SMART_CARD_PROCESS_DEBIT {
                MLog.log(string: "Smart Card Process Debit Error", error.localizedDescription)
            } else if params == UrlsManager.API_SMART_CARD_BALANCE_ENQUIRY {
                MLog.log(string: "Smart Card Balance Enquiry Error", error.localizedDescription)
            }
        } else if service == ticketingService {
            if params == UrlsManager.API_TICKETING_ISSUE_AND_UPDATE_QR_TICKET {
                MLog.log(string: "Issue and Update QR Ticket Error", error.localizedDescription)
            }
        }
    }
}
