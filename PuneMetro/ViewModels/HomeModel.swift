//
//  HomeModel.swift
//  PuneMetro
//
//  Created by Admin on 24/05/21.
//

import Foundation
protocol HomeModelProtocol {
    var didActiveTicketsReceived: (() -> Void)? {get set}
    var didStationsFetched: (() -> Void)? {get set}
    var shownetworktimeout: (() -> Void)? {get set}
    var showServertimeout: (() -> Void)? {get set}
    var didGetBanners: (() -> Void)? {get set}
}
class HomeModel: NSObject, HomeModelProtocol, GenericServiceDelegate {
    var showServertimeout: (() -> Void)?
    var shownetworktimeout: (() -> Void)?
    var didActiveTicketsReceived: (() -> Void)?
    var didStationsFetched: (() -> Void)?
    var didGetBanners: (() -> Void)?
    var ticketingService: TicketingService?
    var afcsService: AFCSService?
    var activeTickets: [Ticket] = []
    var banners: [Banners] = []
    func getActiveTickets() {
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        ticketingService?.getActiveTripsTask()
    }
    func fetchStations() {
        if afcsService == nil {
            afcsService = AFCSService(delegate: self)
        }
        afcsService?.getStationsTask()
    }
    func getBanners() {
        if ticketingService == nil {
            ticketingService = TicketingService(delegate: self)
        }
        ticketingService?.getBanners()
    }
    func onDataReceived(data: Data, service: GenericService, params: String) {
        if service == afcsService {
            if params == UrlsManager.API_AFCS_GET_STATIONS {
                MLog.log(string: "Get Stations Response:", String(data: data, encoding: .utf8))
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        showServertimeout!()
                        return
                    }
                    if responseObj["code"] as! Int == 200 {
                        let body = responseObj["body"] as! [AnyHashable: Any]
                        guard let setsObj = body["sets"] as? [[AnyHashable: Any]] else {
                            MLog.log(string: "Returning sets")
                            showServertimeout!()
                            return
                        }
                        if !setsObj.isEmpty {
                            LocalDataManager.dataMgr().sets.removeAll()
                            for obj in setsObj {
                                let sets = Sets()
                                sets.initWithDictionary(stnInfoJSON: obj)
                                LocalDataManager.dataMgr().sets.append(sets)
                            }
                            LocalDataManager.dataMgr().saveToDefaults()

                        }

                        guard let stationsObj = body["stations"] as? [AnyHashable: Any] else {
                            MLog.log(string: "Returning 1")
                            showServertimeout!()
                            return
                        }
                        guard let stationDetailsObj = stationsObj["stationDetailsList"] as? [[AnyHashable: Any]] else {
                            MLog.log(string: "Returning 2")
                            showServertimeout!()
                            return
                        }
                        if !stationDetailsObj.isEmpty {
                            LocalDataManager.dataMgr().stations.removeAll()
                            for obj in stationDetailsObj {
                                let station = Station()
                                station.initWithDictionary(stnInfoJSON: obj)
                                LocalDataManager.dataMgr().stations.append(station)
                            }
                            LocalDataManager.dataMgr().saveToDefaults()
                            didStationsFetched!()
                        }
                    }
                } catch let e {
                    MLog.log(string: "Request mPin Reset Error:", e.localizedDescription)
                }
            }
        } else if service == ticketingService {
            if params == UrlsManager.API_TICKETING_GET_ACTIVE_TRIPS {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    MLog.log(string: "Active Tickets response:", String(data: data, encoding: .utf8))
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
            } else if params == UrlsManager.API_GETBANNER_IMAGES {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        return
                    }
                    MLog.log(string: "Active Tickets response:", String(data: data, encoding: .utf8))
                    if responseObj["code"] as! Int == 200 {
                       // let body = responseObj["body"] as! [AnyHashable: Any]
                        if let bannerObj = responseObj["bannerList"] as? [[AnyHashable: Any]] {
                        banners = []
                        for obj in bannerObj {
                            let banner = Banners()
                            banner.initWithDictionary(bannerObj: obj)
                            banners.append(banner)
                        }
                        didGetBanners!()
                        }
                    } else {
                        MLog.log(string: "Active Ticket Error:", String(data: data, encoding: .utf8), params)
                    }
                } catch let e {
                    MLog.log(string: "Active Ticket Error:", e.localizedDescription)
                }
            }
        }
    }
    
    func onDataError(error: Error, service: GenericService, params: String) {
        if params == UrlsManager.API_TICKETING_GET_ACTIVE_TRIPS {
            MLog.log(string: "Active Tickets Error:", error.localizedDescription)
        }
        if params == UrlsManager.API_AFCS_GET_STATIONS {
            let code = (error as NSError).code
            switch code {
            case NSURLErrorTimedOut, NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorCannotConnectToHost:
                shownetworktimeout!()
            default:
                MLog.log(string: "Error:", error.localizedDescription, params)
            }
        }
   
    }
    
    func loadActiveTickets() {
        do {
            let ticketsObj = try JSONSerialization.jsonObject(with: LocalDataManager.dataMgr().activeTicketsStr.data(using: .utf8)!, options: []) as! [[AnyHashable: Any]]
            activeTickets = []
            for obj in ticketsObj {
                let ticket = Ticket()
                ticket.initWithDictionary(ticketObj: obj)
                ticket.isActive = true
                activeTickets.append(ticket)
            }
            didActiveTicketsReceived!()
        } catch let e {
            MLog.log(string: "Ticket Load Error", e.localizedDescription)
        }
    }
    
}
