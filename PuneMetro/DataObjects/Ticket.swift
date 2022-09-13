//
//  Ticket.swift
//  PuneMetro
//
//  Created by Admin on 29/04/21.
//

import Foundation

class Ticket {
    public var trip: Trip = Trip()
    public var id: Int = 0
    public var idTransaction: String = ""
    public var idTicket: String = ""
    public var extPaymentRef: String = ""
    public var serial: String = ""
    public var qrs: [TicketQr] = []
    public var qrIndex: Int = 0
    public var qrExpanded: Bool = false
    public var isActive: Bool = false
    public var issueTime: Date = Date()
    public var validityTime: Date = Date()
    public var exitValidityTime: Date = Date()
    public var paymentMethod: PaymentMethod?
    public var correlationId: String = ""
    public var status: Status = .valid
    public func initWithDictionary(ticketObj: [AnyHashable: Any]) {
        trip.fromStn = LocalDataManager.dataMgr().getStationFromParticular(particular: Int(ticketObj["idSrcStation"] as! String)!)!
//        trip.fromStn.idStation = ticketObj["idSrcStation"] as! Int
//        trip.fromStn.name = ticketObj["srcStation"] as! String
        trip.toStn = LocalDataManager.dataMgr().getStationFromParticular(particular: Int(ticketObj["idDstStation"] as! String)!)!
//        trip.toStn.idStation = ticketObj["idDstStation"] as! Int
//        trip.toStn.name = ticketObj["dstStation"] as! String
        trip.platform = (trip.fromStn.idStation > trip.toStn.idStation) ? .one : .two
        let Fare = ticketObj["amount"] as? String
        trip.fare = Double(Fare!) ?? 0.0 // ticketObj["amount"] as? Double ?? 0.0
        if let productId: Int = ticketObj["productId"] as? Int {
            trip.tripType = BookingType.init(intVal: productId)
        } else if let productId: String = ticketObj["productId"] as? String {
            if Int(productId) == nil {
                trip.tripType = BookingType.init(rawValue: productId)!
            } else {
                trip.tripType = BookingType.init(intVal: Int(productId)!)
            }
        }
//        trip.isReturn = (ticketObj["returnJourney"] as! Int == 1)
        trip.isReturn = (trip.tripType == .returnJourney)
        trip.groupSize = ticketObj["groupSize"] as! Int
        id = Int(ticketObj["id"] as! String)!
//        idTicket = ticketObj["idTicket"] as! String
        if ticketObj["externalPaymentReference"] != nil && !(ticketObj["externalPaymentReference"] is NSNull) {
            extPaymentRef = (ticketObj["externalPaymentReference"] ?? "") as! String
        }
        if ticketObj["idTransaction"] != nil && !(ticketObj["idTransaction"] is NSNull) {
            idTransaction = ticketObj["idTransaction"] as! String
        }
        if ticketObj["paymentMethod"] != nil {
            if ticketObj["paymentMethod"] is String {
                let method: String = ticketObj["paymentMethod"] as! String
                if Int(method) == nil {
                    paymentMethod = PaymentMethod(rawValue: method)
                } else {
                    paymentMethod = PaymentMethod(intVal: Int(method)!)
                }
            } else if ticketObj["paymentMethod"] is Int {
                paymentMethod = PaymentMethod(intVal: ticketObj["paymentMethod"] as! Int)
            }
        }
        MLog.log(string: "Ticket Create Payment Method:", ticketObj["paymentMethod"], self.paymentMethod)
        if let sr: Int64 = ticketObj["serial"] as? Int64 {
            serial = "\(sr)"
        } else if let sr: String = ticketObj["serial"] as? String {
            serial = sr
        }

        if let issueTimestamp: String = ticketObj["issueTimestamp"] as? String {
            issueTime = Date(timeIntervalSince1970: Double(issueTimestamp)!)
            validityTime = Calendar.current.date(byAdding: .minute, value: Globals.TICKET_ENTRY_EXPIRY_MINUTES, to: issueTime)!
            exitValidityTime = Calendar.current.date(byAdding: .minute, value: Globals.TICKET_EXIT_EXPIRY_MINUTES, to: validityTime)!
        }
//        if let _: Double = ticketObj["validityTimestamp"] as? Double {
//            validityTime = Calendar.current.date(byAdding: .minute, value: Globals.TICKET_ENTRY_EXPIRY_MINUTES, to: issueTime)!
//            exitValidityTime = Calendar.current.date(byAdding: .minute, value: Globals.TICKET_EXIT_EXPIRY_MINUTES, to: validityTime)!
//        }
        if ticketObj["correlationId"] != nil {
            correlationId = ticketObj["correlationId"] as! String
        }
        if ticketObj["status"] != nil && ticketObj["status"] is Int {
            self.status = Status(rawValue: ticketObj["status"] as! Int)!
        }
//        serial = ticketObj["serial"] as! Int64
        guard let qrArr: [[AnyHashable: Any]] = ticketObj["qrs"] as? [[AnyHashable: Any]] else {
            return
        }
        
        for qrObj in qrArr {
            qrs.append(TicketQr(qrObj: qrObj))
        }
        MLog.log(string: "Transaction Status:", status)
    }
}

class TicketQr {
    public var id: Int = 0
    public var idTicket: String = ""
    public var qrString: String = ""
    public var qrStringUpdated: String = ""
    public var serial: String = ""
    public var correlationId: String = ""
    public var status: Status = .valid
    public var realtimeStatus: String?
    init(qrObj: [AnyHashable: Any]) {
        MLog.log(string: "QR Obj", qrObj)
        id = Int(qrObj["id"] as! String)!
//        idTicket = qrObj["idTicket"] as! String
        qrString = qrObj["qr"] as! String
        qrStringUpdated = QRUtils.updateQRCode(qrStr: qrString)
        if let sr: Int64 = qrObj["serial"] as? Int64 {
            serial = "\(sr)"
        } else if let sr: String = qrObj["serial"] as? String {
            serial = sr
        }
        if qrObj["correlationId"] != nil {
            correlationId = qrObj["correlationId"] as! String
        }
        if qrObj["status"] != nil && qrObj["status"] is Int {
                self.status = Status(rawValue: qrObj["status"] as! Int)!
        }
        realtimeStatus = qrObj["realtimeStatus"] as? String
        MLog.log(string: "QR Status:", status, realtimeStatus)
    }
}
enum PaymentMethod: String {
    case smartCard = "SC"
    case paymentGateway = "PG"
    case loyaltyPoints = "LP"
    
    init(intVal: Int) {
        switch intVal {
        case 0:
            self = .paymentGateway
        case 1:
            self = .smartCard
        case 2:
            self = .loyaltyPoints
        default:
            self = .paymentGateway
        }
    }
}

enum Status: Int {
    case incomplete = 0
    case valid = 1
    case cancelled = 2
    case partiallyCancelled = 3
    case fullyCancelled = 4
}
