//
//  BookingModel.swift
//  PuneMetro
//
//  Created by Admin on 28/04/21.
//

import Foundation
protocol BookingModelProtocol {
    var didStationsReceived: (() -> Void)? {get set}
    var didFareReceived: ((Double) -> Void)? {get set}
    var setLoading: ((Bool) -> Void)? {get set}
    var shownetworktimeout: (() -> Void)? {get set}
    var showServertimeout: (() -> Void)? {get set}
    var didDiscountMegReceived: ((String) -> Void)? {get set}
    var didDiscountTxtColorReceived: ((String) -> Void)? {get set}
}
class BookingModel: NSObject, BookingModelProtocol, GenericServiceDelegate {
    var showServertimeout: (() -> Void)?
    var shownetworktimeout: (() -> Void)?
    var didStationsReceived: (() -> Void)?
    var didFareReceived: ((Double) -> Void)?
    var setLoading: ((Bool) -> Void)?
    var afcsService: AFCSService?
    var ticketingService: TicketingService?
    var didDiscountMegReceived: ((String) -> Void)?
    var didDiscountTxtColorReceived: ((String) -> Void)?
    func fetchStations() {
        if afcsService == nil {
            afcsService = AFCSService(delegate: self)
        }
        afcsService?.getStationsTask()
    }
    func calculateFare(fromStn: String, toStn: String, grpSize: Int, isReturn: Bool, bookingType: BookingType) {
        setLoading!(true)
        if afcsService == nil {
            afcsService = AFCSService(delegate: self)
        }
        MLog.log(string: "Calculating Fare:", fromStn, toStn, grpSize)
        let params = DaosManager.DAO_AFCS_GET_FARE.replacingOccurrences(of: "[IDSRCSTATION]", with: "\(LocalDataManager.dataMgr().getStationID(stationName: fromStn))").replacingOccurrences(of: "[IDDSTSTATION]", with: "\(LocalDataManager.dataMgr().getStationID(stationName: toStn))").replacingOccurrences(of: "[NUMTICKETS]", with: "\(grpSize)").replacingOccurrences(of: "[GROUPOSIZE]", with: "\(grpSize)").replacingOccurrences(of: "[PRODUCTID]", with: bookingType.rawValue).replacingOccurrences(of: "[LAT]", with: "4444").replacingOccurrences(of: "[LON]", with: "4444").replacingOccurrences(of: "[SRCSTATION]", with: fromStn).replacingOccurrences(of: "[DSTSTATION]", with: toStn).replacingOccurrences(of: "[IDSERVICEPROVIDER]", with: Globals.IDSERVICEPROVIDER).replacingOccurrences(of: "[IDSERVICETYPE]", with: Globals.IDSERVICETYPE)
        afcsService?.getFareTask(params: params)
    }
    
    func getPaymentGatewayKey() {
        ticketingService = TicketingService(delegate: self)
        ticketingService?.getPaymentGatewayKeyTask()
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
                        MLog.log(string: "Station Details", stationDetailsObj)
                        if !stationDetailsObj.isEmpty {
                            LocalDataManager.dataMgr().stations.removeAll()
                            for obj in stationDetailsObj {
                                let station = Station()
                                station.initWithDictionary(stnInfoJSON: obj)
                                LocalDataManager.dataMgr().stations.append(station)
                            }
                            LocalDataManager.dataMgr().saveToDefaults()
                            self.didStationsReceived!()
                        }
                    }
                } catch let e {
                    MLog.log(string: "Request mPin Reset Error:", e.localizedDescription)
                }
            } else if params == UrlsManager.API_AFCS_GET_FARE {
                MLog.log(string: "Get Fare Response:", String(data: data, encoding: .utf8))
                do {
                    setLoading!(false)
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseObj = responseJSON as? [AnyHashable: Any] else {
                        showServertimeout!()
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
                        self.didDiscountMegReceived!(responseObj["discount_text"] as? String ?? "")
                        self.didDiscountTxtColorReceived!(responseObj["discount_color"] as? String ?? "#000000")
                    }
                } catch let e {
                    MLog.log(string: "Request mPin Reset Error:", e.localizedDescription)
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
        if service == afcsService {
            if params == UrlsManager.API_AFCS_GET_STATIONS {
                MLog.log(string: "Fetch Stations Error:", error.localizedDescription)
            } else if params == UrlsManager.API_AFCS_GET_FARE {
                MLog.log(string: "Get Fare Error:", error.localizedDescription)
                setLoading!(false)
            }
            let code = (error as NSError).code
            switch code {
            case NSURLErrorTimedOut, NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorCannotConnectToHost:
                shownetworktimeout!()
            default:
                MLog.log(string: "Error:", error.localizedDescription, params)
            }
        } else if service == ticketingService {
            MLog.log(string: "Get Payment Gateway Key Error:", error.localizedDescription)
        }
    }
    
}
