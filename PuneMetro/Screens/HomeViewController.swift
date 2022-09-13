//
//  HomeViewController.swift
//  PuneMetro
//
//  Created by Admin on 11/05/21.
//

import Foundation
import UIKit
import EasyTipView
import CoreLocation
import Kingfisher
class HomeViewController: UIViewController, ViewControllerLifeCycle, CLLocationManagerDelegate {
    
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var view11: HomeTile!
    @IBOutlet weak var view12: HomeTile!
    @IBOutlet weak var view13: HomeTile!
    @IBOutlet weak var view21: HomeTile!
    @IBOutlet weak var view22: HomeTile!
    @IBOutlet weak var view23: HomeTile!
    @IBOutlet weak var view31: HomeTile!
    @IBOutlet weak var view32: HomeTile!
    @IBOutlet weak var view33: HomeTile!
    @IBOutlet weak var view41: HomeTile!
    @IBOutlet weak var view42: HomeTile!
    @IBOutlet weak var view43: HomeTile!
    
    @IBOutlet weak var welcomeContainer: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var activeTicketContainer: UIView!
    @IBOutlet weak var activeTicketTitleLabel: UILabel!
    @IBOutlet weak var activeTicketTitleBorder: UIView!
    @IBOutlet weak var activeTicketStack: UIStackView!
    @IBOutlet weak var activeTicketFromContainer: UIView!
    @IBOutlet weak var activeTicketFromLabel: UILabel!
    @IBOutlet weak var activeTicketFromTitle: UILabel!
    @IBOutlet weak var activeFromImage: UIImageView!
    @IBOutlet weak var activeTicketToContainer: UIView!
    @IBOutlet weak var activeTicketToLabel: UILabel!
    @IBOutlet weak var activeTicketToTitle: UILabel!
    @IBOutlet weak var activeToImage: UIImageView!
    @IBOutlet weak var activeTicketChangeContainer: UIView!
    @IBOutlet weak var activeTicketChangeLabel: UILabel!
    @IBOutlet weak var activeTicketChangeTitle: UILabel!
    @IBOutlet weak var activeTicketProgress: UIView!
    @IBOutlet weak var activeTicketProgressWidth: NSLayoutConstraint!
    @IBOutlet weak var activeTicketExpiryLabel: UILabel!
    @IBOutlet weak var activeTicketExpiryValueLabel: UILabel!
    @IBOutlet weak var activeTicketPlatformImage: UIImageView!
    @IBOutlet weak var activeTicketPlatformBorder: UIView!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerLeftButton: UIButton!
    @IBOutlet weak var bannerRightButton: UIButton!
    var viewModel = HomeModel()
    var IsServiceError: Bool = false
    var IsNetWorkError: Bool = false
    var preferences = EasyTipView.Preferences()
    let splashViewModel = SplashModel()
    var locationManager: CLLocationManager?
    var banners: [Banners]!
    var timer = Timer()
    var counter = 0
    override func viewDidLoad() {
        registerCell()
        prepareUI()
        self.prepareViewModel()
        getLocationPermission()
        super.viewDidLoad()
        
    }
    func prepareViewModel() {
        viewModel.getBanners()
        viewModel.didActiveTicketsReceived = {
            self.loadActiveTicket()
        }
        viewModel.didStationsFetched = {
            self.viewModel.getActiveTickets()
        }
        viewModel.didGetBanners = {
            DispatchQueue.main.async {
                if !(self.viewModel.banners.isEmpty) {
                    self.bannerRightButton.isHidden = self.viewModel.banners.count > 1 ? false : true
                    let timeInterval = self.viewModel.banners.isEmpty ? 5 : self.viewModel.banners[0].bannerTransition
                   // self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                    self.bannerCollectionView.reloadData()
                }
            }
        }
        //        viewModel.loadActiveTickets()
        viewModel.fetchStations()
        viewModel.shownetworktimeout = {
            // Call Screen with retry
            MLog.log(string: "Network error")
            self.IsNetWorkError = true
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
            //            journeyResultVC.modalPresentationStyle = .fullScreen
            //            journeyResultVC.isNetworkError = true
            //            self.present(journeyResultVC, animated: true)
        }
        viewModel.showServertimeout = {
            // Call Screen with retry
            self.IsServiceError = true
            //            MLog.log(string: "Server error")
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
            //            journeyResultVC.modalPresentationStyle = .fullScreen
            //            journeyResultVC.isNetworkError = false
            //            self.present(journeyResultVC, animated: true)
        }
    }
    private func registerCell() {
        bannerCollectionView.register(cellType: HomeBannerCell.self)
    }
    func prepareUI() {
        
        self.navigationItem.largeTitleDisplayMode = .never
        metroNavBar.setup(titleStr: "Let's Go".localized(using: "Localization"), leftImage: nil, leftTap: {}, rightImage: UIImage(named: "home-profile-bold"), rightTap: {
            MLog.log(string: "Profile Tapped")
            self.goToProfile()
        })
        // if LocalDataManager.dataMgr().user.verifiedEmail {
        metroNavBar.rightButton.removeBadge()
        //        } else {
        //            metroNavBar.rightButton.addBadge(value: "1")
        //        }
        welcomeLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        welcomeLabel.textColor = .black
        welcomeLabel.text = "Welcome to Pune Metro".localized(using: "Localization")
        
        activeTicketContainer.isHidden = true
        activeTicketExpiryLabel.isHidden = true
        activeTicketExpiryValueLabel.isHidden = true
        activeTicketExpiryLabel.font = UIFont(name: "Roboto-Regular", size: 8)
        activeTicketExpiryLabel.text = "Entry on this ticket expires in".localized(using: "Localization")
        activeTicketExpiryValueLabel.font = UIFont(name: "Roboto-Regular", size: 10)
        activeTicketTitleLabel.font = UIFont(name: "Roboto-Regular", size: 8)
        activeTicketTitleLabel.text = "Active Ticket".localized(using: "Localization")
        activeTicketTitleBorder.createDottedLine(width: 0.5, color: activeTicketTitleLabel.textColor.cgColor)
        activeTicketPlatformBorder.createDottedLine(width: 0.5, color: activeTicketTitleLabel.textColor.cgColor)
        activeTicketFromTitle.font = UIFont(name: "Roboto-Regular", size: 8)
        activeTicketFromTitle.text = "From".localized(using: "Localization")
        activeTicketFromLabel.font = UIFont(name: "Roboto-Bold", size: 12)
        activeTicketToTitle.font = UIFont(name: "Roboto-Regular", size: 8)
        activeTicketToTitle.text = "To".localized(using: "Localization")
        activeTicketToLabel.font = UIFont(name: "Roboto-Bold", size: 12)
        
        activeTicketChangeTitle.font = UIFont(name: "Roboto-Regular", size: 8)
        activeTicketChangeTitle.text = "Change Station".localized(using: "Localization")
        activeTicketChangeLabel.font = UIFont(name: "Roboto-Bold", size: 10)
        
        activeTicketContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        
        view11.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        view11.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        view12.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        view12.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        
        view13.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        view13.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        view21.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        view21.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        
        view22.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        view22.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        view23.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        view23.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        
        view31.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        view31.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        
        view42.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        view42.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        
        // Last row
        view32.setup(font: UIFont(name: "Roboto-Regular", size: 13.5)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        view32.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        view33.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        view33.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        view33.imageView.contentMode = .scaleAspectFill
        view41.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        // view41.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        view43.setup(font: UIFont(name: "Roboto-Regular", size: 13.5)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        // view43.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        
        // view43.titleLabel.isHidden = true
        
        preferences.drawing.font = UIFont(name: "Roboto-Regular", size: 15)!
        preferences.drawing.foregroundColor = .black
        preferences.drawing.backgroundColor = CustomColors.COLOR_LIGHTEST_GREEN
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        preferences.drawing.borderWidth = 0.5
        preferences.drawing.borderColor = .black
        
        // Hiding metro map, Help, Customer Care
        view33.titleLabel.isHidden = false
        view33.imageView.isHidden = false
        
        view41.titleLabel.isHidden = true
        view41.imageView.isHidden = true
        
        view43.titleLabel.isHidden = true
        view43.imageView.isHidden = true
        stackView.cornerRadius = 10
       // stackView.layer.borderWidth = 1
       // stackView.layer.borderColor = UIColor.lightGray.cgColor
        bannerCollectionView.layer.cornerRadius = 10
        bannerCollectionView.isPagingEnabled = true
        bannerLeftButton.isHidden = true
        bannerRightButton.isHidden = true
        bannerLeftButton.addTarget(self, action: #selector(moveBannerToLeft), for: .touchUpInside)
        bannerRightButton.addTarget(self, action: #selector(moveBannerToRight), for: .touchUpInside)
    }
    @objc func changeImage() {
        if counter < self.viewModel.banners.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
           // self.pagecontroller.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
           // self.pagecontroller.currentPage = counter
            counter = 1
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        //        self.tabBarController!.setTabBarVisible(visible: false, duration: 0.3, animated: true)
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.isHidden = true
            self.view.layoutSubviews()
            self.prepareViewModel()
        }
    }
    //
    override func viewWillDisappear(_ animated: Bool) {
        //        self.tabBarController!.setTabBarVisible(visible: true, duration: 0.3, animated: true)
        self.timer.invalidate()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadActiveTicket() {
        welcomeContainer.isHidden = !viewModel.activeTickets.isEmpty
        activeTicketContainer.isHidden = viewModel.activeTickets.isEmpty
        
        if !viewModel.activeTickets.isEmpty {
            activeTicketExpiryLabel.isHidden = false
            activeTicketFromLabel.text = viewModel.activeTickets[0].trip.fromStn.name
            activeTicketToLabel.text = viewModel.activeTickets[0].trip.toStn.name
            
            MLog.log(string: "Ticket Lines:", viewModel.activeTickets[0].trip.fromStn.line, viewModel.activeTickets[0].trip.toStn.line)
            activeFromImage.image = (viewModel.activeTickets[0].trip.fromStn.line == StationLine.aqua) ? UIImage(named: "aqua-from") : UIImage(named: "purple-from")
            activeToImage.image = (viewModel.activeTickets[0].trip.toStn.line == StationLine.aqua) ? UIImage(named: "aqua-to") : UIImage(named: "purple-to")
            //            activeTicketPlatformImage.image = viewModel.activeTickets[0].trip.platform?.getImage()
            activeTicketPlatformImage.image = self.getPID(fromST: viewModel.activeTickets[0].trip.fromStn.shortName, toST: viewModel.activeTickets[0].trip.toStn.shortName)
           // UIImage(named: "SamplePlatform2")
            
            if viewModel.activeTickets[0].trip.fromStn.line == viewModel.activeTickets[0].trip.toStn.line {
                activeTicketStack.distribution = .fillProportionally
                activeTicketStack.spacing = 0
                activeTicketChangeContainer.isHidden = true
            } else {
                activeTicketStack.distribution = .equalSpacing
                activeTicketStack.spacing = 5
                activeTicketChangeContainer.isHidden = false
                activeTicketChangeLabel.text = "Civil Court"
            }
            let calendar = Calendar.current
            let minutes = calendar.dateComponents([.minute], from: viewModel.activeTickets[0].issueTime, to: Date()).minute!
            //            activeTicketExpiryValueLabel.isHidden = false
            activeTicketExpiryValueLabel.isHidden = true
            activeTicketExpiryLabel.isHidden = true
            if Globals.TICKET_ENTRY_EXPIRY_MINUTES - minutes < 0 {
                activeTicketExpiryValueLabel.text = "\(Globals.TICKET_EXIT_EXPIRY_MINUTES - minutes) mins"
                if (Globals.TICKET_EXIT_EXPIRY_MINUTES - minutes) > 60 {
                    let TotalTime = minutesToHoursAndMinutes(Globals.TICKET_EXIT_EXPIRY_MINUTES - minutes)
                    activeTicketExpiryValueLabel.text = "\(TotalTime.hours) hr, \(TotalTime.leftMinutes) mins"
                }
                let progressWidth = (activeTicketContainer.frame.width - 20) * CGFloat(Float(minutes) / Float(Globals.TICKET_EXIT_EXPIRY_MINUTES))
                activeTicketProgressWidth.constant = progressWidth
                activeTicketExpiryLabel.text = "Exit on this ticket expires in"
                if Float(minutes) < Float(Globals.TICKET_EXIT_EXPIRY_MINUTES) * 0.4 {
                    activeTicketProgress.backgroundColor = CustomColors.COLOR_PROGRESS_GREEN
                } else if Float(minutes) < Float(Globals.TICKET_EXIT_EXPIRY_MINUTES) * 0.8 {
                    activeTicketProgress.backgroundColor = CustomColors.COLOR_PROGRESS_YELLOW
                } else {
                    activeTicketProgress.backgroundColor = CustomColors.COLOR_PROGRESS_RED
                }
            } else {
                activeTicketExpiryValueLabel.text = "\(Globals.TICKET_ENTRY_EXPIRY_MINUTES - minutes) mins"
                
                let progressWidth = (activeTicketContainer.frame.width - 20) * CGFloat(Float(minutes) / Float(Globals.TICKET_ENTRY_EXPIRY_MINUTES))
                activeTicketProgressWidth.constant = progressWidth
                activeTicketExpiryLabel.text = "Entry on this ticket expires in"
                if Float(minutes) < Float(Globals.TICKET_ENTRY_EXPIRY_MINUTES) * 0.4 {
                    activeTicketProgress.backgroundColor = CustomColors.COLOR_PROGRESS_GREEN
                } else if Float(minutes) < Float(Globals.TICKET_ENTRY_EXPIRY_MINUTES) * 0.8 {
                    activeTicketProgress.backgroundColor = CustomColors.COLOR_PROGRESS_YELLOW
                } else {
                    activeTicketProgress.backgroundColor = CustomColors.COLOR_PROGRESS_RED
                }
            }
            
            activeTicketStack.layoutSubviews()
        }
    }
    func minutesToHoursAndMinutes (_ minutes: Int) -> (hours: Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func getLocationPermission() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        let previousAuthStatus = CLLocationManager.authorizationStatus()
        if previousAuthStatus == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            MLog.log(string: "Location Authoriation when in use older version")
        }
    }
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse {
            MLog.log(string: "Location Authoriation when in use")
        }
        
    }
    
    @objc func tileTap(_ sender: UITapGestureRecognizer) {
        MLog.log(string: "Tile Tapped")
        //        self.tabBarController!.setTabBarVisible(visible: true, duration: 0.3, animated: true)
        if self.IsNetWorkError {
            // Got from API
        }
        
        if self.IsServiceError {
            MLog.log(string: "Server error")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
            journeyResultVC.modalPresentationStyle = .fullScreen
            journeyResultVC.isNetworkError = false
            self.present(journeyResultVC, animated: true)
            return
        }
        switch sender.view {
        case activeTicketContainer:
            MLog.log(string: "View Ticket")
            self.tabBarController?.selectedIndex = 2
            //            goToMyTrips()
        case view11:
            
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
                        self.tabBarController?.selectedIndex = 1
                    }
                }
            }
            //            goToBooking()
            
