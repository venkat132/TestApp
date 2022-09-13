//
//  TimeTable.swift
//  PuneMetro
//
//  Created by Venkat Rao Sandhi on 03/05/22.
//

import Foundation

class TimeTable {
    
    public var tableImageLink: String = ""
    public var tableHeader: String = ""
    public var tableID: Int = 0
    public var imgTransition: Int = 1
    public func initWithDictionary(TTObj: [AnyHashable: Any]) {
        if let srImg: String = TTObj["tableImageLink"] as? String {
            tableImageLink = srImg
        }
        if let srText: String = TTObj["tableHeader"] as? String {
            tableHeader = srText
        }
        if let tbID: Int = TTObj["tableID"] as? Int {
            tableID = tbID
        }
        if let imageTransition: Int = TTObj["imgTransition"] as? Int {
            imgTransition = imageTransition
        }
    }
    
}

