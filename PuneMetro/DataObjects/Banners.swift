//
//  Banners.swift
//  PuneMetro
//
//  Created by Venkat Rao Sandhi on 10/04/22.
//

import Foundation
class Banners {
    
    public var bannerImage: String = ""
    public var bannerText: String = ""
    public var bannerAnchorLink: String = ""
    public var bannerTransition: Int = 1
    public func initWithDictionary(bannerObj: [AnyHashable: Any]) {
        if let srImg: String = bannerObj["bannerImage"] as? String {
            bannerImage = srImg
        }
        if let srText: String = bannerObj["bannerText"] as? String {
            bannerText = srText
        }
        if let srAnchorLink: String = bannerObj["bannerAnchorLink"] as? String {
            bannerAnchorLink = srAnchorLink
        }
        if let bnTransition: String = bannerObj["bannerTransition"] as? String {
            bannerTransition = Int(bnTransition) ?? 1
        }
    }
    
}
