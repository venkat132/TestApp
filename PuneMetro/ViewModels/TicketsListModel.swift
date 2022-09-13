//
//  TicketsListModel.swift
//  PuneMetro
//
//  Created by Admin on 13/05/21.
//

import Foundation

protocol TicketsListModelProtocol {
    var didActiveTicketsReceived:(() -> Void)? {get set}
    var didPastTicketsReceived:(() -> Void)? {get set}
    var didFiltersChanged: (() -> Void)? {get set}
    var showAlert: ((String) -> Void)? {get set}
    var didDownloadTicket: ((String) -> Void)? {get set}
}

class TicketsListModel: NSObject, TicketsListModelProtocol, GenericServiceDelegate {
    var didActiveTicketsReceived: (() -> Void)?
    var didPastTicketsReceived: (() -> Void)?
    var didFiltersChanged: (() -> Void)?
    var showAlert: ((String) -> Void)?
    var didDownloadTicket: ((String) -> Void)?
    var ticketingService: TicketingService?
    
    var activeTickets: [Ticket] = []
    var pastTickets: [Ticket] = []
    var filteredPastTickets: [Ticket] = []
    
    var selectedPgFilter: PgFilter = .all {
        didSet {
            loadPastTickets()
        }
    }
    var selectedDateRangeFilter: DateRangeFilter = .date1 {
        didSet {
            loadPastTickets()
        }
    }
    var dateRanges: [DateFilter] = []
    
    func getActiveTickets() {
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        ticketingService?.getActiveTripsTask()
    }
    
    func getPastTickets(offset: Int) {
        if offset == 0 {
            pastTickets = []
        }
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        let params = DaosManager.DAO_TICKENTING_GET_PAST_TRIPS.replacingOccurrences(of: "[OFFSET]", with: "\(offset)")
        ticketingService?.getPastTripsTask(params: params)
    }
    
    func cancelTransaction(ticket: Ticket) {
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        let params = DaosManager.DAO_TICKENTING_REFUND_TRANSACTION.replacingOccurrences(of: "[CORR_ID_TR]", with: "\(ticket.correlationId)")
        ticketingService?.refundTransactionTask(params: params)
    }
    
    func cancelTicket(ticket: Ticket, index: Int) {
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        let params = DaosManager.DAO_TICKENTING_REFUND_TICKET.replacingOccurrences(of: "[CORR_ID_TI]", with: "\(ticket.qrs[index].correlationId)")
        ticketingService?.refundTicketTask(params: params)
    }
    
    func downloadTicket(ticket: Ticket, index: Int) {
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        let params = DaosManager.DAO_DOWNLOAD_TICKET.replacingOccurrences(of: "[CORR_ID_TI]", with: "\(ticket.qrs[index].correlationId)")
        ticketingService?.downloadTicketTask(params: params)
    }
    
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if params == UrlsManager.API_TICKETING_GET_ACTIVE_TRIPS {
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                    return
                }
                