        case view12:
            MLog.log(string: "View Ticket")
            self.tabBarController?.selectedIndex = 2
            //            goToMyTrips()
            
        case view13:
            CheckNetWorkError()
            goToFareEnquiry()
            
        case view21:
            MLog.log(string: "Feeder Services")
            goToFeederServices()
            
        case view22:
            //            MLog.log(string: "prev Loyalty Points")
            //            let tipView = EasyTipView(text: "This is Loyalty Points. Feature under development.".localized(using: "Localization"), preferences: preferences)
            //            tipView.show(forView: view22, withinSuperview: self.view)
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            //                tipView.dismiss()
            //            })
            MLog.log(string: "Stations List")
            goToStationsList()
            
        case view23:
            //            MLog.log(string: "Route Map")
            //            CheckNetWorkError()
            //            goToJourneyPlanner()
            
            //            MLog.log(string: "prev Journey Planner")
            //            let tipView = EasyTipView(text: "This feature is coming soon".localized(using: "Localization"), preferences: preferences)
            //            tipView.show(forView: view23, withinSuperview: self.view)
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            //                tipView.dismiss()
            //            })
            MLog.log(string: "Metro Map")
            self.goToMetroMap()
            
        case view31:
            //            MLog.log(string: "prev Explore Pune")
            //            goToTouristPlaces()
            MLog.log(string: "Help")
            goToHelp()
            
