//
//  BookTicketTabs.swift
//  PuneMetro
//
//  Created by Admin on 20/05/21.
//

import Foundation
import UIKit
class BookTicketTabs: BaseView {
    
    @IBOutlet weak var singleTab: UIView!
    @IBOutlet weak var singleLogo: UIImageView!
    @IBOutlet weak var singleLabel: UILabel!
    @IBOutlet weak var returnTab: UIView!
    @IBOutlet weak var returnLogo: UIImageView!
    @IBOutlet weak var returnLabel: UILabel!
    @IBOutlet weak var groupTab: UIView!
    @IBOutlet weak var groupLogo: UIImageView!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var multiTab: UIView!
    @IBOutlet weak var multiLogo: UIImageView!
    @IBOutlet weak var multiLabel: UILabel!
    
    func initialSetup(bookingType: BookingType) {
        singleTab.layer.cornerRadius = 10
        singleTab.layer.borderWidth = 0.5
        singleTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        singleTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        singleTab.clipsToBounds = true
        singleLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        singleLabel.font = UIFont(name: "Roboto-Regular", size: 11)
        singleLabel.text = "One-Way".localized(using: "Localization")
        singleLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        singleLabel.adjustsFontSizeToFitWidth = true
        
        returnTab.layer.cornerRadius = 10
        returnTab.layer.borderWidth = 0.5
        returnTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        returnTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        returnTab.clipsToBounds = true
        returnLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        returnLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        returnLabel.text = "Return".localized(using: "Localization")
        returnLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        groupTab.layer.cornerRadius = 10
        groupTab.layer.borderWidth = 0.5
        groupTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        groupTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        groupTab.clipsToBounds = true
        groupLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        groupLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        groupLabel.text = "Group".localized(using: "Localization")
        groupLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        multiTab.layer.cornerRadius = 10
        multiTab.layer.borderWidth = 0.5
        multiTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        multiTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        multiTab.clipsToBounds = true
        multiLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        multiLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        multiLabel.text = "Various".localized(using: "Localization")
        multiLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        setSelection(bookingType: bookingType)
    }
    
    func setSelection(bookingType: BookingType) {
        switch bookingType {
        case .singleJourney:
            singleTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            singleTab.backgroundColor = CustomColors.COLOR_ORANGE
            singleLabel.textColor = .white
            singleLogo.tintColor = .white
            
            returnTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            returnTab.backgroundColor = .white
            returnLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            returnLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            groupTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            groupTab.backgroundColor = .white
            groupLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            groupLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            multiTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            multiTab.backgroundColor = .white
            multiLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            multiLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        case .returnJourney:
            returnTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            returnTab.backgroundColor = CustomColors.COLOR_ORANGE
            returnLabel.textColor = .white
            returnLogo.tintColor = .white
            
            singleTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            singleTab.backgroundColor = .white
            singleLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            singleLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            groupTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            groupTab.backgroundColor = .white
            groupLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            groupLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            multiTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            multiTab.backgroundColor = .white
            multiLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            multiLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        case .group:
            groupTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            groupTab.backgroundColor = CustomColors.COLOR_ORANGE
            groupLabel.textColor = .white
            groupLogo.tintColor = .white
            
            returnTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            returnTab.backgroundColor = .white
            returnLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            returnLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            singleTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            singleTab.backgroundColor = .white
            singleLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            singleLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            multiTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            multiTab.backgroundColor = .white
            multiLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            multiLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        case .multi:
            multiTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            multiTab.backgroundColor = CustomColors.COLOR_ORANGE
            multiLabel.textColor = .white
            multiLogo.tintColor = .white
            
            returnTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            returnTab.backgroundColor = .white
            returnLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            returnLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            groupTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            groupTab.backgroundColor = .white
            groupLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            groupLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            singleTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            singleTab.backgroundColor = .white
            singleLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            singleLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        }
    }
}
