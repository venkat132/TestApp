//
//  FeederServicesModel.swift
//  PuneMetro
//
//  Created by Admin on 15/07/21.
//

import Foundation
protocol FeederServicesModelProtocol {
    var onCategoryChange: (() -> Void)? {get set}
}
class FeederServicesModel: FeederServicesModelProtocol {
    var onCategoryChange: (() -> Void)?
    var feederServices: [FeederService] = []
    var filteredFeederServices: [FeederService] = []
    var selectedCategory: FeederServiceCategory = .all {
        didSet {
            filterServices()
        }
    }
    func loadServices() {
        do {
            let servicesObj = try JSONSerialization.jsonObject(with: StaticData.FEEDER_SERVICES.data(using: .utf8)!, options: []) as! [[AnyHashable: Any]]
            feederServices = []
            for obj in servicesObj {
                let title = obj["title"] as! String
                if title.lowercased() != "Parking".lowercased() && title.lowercased() != "Jeev Mobility".lowercased() {
                    feederServices.append(FeederService(serviceObj: obj))
                }
            }
            filterServices()
        } catch let e {
            MLog.log(string: "Service Parsing Error:", e.localizedDescription)
        }
    }
    func filterServices() {
        filteredFeederServices = []
        for service in feederServices {
            if service.category == selectedCategory || selectedCategory == .all {
                filteredFeederServices.append(service)
            }
        }
        onCategoryChange!()
    }
}
