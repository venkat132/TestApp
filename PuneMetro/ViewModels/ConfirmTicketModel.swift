//
//  ConfirmTicketModel.swift
//  PuneMetro
//
//  Created by Admin on 29/04/21.
//

import Foundation

protocol ConfirmTicketModelProtocol {
    var didCreatedTicket: ((Ticket) -> Void)? {get set}
    var didFareReceived: ((Double) -> Void)? {get set}
    var didSmartCardDebitValidated: ((String) -> Void)? {get set}
    var setLoading: ((Bool) -> Void)? {get set}
    var shownetworktimeout: (() -> Void)? {get set}
    var showServertimeout: (() -> Void)? {get set}
}

class ConfirmTicketModel: NSObject, ConfirmTicketModelProtocol, GenericServiceDelegate {
    var showServertimeout: (() -> Void)?
    var shownetworktimeout: (() -> Void)?
    var didCreatedTicket: ((Ticket) -> Void)?
    var didFareReceived: ((Double) -> Void)?
    var didSmartCardDebitValidated: ((String) -> Void)?
    var setLoading: ((Bool) -> Void)?
    var ticketingService: TicketingService?
    var afcsService: AFCSService?
    var smartCardService: SmartCardService?
    var ticket: Ticket?
    
    func calculateFare(trip: Trip) {
        setLoading!(true)
        if afcsService == nil {
            afcsService = AFCSService(delegate: self)
        }
        MLog.log(string: "Calculating Fare:", trip.fromStn.name, trip.toStn.name, trip.groupSize)
        let params = DaosManager.DAO_AFCS_GET_FARE.replacingOccurrences(of: "[IDSRCSTATION]", with: "\(trip.fromStn.idStation)").replacingOccurrences(of: "[IDDSTSTATION]", with: "\(trip.toStn.idStation)").replacingOccurrences(of: "[NUMTICKETS]", with: "\(trip.groupSize)").replacingOccurrences(of: "[GROUPOSIZE]", with: "\(trip.groupSize)").replacingOccurrences(of: "[PRODUCTID]", with: trip.tripType.rawValue).replacingOccurrences(of: "[LAT]", with: "4444").replacingOccurrences(of: "[LON]", with: "4444").replacingOccurrences(of: "[SRCSTATION]", with: trip.fromStn.name).replacingOccurrences(of: "[DSTSTATION]", with: trip.toStn.name).replacingOccurrences(of: "[IDSERVICEPROVIDER]", with: Globals.IDSERVICEPROVIDER).replacingOccurrences(of: "[IDSERVICETYPE]", with: Globals.IDSERVICETYPE)
        afcsService?.getFareTask(params: params)
    }
    
    func createTicket(trip: Trip, paymentMethod: PaymentMethod) {
        ticketingService = TicketingService(delegate: self)
//        let params = DaosManager.DAO_TICKETING_CREATE_TICKET.replacingOccurrences(of: "[IDSRCSTATION]", with: "\(trip.fromStn.idStation)").replacingOccurrences(of: "[NAMESRCSTATION]", with: trip.fromStn.name).replacingOccurrences(of: "[IDDSTSTATION]", with: "\(trip.toStn.idStation)").replacingOccurrences(of: "[NAMEDSTSTATION]", with: trip.toStn.name).replacingOccurrences(of: "[GROUPTICKET]", with: "\(trip.groupSize > 1)").replacingOccurrences(of: "[RETURN]", with: "false").replacingOccurrences(of: "[PRODUCTID]", with: trip.tripType.rawValue).replacingOccurrences(of: "[PAYMENT_METHOD]", with: paymentMethod.rawValue).replacingOccurrences(of: "[FARE]", with: "\(trip.fare)").replacingOccurrences(of: "[GROUPOSIZE]", with: "\(trip.groupSize)").replacingOccurrences(of: "[LAT]", with: "4444").replacingOccurrences(of: "[LON]", with: "4444")
//        ticketingService?.createTicketTask(params: params)
        ticketingService?.createTicketTask(params: DaosManager.DAO_TICKETING_CREATE_TICKET_NEW)
    }
    
    func validateDebit(amount: Double) {
        if smartCardService == nil {
            smartCardService = SmartCardService(delegate: self)
        }
        let params = DaosManager.DAO_SMART_CARD_VALIDATE_DEBIT.replacingOccurrences(of: "[AMOUNT]", with: "\(amount)")
        smartCardService?.validateDebitTask(params: params)
    }
    
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if service == ticketingService {
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                    return
                }
                if responseObj["code"] as! Int == 200 {
                    let body = responseObj["body"] as! [AnyHashable: Any]
                    let ticketObj = body["ticket"] as! [AnyHashable: Any]
                    let ticket = Ticket()
                    ticket.initWithDictionary(ticketObj: ticketObj)
                    didCreatedTicket!(ticket)
                    
                } else {
                    MLog.log(string: "Ticket Service Error:", String(data: data, encoding: .utf8), params)
                }
            } catch let e {
                MLog.log(string: "Create Ticket Error:", e.localizedDescription)
            }
        } else if service == afcsService {
            if params == UrlsManager.API_AFCS_GET_FARE {
                MLog.log(string: "Get Fare Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        guard let fareObj = body["fare"] as? [AnyHashable: Any] else {
                            showServertimeout!()
                            return
                        }
                        guard let responseBody = fareObj["responseBody"] as? [AnyHashable: Any] else {
                            showServertimeout!()
                            return
                        }
                        self.didFareReceived!(responseBody["totalFare"] as? Double ?? 0.0)
                    }
                } catch let e {
                    MLog.log(string: "Request mPin Reset Error:", e.localizedDescription)
                }
                setLoading!(false)
            }
        } else if service == smartCardService {
            if params == UrlsManager.API_SMART_CARD_VALIDATE_DEBIT {
                MLog.log(string: "Validate Debit Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        if body["refTxnId"] != nil {
                            didSmartCardDebitValidated!(body["refTxnId"] as! String)
                            return
                        }
                    }
                } catch let e {
                    MLog.log(string: "Validate Debit Error:", e.localizedDescription)
                }
            }
        }
    }
    
    func onDataError(error: Error, service: GenericService, params: String) {
        if service == ticketingService {
            MLog.log(string: "Create Ticket Error 1:", error.localizedDescription)
        } else if service == afcsService {
            MLog.log(string: "Get Fare Error:", error.localizedDescription)
            if params == UrlsManager.API_AFCS_GET_FARE {
                MLog.log(string: "Get Fare Error:", error.localizedDescription)
                setLoading!(false)
                let code = (error as NSError).code
                switch code {
                case NSURLErrorTimedOut, NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorCannotConnectToHost:
                    shownetworktimeout!()
                default:
                    MLog.log(string: "Error:", error.localizedDescription, params)
                }
            }
           
        }
    }
}
