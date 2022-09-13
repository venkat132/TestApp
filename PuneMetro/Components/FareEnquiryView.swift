//
//  FareEnquiryView.swift
//  PuneMetro
//
//  Created by Admin on 22/06/21.
//

import Foundation
import UIKit
class FareEnquiryView: BaseView {
    
    @IBOutlet weak var journeyPathImage: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var destinationValueLabel: UILabel!
    @IBOutlet weak var seperator1: UIView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var originValueLabel: UILabel!
    @IBOutlet weak var seperator2: UIView!
    @IBOutlet weak var journeyTypeLabel: UILabel!
    @IBOutlet weak var journeyTypeStack: UIStackView!
    @IBOutlet weak var journeyTypeSingleView: UIView!
    @IBOutlet weak var singleLabel: UILabel!
    @IBOutlet weak var singleIcon: UIImageView!
    @IBOutlet weak var journeyTypeReturnView: UIView!
    @IBOutlet weak var returnLabel: UILabel!
    @IBOutlet weak var returnIcon: UIImageView!
    @IBOutlet weak var seperator3: UIView!
    @IBOutlet weak var ticketTypeLabel: UILabel!
    @IBOutlet weak var ticketTypeStack: UIStackView!
    @IBOutlet weak var ticketTypeGeneralView: UIView!
    @IBOutlet weak var generalIcon: UIImageView!
    @IBOutlet weak var generalLabel: UILabel!
    @IBOutlet weak var ticketTypeSeniorView: UIView!
    @IBOutlet weak var seniorIcon: UIImageView!
    @IBOutlet weak var seniorLabel: UILabel!
    @IBOutlet weak var ticketTypeStudentView: UIView! 
    @IBOutlet weak var studentIcon: UIImageView!
    @IBOutlet weak var studentLabel: UILabel!
    
    func initView(bookingType: BookingType, ticketType: TicketType) {
        journeyTypeSingleView.layer.cornerRadius = 10
        journeyTypeSingleView.layer.borderWidth = 0.5
        journeyTypeSingleView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        journeyTypeSingleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        journeyTypeSingleView.clipsToBounds = true
        journeyTypeSingleView.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        singleLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        singleLabel.text = "One-Way".localized(using: "Localization")
        singleLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        singleLabel.lineBreakMode = .byCharWrapping
        
        journeyTypeReturnView.layer.cornerRadius = 10
        journeyTypeReturnView.layer.borderWidth = 0.5
        journeyTypeReturnView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        journeyTypeReturnView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        journeyTypeReturnView.clipsToBounds = true
        journeyTypeReturnView.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        returnLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        returnLabel.text = "Return".localized(using: "Localization")
        returnLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        returnLabel.lineBreakMode = .byCharWrapping
        
        setBookingType(bookingType: bookingType)
        
        ticketTypeGeneralView.layer.cornerRadius = 10
        ticketTypeGeneralView.layer.borderWidth = 0.5
        ticketTypeGeneralView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        ticketTypeGeneralView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        ticketTypeGeneralView.clipsToBounds = true
        ticketTypeGeneralView.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        generalLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        generalLabel.text = "General".localized(using: "Localization")
        generalLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        ticketTypeSeniorView.layer.borderWidth = 0.5
        ticketTypeSeniorView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        ticketTypeSeniorView.clipsToBounds = true
        ticketTypeSeniorView.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        seniorLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        seniorLabel.text = "Senior Citizen".localized(using: "Localization")
        seniorLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        ticketTypeStudentView.layer.cornerRadius = 10
        ticketTypeStudentView.layer.borderWidth = 0.5
        ticketTypeStudentView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        ticketTypeStudentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        ticketTypeStudentView.clipsToBounds = true
        ticketTypeStudentView.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        studentLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        studentLabel.text = "Student".localized(using: "Localization")
        studentLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        journeyTypeLabel.text = "Journey Type".localized(using: "Localization")
        ticketTypeLabel.text = "Ticket Type".localized(using: "Localization")
        
        setTicketType(ticketType: ticketType)
    }
    
    func setBookingType(bookingType: BookingType) {
        switch bookingType {
        case .singleJourney:
            journeyPathImage.image = UIImage(named: "single-journey-path")
            journeyTypeSingleView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            journeyTypeSingleView.backgroundColor = CustomColors.COLOR_ORANGE
            singleLabel.textColor = .white
            singleIcon.tintColor = .white
            
            journeyTypeReturnView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            journeyTypeReturnView.backgroundColor = .white
            returnIcon.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            returnLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        case .returnJourney:
            journeyPathImage.image = UIImage(named: "return-journey-path")
            journeyTypeReturnView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            journeyTypeReturnView.backgroundColor = CustomColors.COLOR_ORANGE
            returnLabel.textColor = .white
            returnIcon.tintColor = .white
            
            journeyTypeSingleView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            journeyTypeSingleView.backgroundColor = .white
            singleIcon.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            singleLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        case .group:
            return
        case .multi:
            return
        }
    }
    
    func setTicketType(ticketType: TicketType) {
        switch ticketType {
        case .general:
            ticketTypeGeneralView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            ticketTypeGeneralView.backgroundColor = CustomColors.COLOR_ORANGE
            generalLabel.textColor = .white
            generalIcon.tintColor = .white
            
            ticketTypeSeniorView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            ticketTypeSeniorView.backgroundColor = .white
            seniorIcon.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            seniorLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            ticketTypeStudentView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            ticketTypeStudentView.backgroundColor = .white
            studentIcon.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            studentLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        case .senior:
            ticketTypeGeneralView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            ticketTypeGeneralView.backgroundColor = .white
            generalLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            generalIcon.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            
            ticketTypeSeniorView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            ticketTypeSeniorView.backgroundColor = CustomColors.COLOR_ORANGE
            seniorIcon.tintColor = .white
            seniorLabel.textColor = .white
            
            ticketTypeStudentView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            ticketTypeStudentView.backgroundColor = .white
            studentIcon.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            studentLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        case .student:
            ticketTypeGeneralView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            ticketTypeGeneralView.backgroundColor = .white
            generalLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            generalIcon.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            
            ticketTypeSeniorView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            ticketTypeSeniorView.backgroundColor = .white
            seniorIcon.tintColor = CustomColors.COLOR_MEDIUM_GRAY
            seniorLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            
            ticketTypeStudentView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            ticketTypeStudentView.backgroundColor = CustomColors.COLOR_ORANGE
            studentIcon.tintColor = .white
            studentLabel.textColor = .white
        }
    }
}
