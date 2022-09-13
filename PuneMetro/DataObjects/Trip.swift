//
//  Ticket.swift
//  PuneMetro
//
//  Created by Admin on 29/04/21.
//

import Foundation
import UIKit
class Trip {
    public var fromStn: Station = Station()
    public var toStn: Station = Station()
    public var fare: Double = 0.0
    public var isReturn: Bool = false
    public var groupSize: Int = 1
    public var tripType: BookingType = .singleJourney
    public var platform: Platform?
    
}
enum Platform: Int {
    case one = 1
    case two = 2
    
    func getImage() -> UIImage? {
        switch self {
            case .one:
                return UIImage(named: "platform-1")
            case .two:
                return UIImage(named: "platform-2")
        }
    }
}