        case view32:
            //            MLog.log(string: "prev Stations List")
            //            goToStationsList()
            //            MLog.log(string: "Help")
            //            goToHelp()
            MLog.log(string: "Customer Care")
            goToCustomerCare()
            
        case view33:
            MLog.log(string: "Time table")
            self.goToTimeTable()
        case view41:
            MLog.log(string: "Help")
            goToHelp()
            
        case view42:
            //            MLog.log(string: "prev Smart Card")
            //            CheckNetWorkError()
            //            goToSmartCard()
            MLog.log(string: "Explore Pune")
            goToTouristPlaces()
            
        case view43:
            MLog.log(string: "Customer Care")
            goToCustomerCare()
            
        default:
            MLog.log(string: "Invalid Tap")
        }
        
    }
    
    func CheckNetWorkError() {
        if LocalReachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
        } else {
            print("Internet Connection not Available!")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
            journeyResultVC.modalPresentationStyle = .fullScreen
            journeyResultVC.isNetworkError = true
            self.present(journeyResultVC, animated: true)
            return
        }
    }
    func goToBooking() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let bookViewController = storyboard.instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
            bookViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(bookViewController, animated: true)
        }
    }
    
    func goToMyTrips() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ticketsListViewController = storyboard.instantiateViewController(withIdentifier: "TicketsListViewController") as! TicketsListViewController
            ticketsListViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(ticketsListViewController, animated: true)
        }
    }
    
    func goToFareEnquiry() {
        MLog.log(string: "Fare Enquiry")
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let fareEnquiryViewController = storyboard.instantiateViewController(withIdentifier: "FareEnquiryViewController") as! FareEnquiryViewController
            fareEnquiryViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(fareEnquiryViewController, animated: true)
        }
    }
    
    func goToTouristPlaces() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let placesListViewController = storyboard.instantiateViewController(withIdentifier: "PlacesListViewController") as! PlacesListViewController
            placesListViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(placesListViewController, animated: true)
        }
    }
    
    func goToStationsList() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let stationsListViewController = storyboard.instantiateViewController(withIdentifier: "StationsListViewController") as! StationsListViewController
            stationsListViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(stationsListViewController, animated: true)
        }
    }
    func goToJourneyPlanner() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let stationsListViewController = storyboard.instantiateViewController(withIdentifier: "JourneyPlannerViewController") as! JourneyPlannerViewController
            // let stationsListViewController = storyboard.instantiateViewController(withIdentifier: "JourneyResultViewController") as! JourneyResultViewController
            stationsListViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(stationsListViewController, animated: true)
        }
    }
    func goToHelp() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let helpViewController = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
            helpViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(helpViewController, animated: true)
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
    func goToCustomerCare() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let customerCareViewController = storyboard.instantiateViewController(withIdentifier: "CustomerCareViewController") as! CustomerCareViewController
            customerCareViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(customerCareViewController, animated: true)
        }
    }
    func goToFeederServices() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let feederServicesViewController = storyboard.instantiateViewController(withIdentifier: "FeederServicesViewController") as! FeederServicesViewController
            feederServicesViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(feederServicesViewController, animated: true)
        }
    }
    func goToSmartCard() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let smartCardHomeViewController = storyboard.instantiateViewController(withIdentifier: "SmartCardHomeViewController") as! SmartCardHomeViewController
            smartCardHomeViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(smartCardHomeViewController, animated: true)
        }
    }
    func goToMetroMap() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let metroMapViewController = storyboard.instantiateViewController(withIdentifier: "MetroMapViewController") as! MetroMapViewController
            metroMapViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(metroMapViewController, animated: true)
        }
    }
    func goToTimeTable() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let metroMapViewController = storyboard.instantiateViewController(withIdentifier: "TimeTableViewController") as! TimeTableViewController
            metroMapViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(metroMapViewController, animated: true)
        }
    }
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok".localized(using: "Localization"), style: UIAlertAction.Style.default, handler: {_ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: HomeBannerCell.self, for: indexPath)
        guard let URL = URL(string: self.viewModel.banners[indexPath.item].bannerImage) else { return cell}
        cell.imageView.kf.setImage(with: URL)
        // cell.setimage(url: self.viewModel.banners[indexPath.item].bannerImage)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       //c self.pagecontroller.currentPage = indexPath.section
    }
    @objc func moveBannerToLeft() {
        bannerLeftButton.isHidden = false
        bannerRightButton.isHidden = false
        counter -= 1
        if counter == 0 {
            bannerLeftButton.isHidden = true
        }
        let index = IndexPath.init(item: counter, section: 0)
        self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
    @objc func moveBannerToRight() {
        bannerLeftButton.isHidden = false
        bannerRightButton.isHidden = false
        counter += 1
        if counter+1 == viewModel.banners.count {
            bannerRightButton.isHidden = true
        }
        let index = IndexPath.init(item: counter, section: 0)
        self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.frame.size.height)
    }
}
extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
       // self.pagecontroller.currentPage = Int(roundedIndex)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //
        //pagecontroller.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
      //  pagecontroller.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let serviceUrl = URL(string: self.viewModel.banners[indexPath.item].bannerAnchorLink) {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(serviceUrl)) {
                application.open(serviceUrl, options: [:], completionHandler: nil)
            }
        } else {
            MLog.log(string: "Cannot Open:", self.viewModel.banners[indexPath.item].bannerAnchorLink)
        }
    }
}
extension HomeViewController {
    func getPID(fromST: String, toST: String) -> UIImage {
        let pArray = [["stations": "PIM",
                       "PIM": "-",
                       "STG": 1,
                       "BHO": 1,
                       "KWA": 1,
                       "PGD": 1,
                       "VNZ": "",
                       "AND": "",
                       "ICY": "",
                       "NST": "",
                       "GWC": ""
                      ],
                      [
                        "stations": "STG",
                        "PIM": 2,
                        "STG": "-",
                        "BHO": 1,
                        "KWA": 1,
                        "PGD": 1,
                        "VNZ": "",
                        "AND": "",
                        "ICY": "",
                        "NST": "",
                        "GWC": ""
                      ],
                      [
                        "stations": "BHO",
                        "PIM": 2,
                        "STG": 2,
                        "BHO": "-",
                        "KWA": 1,
                        "PGD": 1,
                        "VNZ": "",
                        "AND": "",
                        "ICY": "",
                        "NST": "",
                        "GWC": ""
                      ],
                      [
                        "stations": "KWA",
                        "PIM": 2,
                        "STG": 2,
                        "BHO": 2,
                        "KWA": "-",
                        "PGD": 1,
                        "VNZ": "",
                        "AND": "",
                        "ICY": "",
                        "NST": "",
                        "GWC": ""
                      ],
                      [
                        "stations": "PGD",
                        "PIM": 2,
                        "STG": 2,
                        "BHO": 2,
                        "KWA": 2,
                        "PGD": "-",
                        "VNZ": "",
                        "AND": "",
                        "ICY": "",
                        "NST": "",
                        "GWC": ""
                      ],
                      [
                        "stations": "VNZ",
                        "PIM": "",
                        "STG": "",
                        "BHO": "",
                        "KWA": "",
                        "PGD": "",
                        "VNZ": "-",
                        "AND": 1,
                        "ICY": 1,
                        "NST": 1,
                        "GWC": 1
                      ],
                      [
                        "stations": "AND",
                        "PIM": "",
                        "STG": "",
                        "BHO": "",
                        "KWA": "",
                        "PGD": "",
                        "VNZ": 2,
                        "AND": "-",
                        "ICY": 1,
                        "NST": 1,
                        "GWC": 1
                      ],
                      [
                        "stations": "ICY",
                        "PIM": "",
                        "STG": "",
                        "BHO": "",
                        "KWA": "",
                        "PGD": "",
                        "VNZ": 2,
                        "AND": 2,
                        "ICY": "-",
                        "NST": 1,
                        "GWC": 1
                      ],
                      [
                        "stations": "NST",
                        "PIM": "",
                        "STG": "",
                        "BHO": "",
                        "KWA": "",
                        "PGD": "",
                        "VNZ": 2,
                        "AND": 2,
                        "ICY": 2,
                        "NST": "-",
                        "GWC": 1
                      ],
                      [
                        "stations": "GWC",
                        "PIM": "",
                        "STG": "",
                        "BHO": "",
                        "KWA": "",
                        "PGD": "",
                        "VNZ": 1,
                        "AND": 1,
                        "ICY": 1,
                        "NST": 1,
                        "GWC": "-"
                      ]
        ]
        var img = UIImage(named: "platform-1")
        for s in 0..<pArray.count {
            let dict = pArray[s] as! [String: Any]
            let fST = dict["stations"] as! String
            if fromST == fST {
                let pID = dict[toST] as? Int ?? 0
                img = (pID == 1 ? UIImage(named: "platform-1") : UIImage(named: "platform-2"))!
            }
        }
        return img!
    }
}
