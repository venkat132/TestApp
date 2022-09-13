//
//  PlacesListModel.swift
//  PuneMetro
//
//  Created by Admin on 12/05/21.
//

import Foundation

protocol PlacesListModelProtocol {
    var didChangeData: (() -> Void)? {get set}
}

class PlacesListModel: PlacesListModelProtocol {
    var didChangeData: (() -> Void)?
    
    var searchString: String = "" {
        didSet {
            filterData()
        }
    }
    var places: [TourPlace] = []
    func filterData() {
        places = []
        
        let StaticArr = NSMutableArray()
        
        for place in LocalDataManager.dataMgr().touristPlaces where (place.title.localized(using: "Localization").lowercased().contains(searchString.lowercased()) || searchString == "") {
            // places.append(place)
            StaticArr.add(place.title.localized(using: "Localization").lowercased())
        }
        // For sorting Purpose
        let sortedResults = StaticArr.sorted {($0 as! String).caseInsensitiveCompare($1 as! String) == .orderedAscending}
        // MLog.log(string: "sorted Results", sortedResults)
        for PlaceName in sortedResults {
            for place in LocalDataManager.dataMgr().touristPlaces where (place.title.localized(using: "Localization").lowercased().contains(searchString.lowercased()) || searchString == "") {
                if place.title.localized(using: "Localization").lowercased() == PlaceName as! String {
                    places.append(place)
                    break
                }
                
            }
            
        }
        
        didChangeData!()
    }
}
