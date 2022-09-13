//
//  HomeViewController.swift
//  PuneMetro
//
//  Created by Admin on 20/04/21.
//

import Foundation
import UIKit
import DropDown

class BookViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var ticketContainer: UIView!
    @IBOutlet weak var bookingTabs: BookTicketTabs!
    @IBOutlet weak var bookingView: BookTicketView!
    @IBOutlet weak var comingSoonContainer: UIView!
    @IBOutlet weak var comingSoonLabel: UILabel!
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var topLoader: UIProgressView!
    
    var fromStnDropdown = DropDown()
    var toStnDropdown = DropDown()
    var viewModel = BookingModel()
    
    var allStnNames: [Station] = []
    var fromStnNames: [Station] = []
    var toStnNames: [Station] = []
    
    var fare: Double = 0.0
    var groupSize: Int = 1
    var bookingType: BookingType = .singleJourney
    var bookAgain: Bool = false
    let splashViewModel = SplashModel()
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.view.layoutSubviews()
        scrollView.layoutIfNeeded()
        MLog.log(string: "Heights1", self.view.frame.height, self.scrollView.frame.height)
        self.splashViewModel.setLoading = { loading in }
        self.splashViewModel.checkHaltMessage() { halt in
            if halt == true {
                DispatchQueue.main.async {
                    self.showAlert(msg: LocalDataManager.dataMgr().getbookingHaltMessage())
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
//        self.view.layoutSubviews()
//        scrollView.layoutIfNeeded()
        if self.tabBarController is HomeTabBarController {
            let home = self.tabBarController as! HomeTabBarController
            if home.bookAgainTicket != nil {
                bookAgain = true
                self.setBooking(ticket: home.bookAgainTicket!)
                home.bookAgainTicket = nil
            }
        }
    }
    
    func calculateFare() {
        if self.bookingView.originValueLabel.text! != "" && bookingView.destinationValueLabel.text! != "" {
            self.viewModel.calculateFare(fromStn: self.bookingView.originValueLabel.text!, toStn: self.bookingView.destinationValueLabel.text!, grpSize: self.groupSize, isReturn: bookingType == .returnJourney, bookingType: self.bookingType)
        }
    }
    
    func setBooking(ticket: Ticket) {
        self.loaderContainer.isHidden = false
        let splashView = SplashAnimationView(frame: self.view.frame)
        self.loaderContainer.addSubview(splashView)
        
        splashView.centerYAnchor.constraint(equalTo: self.loaderContainer.centerYAnchor).isActive = true
        splashView.centerXAnchor.constraint(equalTo: self.loaderContainer.centerXAnchor).isActive = true
        splashView.widthAnchor.constraint(equalTo: self.loaderContainer.widthAnchor).isActive = true
        splashView.heightAnchor.constraint(equalTo: self.loaderContainer.heightAnchor).isActive = true
        splashView.layoutSubviews()
        splashView.backgroundColor = .cyan
        splashView.logoGifImageView.startAnimatingGif()
        fromStnNames.removeAll()
        toStnNames.removeAll()
        allStnNames.removeAll()
        if !LocalDataManager.dataMgr().stations.isEmpty {
            for stn in LocalDataManager.dataMgr().stations {
                allStnNames.append(stn)
                if !(stn.name == ticket.trip.fromStn.name) {
                    toStnNames.append(stn)
                }
                if !(stn.name == ticket.trip.toStn.name) {
                    fromStnNames.append(stn)
                }
            }
            self.bookingView.originValueLabel.text = ticket.trip.fromStn.name
            self.bookingView.destinationValueLabel.text = ticket.trip.toStn.name
            prepareFromDropdown()
            prepareToDropdown()
            self.groupSize = ticket.trip.groupSize
            self.bookingType = ticket.trip.tripType
            
            self.bookingView.setup(bookingType: ticket.trip.tripType, size: ticket.trip.groupSize)
            self.calculateFare()
        }
    }
    func prepareUI() {
        
        if self.tabBarController is HomeTabBarController {
            let home = self.tabBarController as! HomeTabBarController
            self.loaderContainer.isHidden = home.bookAgainTicket == nil
        }
        
        metroNavBar.setup(titleStr: "Book Ticket".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.tabBarController?.selectedIndex = 0}, rightImage: UIImage(named: "profile-1"), rightTap: {
            MLog.log(string: "Profile Tapped")
            self.goToProfile()
        })
        topLoader.stopIndefinateProgress()
        topLoader.trackTintColor = CustomColors.LOADER_BG
        topLoader.progressTintColor = CustomColors.COLOR_PROGRESS_BLUE
        bookingTabs.initialSetup(bookingType: bookingType)
        bookingView.setup(bookingType: bookingType, size: 1)
        bookingTabs.singleTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabTapped)))
        bookingTabs.returnTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabTapped)))
        bookingTabs.groupTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabTapped)))
        bookingTabs.multiTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabTapped)))
        // Hiding for coming soon
        bookingTabs.multiTab.isHidden = true
        prepareBookView()
        comingSoonContainer.backgroundColor = .white
        comingSoonContainer.layer.cornerRadius = 10
        comingSoonContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        comingSoonContainer.clipsToBounds = true
        comingSoonContainer.isHidden = true
        comingSoonLabel.font = UIFont(name: "Roboto-Regular", size: 25)
        comingSoonLabel.text = "Coming Soon...".localized(using: "Localization")
    }
    func prepareViewModel() {
        viewModel.didStationsReceived = {
            if self.bookingView.originValueLabel.text! != "" && self.bookingView.destinationValueLabel.text != "" {
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
            self.bookingView.totalFareValueLabel.textColor = (self.fare > 0) ? CustomColors.COLOR_DARK_GRAY : CustomColors.COLOR_LIGHT_GRAY
            self.bookingView.totalFareValueLabel.text = "₹ \(self.fare)"
            self.bookingView.submitButton.setEnable(enable: self.fare > 0)
            if self.bookAgain {
                self.bookAgain = false
                self.loaderContainer.isHidden = true
                self.bookTap()
            }
        }
        viewModel.didDiscountMegReceived = { disCountTxt in
            self.bookingView.disscountLabel.text = disCountTxt
        }
        viewModel.didDiscountTxtColorReceived = { discountTextColor in
            self.bookingView.disscountLabel.textColor = CustomColors.hexStringToUIColor(hex: discountTextColor)
        }
        viewModel.setLoading = { loading in
            if loading {
                self.topLoader.startIndefinateProgress()
            } else {
                self.topLoader.stopIndefinateProgress()
            }
        }
        preparePrimaryTicket(shouldFetchStations: true)
        viewModel.getPaymentGatewayKey()
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
        if self.tabBarController is HomeTabBarController {
            let home = self.tabBarController as! HomeTabBarController
            if home.bookAgainTicket != nil {
                return
            }
        }
        fromStnNames.removeAll()
        toStnNames.removeAll()
        self.allStnNames.removeAll()
        if !LocalDataManager.dataMgr().stations.isEmpty {
// Start of changes for PMT-1287
//            for (index, stn) in LocalDataManager.dataMgr().stations.enumerated() {
//                fromStnNames.append(stn.name)
//                allStnNames.append(stn.name)
//                if index == 0 {
//                    bookingView.originValueLabel.text = stn.name
//                } else if LocalDataManager.dataMgr().isOnSameLine(stationName1: stn.name, stationName2: bookingView.originValueLabel.text!) {
//                    if bookingView.destinationValueLabel.text == "Destination Station".localized(using: "Localization") {
//                        bookingView.destinationValueLabel.text = stn.name
//                    }
//                    toStnNames.append(stn.name)
//                }
//            }
            var id: StationLine?
            for (index, stn) in LocalDataManager.dataMgr().stations.enumerated() {
                fromStnNames.append(stn)
                allStnNames.append(stn)
                if index == 0 {
                    bookingView.originValueLabel.text = stn.name
                    id  = stn.line
                } else if index == 1 {
                    bookingView.destinationValueLabel.text = stn.name
                    if stn.line == id {
                        toStnNames.append(stn)
                    }
                } else {
                    if stn.line == id {
                        toStnNames.append(stn)
                    }
                }
            }
// End of changes for PMT-1287
            prepareFromDropdown()
            prepareToDropdown()
            viewModel.calculateFare(fromStn: self.bookingView.originValueLabel.text!, toStn: self.bookingView.destinationValueLabel.text!, grpSize: self.groupSize, isReturn: bookingType == .returnJourney, bookingType: bookingType)
        }
        if shouldFetchStations {
            viewModel.fetchStations()
        }
    }
    
    func prepareFromDropdown() {
        fromStnDropdown.dataSource = fromStnNames.map({$0.name})
        fromStnDropdown.anchorView = bookingView.originValueLabel
        fromStnDropdown.direction = .bottom
        fromStnDropdown.backgroundColor = UIColor.white
        fromStnDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        fromStnDropdown.bottomOffset = CGPoint(x: 0, y: 0)
        // Code using sets logic
//        fromStnDropdown.selectionAction = { index, item in
//            self.bookingView.originValueLabel.text = item
//            self.toStnNames.removeAll()
//            for str in self.allStnNames where str != item  && LocalDataManager.dataMgr().isOnSameLine(stationName1: str, stationName2: item) {
//                self.toStnNames.append(str)
//            }
//            if self.bookingView.destinationValueLabel.text == item {
//                self.bookingView.destinationValueLabel.text = self.toStnNames[index]
//            }
//            self.prepareToDropdown()
//            self.viewModel.calculateFare(fromStn: self.bookingView.originValueLabel.text!, toStn: self.bookingView.destinationValueLabel.text!, grpSize: self.groupSize, isReturn: self.bookingType == .returnJourney, bookingType: self.bookingType)
//        }
        
        fromStnDropdown.selectionAction = { index, item in
            print(index)
            self.bookingView.originValueLabel.text = item
            self.toStnNames.removeAll()
           // for str in self.allStnNames where str.name != item {
                let id  = self.allStnNames.filter({$0.name == item}).map({$0.line})
                for stn in self.allStnNames where stn.line == id[0] && stn.name != item {
                self.toStnNames.append(stn)
               // }
            }
//            if self.bookingView.destinationValueLabel.text == item {
//                self.bookingView.destinationValueLabel.text = self.toStnNames[index].name
//            }
            if self.toStnNames[0] != nil {
                self.bookingView.destinationValueLabel.text = self.toStnNames[0].name
            }
            self.prepareToDropdown()
            self.viewModel.calculateFare(fromStn: self.bookingView.originValueLabel.text!, toStn: self.bookingView.destinationValueLabel.text!, grpSize: self.groupSize, isReturn: self.bookingType == .returnJourney, bookingType: self.bookingType)
        }
    }
    
    func prepareToDropdown() {
        toStnDropdown.dataSource = toStnNames.map({$0.name})
        toStnDropdown.anchorView = bookingView.destinationValueLabel
        toStnDropdown.direction = .bottom
        toStnDropdown.backgroundColor = UIColor.white
        toStnDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        toStnDropdown.bottomOffset = CGPoint(x: 0, y: 0)
        // code for using sets
//        toStnDropdown.selectionAction = { index, item in
//            self.bookingView.destinationValueLabel.text = item
//            self.fromStnNames.removeAll()
//            for str in self.allStnNames where str != item {
//                self.fromStnNames.append(str)
//            }
//            if self.bookingView.originValueLabel.text == item {
//                self.bookingView.originValueLabel.text = self.fromStnNames[index]
//            }
//            self.prepareFromDropdown()
//            self.viewModel.calculateFare(fromStn: self.bookingView.originValueLabel.text!, toStn: self.bookingView.destinationValueLabel.text!, grpSize: self.groupSize, isReturn: self.bookingType == .returnJourney, bookingType: self.bookingType)
//        }
        
        toStnDropdown.selectionAction = { index, item in
            self.bookingView.destinationValueLabel.text = item
            self.fromStnNames.removeAll()
            for str in self.allStnNames where str.name != item {
                self.fromStnNames.append(str)
            }
            if self.bookingView.originValueLabel.text == item {
                self.bookingView.originValueLabel.text = self.fromStnNames[index].name
            }
            self.prepareFromDropdown()
            self.viewModel.calculateFare(fromStn: self.bookingView.originValueLabel.text!, toStn: self.bookingView.destinationValueLabel.text!, grpSize: self.groupSize, isReturn: self.bookingType == .returnJourney, bookingType: self.bookingType)
        }
        
    }
    
    func prepareBookView() {
        
        comingSoonContainer.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
        comingSoonContainer.layer.borderWidth = 1
        
        bookingView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
        bookingView.layer.borderWidth = 1
        
        bookingView.originLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        bookingView.originLabel.text = "From Station".localized(using: "Localization")
        bookingView.originLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        bookingView.originValueLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        bookingView.originValueLabel.addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(fromStnTap))))
        
        bookingView.destinationLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        bookingView.destinationLabel.text = "To Station".localized(using: "Localization")
        bookingView.destinationLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        bookingView.destinationValueLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        bookingView.destinationValueLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toStnTap)))
        
        bookingView.noOfTicketsLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        bookingView.noOfTicketsLabel.text = "No. of tickets".localized(using: "Localization")
        bookingView.noOfTicketsLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        bookingView.pax1.font = UIFont(name: "Roboto-Regular", size: 18)
        bookingView.pax1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePaxSize)))
        bookingView.pax2.font = UIFont(name: "Roboto-Regular", size: 18)
        bookingView.pax2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePaxSize)))
        bookingView.pax3.font = UIFont(name: "Roboto-Regular", size: 18)
        bookingView.pax3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePaxSize)))
        bookingView.pax4.font = UIFont(name: "Roboto-Regular", size: 18)
        bookingView.pax4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePaxSize)))
        bookingView.pax5.font = UIFont(name: "Roboto-Regular", size: 18)
        bookingView.pax5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePaxSize)))
        bookingView.pax6.font = UIFont(name: "Roboto-Regular", size: 18)
        bookingView.pax6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePaxSize)))
        
        bookingView.groupSizeDec.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeGroupSize)))
        bookingView.groupSizeInc.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeGroupSize)))
        
        bookingView.totalFareLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        bookingView.totalFareLabel.text = "Total Fare".localized(using: "Localization")
        bookingView.totalFareLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        bookingView.totalFareValueLabel.font = UIFont(name: "Roboto-Medium", size: 35)
        bookingView.totalFareValueLabel.textColor = UIColor.lightGray
        self.bookingView.totalFareValueLabel.text = "₹ \(fare)"
        
        bookingView.submitButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        bookingView.submitButton.setAttributedTitle(title: NSAttributedString(string: "PAY NOW".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        bookingView.submitButton.onTap = bookTap
        bookingView.submitButton.setEnable(enable: false)
        bookingView.delegate = self
    }
    
    @objc func tabTapped(_ sender: UITapGestureRecognizer) {
        
        switch sender.view {
        case bookingTabs.singleTab:
            bookingType = .singleJourney
            groupSize = 1
        case bookingTabs.returnTab:
            bookingType = .returnJourney
            groupSize = 1
        case bookingTabs.groupTab:
            bookingType = .group
            groupSize = 10
        case bookingTabs.multiTab: bookingType = .multi
        default:
            MLog.log(string: "Invalid Booking Tab Selection")
        }
        bookingView.isHidden = bookingType == .multi
        comingSoonContainer.isHidden = bookingType != .multi
        bookingTabs.setSelection(bookingType: bookingType)
        bookingView.setup(bookingType: bookingType, size: groupSize)
        self.calculateFare()
        
    }
    
    @objc func fromStnTap(_ sender: UITapGestureRecognizer) {
        MLog.log(string: "From Dropdown", fromStnDropdown.show())
    }
    
    @objc func toStnTap(_ sender: UITapGestureRecognizer) {
        MLog.log(string: "To Dropdown", toStnDropdown.show())
    }
    
    @objc func changeGroupSize(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case self.bookingView.groupSizeDec:
            if self.groupSize > Globals.MIN_GROUP_SIZE {
                self.groupSize -= 1
            }
        case self.bookingView.groupSizeInc:
            if self.groupSize < Globals.MAX_GROUP_SIZE {
                self.groupSize += 1
            }
        default: MLog.log(string: "Invalid Group Size Tap")
        }
        self.bookingView.setGroupStack(groupSize: self.groupSize)
        self.calculateFare()
    }
    
    @objc func changePaxSize(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case self.bookingView.pax1: self.groupSize = 1
        case self.bookingView.pax2: self.groupSize = 2
        case self.bookingView.pax3: self.groupSize = 3
        case self.bookingView.pax4: self.groupSize = 4
        case self.bookingView.pax5: self.groupSize = 5
        case self.bookingView.pax6: self.groupSize = 6
        default: MLog.log(string: "Invalid Pax Size Tap")
        }
        self.bookingView.setPaxStack(paxNo: self.groupSize)
        self.calculateFare()
    }
    func bookTap() {
        MLog.log(string: "Book Tapped")
        let trip = Trip()
        trip.fromStn = LocalDataManager.dataMgr().getStationFromParticular(particular: self.bookingView.originValueLabel.text!)!
        trip.toStn = LocalDataManager.dataMgr().getStationFromParticular(particular: self.bookingView.destinationValueLabel.text!)!
        trip.isReturn = bookingType == .returnJourney
        trip.tripType = bookingType
        trip.fare = self.fare
        trip.groupSize = groupSize
        splashViewModel.setLoading = {(loading) in
            MLog.log(string: "Set Loading:", loading)
        }
        splashViewModel.onHaltTrue = { msg in
            print(msg)
        }
        self.splashViewModel.checkHaltMessage() { halt in
            if halt == true {
                DispatchQueue.main.async {
                    self.showAlert(msg: LocalDataManager.dataMgr().getbookingHaltMessage())
                }
            } else {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let confirmTicketViewController = storyboard.instantiateViewController(withIdentifier: "ConfirmTicketViewController") as! ConfirmTicketViewController
                    confirmTicketViewController.trip = trip
                    confirmTicketViewController.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(confirmTicketViewController, animated: true)
                }
            }
        }
    }
    
    func logout() {
        let tabVc = self.tabBarController as! HomeTabBarController
        tabVc.logout()
    }
    func goToProfile() {
        let tabVc = self.tabBarController as! HomeTabBarController
        tabVc.goToProfile()
    }
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok".localized(using: "Localization"), style: UIAlertAction.Style.default, handler: {_ in
           // self.navigationController?.popViewController(animated: true)
            self.goToHome()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func goToHome() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeTabBarController = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
            homeTabBarController.modalPresentationStyle = .fullScreen
            self.present(homeTabBarController, animated: true, completion: nil)
        }
    }
}

enum BookingType: String {
    case singleJourney = "SJT"
    case returnJourney = "RJT"
    case group = "GJT"
    case multi = "MJT"
    
    init(intVal: Int) {
        switch intVal {
        case 1:
            self = .singleJourney
        case 2:
            self = .returnJourney
        case 3:
            self = .group
        case 4:
            self = .multi
        default:
            self = .singleJourney
        }
    }
}

enum TicketType: String {
    case general
    case senior
    case student
}
extension BookViewController: BookTicketViewDelegate {
    func numberOfTickets(tickets: Int) {
        self.groupSize = tickets
        self.calculateFare()
    }
}