                if responseObj["code"] as! Int == 200 {
                    let body = responseObj["body"] as! [AnyHashable: Any]
                    let ticketsObj = body["tickets"] as! [[AnyHashable: Any]]
                    LocalDataManager.dataMgr().activeTicketsStr = String(data: try JSONSerialization.data(withJSONObject: ticketsObj, options: []), encoding: .utf8)!
                    LocalDataManager.dataMgr().saveToDefaults()
                    loadActiveTickets()
                } else {
                    MLog.log(string: "Active Ticket Error:", String(data: data, encoding: .utf8), params)
                }
            } catch let e {
                MLog.log(string: "Active Ticket Error:", e.localizedDescription)
            }
        } else if params == UrlsManager.API_TICKETING_GET_PAST_TRIPS {
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                    return
                }
                MLog.log(string: "Past Tickets response:", String(data: data, encoding: .utf8))
                if responseObj["code"] as! Int == 200 {
                    let body = responseObj["body"] as! [AnyHashable: Any]
                    let ticketsObj = body["tickets"] as! [[AnyHashable: Any]]
                    for obj in ticketsObj {
                        let ticket = Ticket()
                        ticket.isActive = false
                        ticket.initWithDictionary(ticketObj: obj)
                        pastTickets.append(ticket)
                    }
                    didPastTicketsReceived!()
                    loadPastTickets()
                } else {
                    MLog.log(string: "Past Ticket Error:", String(data: data, encoding: .utf8), params)
                }
            } catch let e {
                MLog.log(string: "Past Ticket Error:", e.localizedDescription)
            }
        } else if params == UrlsManager.API_TICKETING_REFUND_TRANSACTION {
            MLog.log(string: "Refund Transaction Response:", String(data: data, encoding: .utf8))
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                    return
                }
                if responseObj["code"] as! Int == 200 {
                    let body = responseObj["body"] as! [AnyHashable: Any]
                    let message = body["result"] as! String
                    showAlert!(message)
                } else {
                    MLog.log(string: "Refund Transaction Error1:", String(data: data, encoding: .utf8), params)
                }
            } catch let e {
                MLog.log(string: "Refund Transaction Error:", e.localizedDescription)
            }
        } else if params == UrlsManager.API_TICKETING_REFUND_TICKET {
            MLog.log(string: "Refund Ticket Response:", String(data: data, encoding: .utf8))
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                    return
                }
                if responseObj["code"] as! Int == 200 {
                    let body = responseObj["body"] as! [AnyHashable: Any]
                    let message = body["result"] as! String
                    showAlert!(message)
                } else {
                    MLog.log(string: "Refund Ticket Error1:", String(data: data, encoding: .utf8), params)
                    let message = responseObj["message"] as! String
                    showAlert!(message)
                }
            } catch let e {
                MLog.log(string: "Refund Ticket Error:", e.localizedDescription)
            }
        } else if params == UrlsManager.API_DOWNLOAD_TICKET {
            MLog.log(string: "Download Ticket Response:", String(data: data, encoding: .utf8))
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                    return
                }
                if responseObj["code"] as! Int == 200 {
                    let body = responseObj["body"] as! [AnyHashable: Any]
                    let fileName = body["fileName"] as! String
                    didDownloadTicket!(fileName)
                    
                } else {
                    MLog.log(string: "Download Ticket Error1:", String(data: data, encoding: .utf8), params)
                }
            } catch let e {
                MLog.log(string: "Download Ticket Error:", e.localizedDescription)
            }
        }
    }
    
    func onDataError(error: Error, service: GenericService, params: String) {
        if params == UrlsManager.API_TICKETING_GET_ACTIVE_TRIPS {
            MLog.log(string: "Active Tickets Error:", error.localizedDescription)
        } else if params == UrlsManager.API_TICKETING_GET_PAST_TRIPS {
            MLog.log(string: "Past Tickets Error:", error.localizedDescription)
        }
    }
    
    func loadActiveTickets(viewBookedTicket: Bool = false) {
        do {
            let ticketsObj = try JSONSerialization.jsonObject(with: LocalDataManager.dataMgr().activeTicketsStr.data(using: .utf8)!, options: []) as! [[AnyHashable: Any]]
            let tempTicketsArr = activeTickets
            activeTickets = []
            for (int, obj) in ticketsObj.enumerated() {
                let ticket = Ticket()
                ticket.initWithDictionary(ticketObj: obj)
                if int == 0 && viewBookedTicket {
                    ticket.qrExpanded = true
                }
                for t in tempTicketsArr where t.idTicket == ticket.idTicket {
                    ticket.qrIndex = t.qrIndex
                    ticket.qrExpanded = t.qrExpanded
                }
                ticket.isActive = true
                activeTickets.append(ticket)
            }
            didActiveTicketsReceived!()
        } catch let e {
            MLog.log(string: "Ticket Load Error", e.localizedDescription)
        }
    }
    
    func loadPastTickets() {
        filteredPastTickets.removeAll()
        for ticket in pastTickets {
            var flag: Bool = false
            switch selectedPgFilter {
            case .all: flag = true
            case .card: flag = ticket.paymentMethod! == .smartCard
            case .payU: flag = ticket.paymentMethod! == .paymentGateway
            case .points: flag = ticket.paymentMethod! == .loyaltyPoints
            }
            
            if flag {
                if ticket.issueTime < dateRanges[selectedDateRangeFilter.rawValue].startDate! && ticket.issueTime > dateRanges[selectedDateRangeFilter.rawValue].endDate! {
                    filteredPastTickets.append(ticket)
                }
            }
        }
        didFiltersChanged!()
    }
}
