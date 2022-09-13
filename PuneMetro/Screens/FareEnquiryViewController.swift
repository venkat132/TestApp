//
//  FareEnquiryViewController.swift
//  PuneMetro
//
//  Created by Admin on 22/06/21.
//

import Foundation
import UIKit
import DropDown
class FareEnquiryViewController: UIViewController, ViewControllerLifeCycle {
    
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fareView: UIView!
    @IBOutlet weak var fareLabel: UILabel!
    @IBOutlet weak var fareValueLabel: UILabel!
    @IBOutlet weak var fareEnquiryView: FareEnquiryView!
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var dummyBorderView: UIView!
    var fromStnDropdown = DropDown()
    var toStnDropdown = DropDown()
    
    var allStnNames: [Station] = []
    var fromStnNames: [Station] = []
    var toStnNames: [Station] = []
    
    var fare: Double = 0.0
    var groupSize: Int = 1
    var bookingType: BookingType = .singleJourney
    var ticketType: TicketType = .general
    var bookAgain: Bool = false
    
    var viewModel = FareEnquiryModel()
    
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
        self.metroNavBar.setup(titleStr: "Fare Enquiry".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        
        fareLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        fareLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        fareLabel.text = "Fare".localized(using: "Localization")
        
        fareValueLabel.font = UIFont(name: "Roboto-Medium", size: 20)
        fareValueLabel.textColor = .black
        fareValueLabel.text = "₹ 00.00"
        
        if let tabBarController = tabBarController {
            scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        prepareFareEnquiryView()
    }
    func prepareViewModel() {
        viewModel.didStationsReceived = {
            if self.fareEnquiryView.originValueLabel.text! != "" && self.fareEnquiryView.destinationValueLabel.text != "" {
                self.preparePrimaryTicket(shouldFetchStations: false)
            } else {
                self.allStnNames = []
                self.fromStnNames = []
                for stn in LocalDataManager.dataMgr().stations {
                    self.allStnNames.append(stn)
                    self.fromStnNames.append(stn)
                }
                self.prepareFromDropdown()
            }
        }
        viewModel.didFareReceived = { fare in
            if self.bookingType == .group {
                self.fare = fare * Double(self.groupSize)
            } else {
                self.fare = fare
            }
            let nf = NumberFormatter()
            nf.minimumFractionDigits = 2
            nf.maximumFractionDigits = 2
            self.fareValueLabel.textColor = (self.fare > 0) ? .black : CustomColors.COLOR_LIGHT_GRAY
            self.fareValueLabel.text = "₹ \(nf.string(from: NSNumber(value: self.fare))!)"
        }
        viewModel.didDiscountMegReceived = { disCountTxt in
            self.discountLabel.text = disCountTxt
            self.discountLabel.isHidden = disCountTxt == "" ? true : false
        }
        viewModel.didDiscountTxtColorReceived = { discountTextColor in
            self.discountLabel.textColor = CustomColors.hexStringToUIColor(hex: discountTextColor)
        }
        preparePrimaryTicket(shouldFetchStations: true)
        viewModel.shownetworktimeout = {
            // Call Screen with retry
            MLog.log(string: "Network error")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
            journeyResultVC.modalPresentationStyle = .fullScreen
            journeyResultVC.isNetworkError = true
            self.present(journeyResultVC, animated: true)
        }
        viewModel.showServertimeout = {
            // Call Screen with retry
            MLog.log(string: "Server error")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
            journeyResultVC.modalPresentationStyle = .fullScreen
            journeyResultVC.isNetworkError = false
            self.present(journeyResultVC, animated: true)
        }
        
    }
    
    func preparePrimaryTicket(shouldFetchStations: Bool) {
        fromStnNames.removeAll()
        toStnNames.removeAll()
        self.allStnNames.removeAll()
        if !LocalDataManager.dataMgr().stations.isEmpty {
            var id: StationLine?
            for (index, stn) in LocalDataManager.dataMgr().stations.enumerated() {
                fromStnNames.append(stn)
                allStnNames.append(stn)
                if index == 0 {
                    self.fareEnquiryView.originValueLabel.text = stn.name
                    id  = stn.line
                } else if index == 1 {
                    self.fareEnquiryView.destinationValueLabel.text = stn.name
                    if stn.line == id {
                        toStnNames.append(stn)
                    }
                } else {
                    if stn.line == id {
                        toStnNames.append(stn)
                    }
                }
            }
            prepareFromDropdown()
            prepareToDropdown()
            viewModel.calculateFare(fromStn: self.fareEnquiryView.originValueLabel.text!, toStn: self.fareEnquiryView.destinationValueLabel.text!, grpSize: self.groupSize, isReturn: bookingType == .returnJourney, bookingType: bookingType)
        }
        if shouldFetchStations {
            viewModel.fetchStations()
        }
    }
    
    func prepareFromDropdown() {
        fromStnDropdown.dataSource = fromStnNames.map({$0.name})
        fromStnDropdown.anchorView = fareEnquiryView.originValueLabel
        fromStnDropdown.direction = .bottom
        fromStnDropdown.backgroundColor = UIColor.white
        fromStnDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        fromStnDropdown.bottomOffset = CGPoint(x: 0, y: 0)
        fromStnDropdown.selectionAction = { index, item in
            self.fareEnquiryView.originValueLabel.text = item
            self.toStnNames.removeAll()
//            for str in self.allStnNames where str != item {
//                self.toStnNames.append(str)
//            }
            let id  = self.allStnNames.filter({$0.name == item}).map({$0.line})
            for stn in self.allStnNames where stn.line == id[0] && stn.name != item {
            self.toStnNames.append(stn)
        }
//            if self.fareEnquiryView.destinationValueLabel.text == item {
//                self.fareEnquiryView.destinationValueLabel.text = self.toStnNames[index]
//            }
            if self.toStnNames[0] != nil {
                self.fareEnquiryView.destinationValueLabel.text = self.toStnNames[0].name
            }
            self.prepareToDropdown()
            self.viewModel.calculateFare(fromStn: self.fareEnquiryView.originValueLabel.text!, toStn: self.fareEnquiryView.destinationValueLabel.text!, grpSize: self.groupSize, isReturn: self.bookingType == .returnJourney, bookingType: self.bookingType)
        }
    }
    
    func prepareToDropdown() {
        toStnDropdown.dataSource = toStnNames.map({$0.name})
        toStnDropdown.anchorView = fareEnquiryView.destinationValueLabel
        toStnDropdown.direction = .bottom
        toStnDropdown.backgroundColor = UIColor.white
        toStnDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        toStnDropdown.bottomOffset = CGPoint(x: 0, y: 0)
        toStnDropdown.selectionAction = { index, item in
            self.fareEnquiryView.destinationValueLabel.text = item
            self.fromStnNames.removeAll()
            for str in self.allStnNames where str.name != item {
                self.fromStnNames.append(str)
            }
            if self.fareEnquiryView.originValueLabel.text == item {
                self.fareEnquiryView.originValueLabel.text = self.fromStnNames[index].name
            }
            self.prepareFromDropdown()
            self.viewModel.calculateFare(fromStn: self.fareEnquiryView.originValueLabel.text!, toStn: self.fareEnquiryView.destinationValueLabel.text!, grpSize: self.groupSize, isReturn: self.bookingType == .returnJourney, bookingType: self.bookingType)
        }
        
    }
    
    func prepareFareEnquiryView() {
        fareEnquiryView.initView(bookingType: bookingType, ticketType: ticketType)
        
        // fareEnquiryView.layer.borderWidth = 1
        // fareEnquiryView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
       // fareEnquiryView.addShadow()
        dummyBorderView.layer.borderWidth = 1
        dummyBorderView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
        dummyBorderView.layer.cornerRadius = 10
        dummyBorderView.addShadow()
        
        fareEnquiryView.originLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        fareEnquiryView.originLabel.text = "From".localized(using: "Localization")
        fareEnquiryView.originLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        fareEnquiryView.originValueLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        fareEnquiryView.originValueLabel.addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(fromStnTap))))
        
        fareEnquiryView.destinationLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        fareEnquiryView.destinationLabel.text = "To".localized(using: "Localization")
        fareEnquiryView.destinationLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        fareEnquiryView.destinationValueLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        fareEnquiryView.destinationValueLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toStnTap)))
        
        fareEnquiryView.journeyTypeSingleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookingTypeTap)))
        fareEnquiryView.journeyTypeReturnView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookingTypeTap)))
        
        fareEnquiryView.ticketTypeGeneralView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ticketTypeTap)))
        fareEnquiryView.ticketTypeSeniorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ticketTypeTap)))
        fareEnquiryView.ticketTypeStudentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ticketTypeTap)))
    }
    
    @objc func fromStnTap(_ sender: UITapGestureRecognizer) {
        MLog.log(string: "From Dropdown", fromStnDropdown.show())
    }
    
    @objc func toStnTap(_ sender: UITapGestureRecognizer) {
        MLog.log(string: "To Dropdown", toStnDropdown.show())
    }
    
    @objc func bookingTypeTap(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case fareEnquiryView.journeyTypeSingleView:
            self.bookingType = .singleJourney
        case fareEnquiryView.journeyTypeReturnView:
            self.bookingType = .returnJourney
        default:
            MLog.log(string: "Bookiing Type Invalid Selection")
        }
        fareEnquiryView.initView(bookingType: bookingType, ticketType: ticketType)
        viewModel.calculateFare(fromStn: self.fareEnquiryView.originValueLabel.text!, toStn: self.fareEnquiryView.destinationValueLabel.text!, grpSize: self.groupSize, isReturn: bookingType == .returnJourney, bookingType: bookingType)
    }
    
    @objc func ticketTypeTap(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case fareEnquiryView.ticketTypeGeneralView:
            self.ticketType = .general
        case fareEnquiryView.ticketTypeSeniorView:
            self.ticketType = .senior
        case fareEnquiryView.ticketTypeStudentView:
            self.ticketType = .student
        default:
            MLog.log(string: "Ticket Type Invalid Selection")
        }
        fareEnquiryView.initView(bookingType: bookingType, ticketType: ticketType)
        viewModel.calculateFare(fromStn: self.fareEnquiryView.originValueLabel.text!, toStn: self.fareEnquiryView.destinationValueLabel.text!, grpSize: self.groupSize, isReturn: bookingType == .returnJourney, bookingType: bookingType)
    }
}
