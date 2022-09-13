//
//  BookTicketTabs.swift
//  PuneMetro
//
//  Created by Admin on 20/05/21.
//

import Foundation
import UIKit
class JourneyResultTabs: BaseView {
    
    @IBOutlet weak var FastestTab: UIView!
    @IBOutlet weak var FastestLabel: UILabel!
    @IBOutlet weak var CheapestTab: UIView!
    @IBOutlet weak var CheapestLabel: UILabel!
    @IBOutlet weak var LeastHopesTab: UIView!
    @IBOutlet weak var LeastHopesLabel: UILabel!
   
    func initialSetup(JourneyOption: JourneyOptionsSelection) {
        FastestTab.layer.cornerRadius = 10
        FastestTab.layer.borderWidth = 0.5
        FastestTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        FastestTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        FastestTab.clipsToBounds = true
        FastestLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        FastestLabel.text = "Fastest".localized(using: "Localization")
        FastestLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        FastestLabel.adjustsFontSizeToFitWidth = true
        
        CheapestTab.layer.cornerRadius = 10
        CheapestTab.layer.borderWidth = 0.5
        CheapestTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        CheapestTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        CheapestTab.clipsToBounds = true
        CheapestLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        CheapestLabel.text = "Cheapest".localized(using: "Localization")
        CheapestLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        LeastHopesTab.layer.cornerRadius = 10
        LeastHopesTab.layer.borderWidth = 0.5
        LeastHopesTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        LeastHopesTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        LeastHopesTab.clipsToBounds = true
        LeastHopesLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        LeastHopesLabel.text = "Least Hopes".localized(using: "Localization")
        LeastHopesLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        setSelection(JourneyOption: JourneyOption)
    }
    
    func setSelection(JourneyOption: JourneyOptionsSelection) {
        switch JourneyOption {
        case .Fastest:
            FastestTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            FastestTab.backgroundColor = CustomColors.COLOR_ORANGE
            FastestLabel.textColor = .white
            
            CheapestTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            CheapestTab.backgroundColor = .white
            CheapestLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            LeastHopesTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            LeastHopesTab.backgroundColor = .white
            LeastHopesLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
        case .Cheapest:
            CheapestTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            CheapestTab.backgroundColor = CustomColors.COLOR_ORANGE
            CheapestLabel.textColor = .white
            
            FastestTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            FastestTab.backgroundColor = .white
            FastestLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            LeastHopesTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            LeastHopesTab.backgroundColor = .white
            LeastHopesLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
       
        case .LeastHopes:
            LeastHopesTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            LeastHopesTab.backgroundColor = CustomColors.COLOR_ORANGE
            LeastHopesLabel.textColor = .white
            
            CheapestTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            CheapestTab.backgroundColor = .white
            CheapestLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            FastestTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            FastestTab.backgroundColor = .white
            FastestLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
      
        }
    }
}
