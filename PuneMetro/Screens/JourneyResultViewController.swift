//
//  JourneyResultViewController.swift
//  PuneMetro
//
//  Created by Admin on 13/10/21.
//

import UIKit
import GoogleMaps

class JourneyResultViewController: UIViewController, ViewControllerLifeCycle {
   
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var tabsStack: UIStackView!
    @IBOutlet weak var activeTab: UIView!
    @IBOutlet weak var activeTabLabel: UILabel!
    @IBOutlet weak var activeTabBottomLine: UIView!
    
    @IBOutlet weak var pastTab: UIView!
    @IBOutlet weak var pastTabLabel: UILabel!
    @IBOutlet weak var pastTabBottomLine: UIView!
    @IBOutlet weak var JourneyTabs: JourneyResultTabs!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var TotalDisAndTimeView: UIView!
    @IBOutlet weak var TotalTimelbl: UILabel!
    @IBOutlet weak var TotalTimeValuelbl: UILabel!
    @IBOutlet weak var TotalDistancelbl: UILabel!
    @IBOutlet weak var TotalDistanceValuelbl: UILabel!
    @IBOutlet weak var ContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var LoadingLbl: UILabel!
    @IBOutlet weak var LoaderAct: UIActivityIndicatorView!
    
    var JourneyBackView: UIView!
    var JourneyPart1Option: JPPart1Type = .Walk
    var JourneyPart3Option: JPPart1Type = .Walk
    var JourneyPart5Option: JPPart1Type = .Walk
    var TotalNumberOfParts: Int = 0
    
    @IBOutlet var mapView: GMSMapView!
        
    var selection: JourneyTabSelection = .Instruction
    var JourneyOption: JourneyOptionsSelection = .Fastest
    var fromPlaceLatLong = String()
    var toPlaceLatLong = String()
    var fromPlace = String()
    var toPlace = String()
    var journeyPlannerModel = JourneyPlannerModel()
    
    override func viewDidLoad() {
        prepareUI()
        prepareViewModel()
        super.viewDidLoad()
    }
    func prepareUI() {
        metroNavBar.setup(titleStr: "Journey Planner".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})

        if let tabBarController = tabBarController {
            self.scrollview.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        
        // set view for adding part journey
        self.JourneyBackView = UIView()
        self.ContentView.addSubview(self.JourneyBackView)
        
        activeTabLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        activeTabLabel.text = "Instruction".localized(using: "Localization")
        activeTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSelectionTab)))
        pastTabLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        pastTabLabel.text = "Map".localized(using: "Localization")
        pastTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSelectionTab)))
        
        activeTab.layer.cornerRadius = 10
        activeTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        activeTab.layer.borderWidth = 0
        activeTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        
        pastTab.layer.cornerRadius = 10
        pastTab.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        pastTab.layer.borderWidth = 0
        pastTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        setSelection()
        
        JourneyTabs.initialSetup(JourneyOption: .Fastest)
        JourneyTabs.FastestTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabTapped)))
        JourneyTabs.CheapestTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabTapped)))
        JourneyTabs.LeastHopesTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabTapped)))

        // Set Loader
        self.LoadingLbl.font = UIFont(name: "Roboto-Regular", size: 18)
        self.LoadingLbl.text = "Planning Your Journey".localized(using: "Localization")
        self.LoadingLbl.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        // Set Google Map
        let camera = GMSCameraPosition.camera(withLatitude: 18.511811, longitude: 73.851641, zoom: 12.0)
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true
        self.mapView.isHidden = true
        //https://stackoverflow.com/questions/38626649/how-to-show-my-current-location-on-google-maps-when-i-open-the-viewcontroller
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        prepareTotalJourneyUI()
        
        if !self.fromPlaceLatLong.isEmpty &&  !self.toPlaceLatLong.isEmpty {
            let FromPlaceLL = self.fromPlaceLatLong.components(separatedBy: ",")
            let ToPlaceLL = self.toPlaceLatLong.components(separatedBy: ",")
            self.journeyPlannerModel.GetJourneyParts(FromLat: FromPlaceLL.first!, FromLong: FromPlaceLL[1], ToLat: ToPlaceLL.first!, ToLong: ToPlaceLL[1], Place1: FromPlaceLL.last!, PlaceName1: FromPlaceLL.last!, Place2: ToPlaceLL.last!, PlaceName2: ToPlaceLL.last!)
            self.fromPlace = FromPlaceLL.last!
            self.toPlace = ToPlaceLL.last!
        }
        
    }
    func prepareTotalJourneyUI() {
        
        self.TotalTimelbl.font = UIFont(name: "Roboto-Regular", size: 14)
        self.TotalTimelbl.text = "".localized(using: "Localization")
        self.TotalTimelbl.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        self.TotalTimeValuelbl.font = UIFont(name: "Roboto-Medium", size: 16)
        self.TotalTimeValuelbl.text = "".localized(using: "Localization")
        self.TotalTimeValuelbl.textColor = .black
        
        self.TotalDistancelbl.font = UIFont(name: "Roboto-Regular", size: 14)
        self.TotalDistancelbl.text = "".localized(using: "Localization")
        self.TotalDistancelbl.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        self.TotalDistanceValuelbl.font = UIFont(name: "Roboto-Medium", size: 16)
        self.TotalDistanceValuelbl.text = "".localized(using: "Localization")
        self.TotalDistanceValuelbl.textColor = .black
        
    }
    @objc func setSelectionTab(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case activeTab:
            selection = .Instruction
        case pastTab:
            selection = .Map
        default:
            MLog.log(string: "Invalid Selection")
        }
        setSelection()
    }
    func setSelection() {
        switch selection {
        case .Instruction:
            activeTab.backgroundColor = CustomColors.COLOR_ORANGE
            activeTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            activeTabLabel.textColor = .white
            activeTabBottomLine.backgroundColor = CustomColors.COLOR_ORANGE
            pastTab.backgroundColor = .white
            pastTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            pastTabLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            pastTabBottomLine.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
            self.mapView.isHidden = true
            self.JourneyBackView.isHidden = false
            self.TotalDisAndTimeView.isHidden = false
            self.scrollview.isScrollEnabled = true
            self.scrollview.showsVerticalScrollIndicator = true
            
        case .Map:
            activeTab.backgroundColor = .white
            activeTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            activeTabLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            activeTabBottomLine.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
            
            pastTab.backgroundColor = CustomColors.COLOR_ORANGE
            pastTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            pastTabLabel.textColor = .white
            pastTabBottomLine.backgroundColor = CustomColors.COLOR_ORANGE
            self.mapView.isHidden = false
            self.JourneyBackView.isHidden = true
            self.TotalDisAndTimeView.isHidden = true
            self.scrollview.isScrollEnabled = false
            self.scrollview.showsVerticalScrollIndicator = false
            self.mapView.animate(toZoom: 11)
            self.scrollview.setContentOffset(.zero, animated: true)

        }
    
    }
    @objc func tabTapped(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case JourneyTabs.FastestTab:
            JourneyOption = .Fastest
        case JourneyTabs.CheapestTab:
            JourneyOption = .Cheapest
        case JourneyTabs.LeastHopesTab:
            JourneyOption = .LeastHopes
        default:
            MLog.log(string: "Invalid Tab Selection")
        }
        JourneyTabs.setSelection(JourneyOption: JourneyOption)
    }

    func prepareViewModel() {
        
        journeyPlannerModel.didReveiveJourneyParts = {PartsResponse in
            if PartsResponse.body!.numOfParts == 0 {
                self.showError(errStr: PartsResponse.message!)
                return
            }
            NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("GetTotalTimeAndDuration"), object: nil)
            self.setupPartsJourney(ResponseObj: PartsResponse)
            self.journeyPlannerModel.JPResultDataObj = PartsResponse
            self.LoaderView.removeFromSuperview()
        }
        journeyPlannerModel.didReveiveJourneyResponse = {message in
            self.LoadingLbl.text = message.replacingOccurrences(of: "Error:", with: "")
            self.LoaderAct.stopAnimating()
        }
       
    }
  
    func setupPartsJourney(ResponseObj: JourneyPlannerDataObject) {
        
        var YPosition = self.TotalDisAndTimeView.frame.origin.y + self.TotalDisAndTimeView.frame.size.height
        self.JourneyBackView.frame = CGRect(x: 0, y: YPosition, width: self.ContentView.frame.width, height: 200)
        self.TotalNumberOfParts = ResponseObj.body!.numOfParts!
        var JPPartYPosition: CGFloat = 0
        var ToLatLongArr = [""]
        for i in 0..<self.TotalNumberOfParts {
            if i == 0 || i == 2 || i == 4 {
                let JPPart1View = JPPart1()
                JPPart1View.tag = i
                JPPart1View.frame = CGRect(x: 10, y: JPPartYPosition, width: self.ContentView.frame.width-20, height: 250)
                switch i {
                case 0:
                    JPPart1View.initialSetup(FromStation: self.fromPlace, ToStation: (ResponseObj.body!.station1?.name)!, DataObj: ResponseObj, PartView: ResponseObj.body!.part1!)
                    SetupRouteForNonMetroParts(FromStation: self.fromPlace, ToStation: (ResponseObj.body!.station1?.name)!, partoption: ResponseObj.body!.part1!.walk!, AddEndMarker: false, PartNo: i)
                    
                case 2:
                    if self.TotalNumberOfParts == 3 {
                        JPPart1View.initialSetup(FromStation: (ResponseObj.body!.station2?.name)!, ToStation: self.toPlace, DataObj: ResponseObj, PartView: ResponseObj.body!.part3!)
                        SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station2?.name)!, ToStation: self.toPlace, partoption: ResponseObj.body!.part3!.walk!, AddEndMarker: true, PartNo: i)
                        ToLatLongArr = (ResponseObj.body?.part3?.walk!.path!.last!.components(separatedBy: ","))!
                    } else {
                        JPPart1View.initialSetup(FromStation: (ResponseObj.body!.station2?.name)!, ToStation: (ResponseObj.body!.station3?.name)!, DataObj: ResponseObj, PartView: ResponseObj.body!.part3!)
                        SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station2?.name)!, ToStation: (ResponseObj.body!.station3?.name)!, partoption: ResponseObj.body!.part3!.walk!, AddEndMarker: false, PartNo: i)
                    }
                case 4:
                    JPPart1View.initialSetup(FromStation: (ResponseObj.body!.station4?.name)!, ToStation: self.toPlace, DataObj: ResponseObj, PartView: ResponseObj.body!.part5!)
                    SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station4?.name)!, ToStation: self.toPlace, partoption: ResponseObj.body!.part5!.walk!, AddEndMarker: true, PartNo: i)
                    ToLatLongArr = (ResponseObj.body?.part5?.walk!.path!.last!.components(separatedBy: ","))!
                default:
                    break
                }
                JPPartYPosition +=  250
                self.JourneyBackView.addSubview(JPPart1View)
                
            } else {
                // Part2 metro
                let JPPart2View = JPPart2()
                JPPart2View.tag=i
                JPPart2View.frame = CGRect(x: 10, y: JPPartYPosition, width: self.ContentView.frame.width-10, height: 200)
                self.JourneyBackView.addSubview(JPPart2View)
                JPPart2View.initialSetup(DataObj: ResponseObj.body!)
                switch i {
                case 1:
                    SetupRouteForMetroPart(FromStation: (ResponseObj.body!.station1?.name)!, ToStation: (ResponseObj.body!.station2?.name)!, StationFromLatLong: (ResponseObj.body!.station1?.coordinates)!, StationToLatLong: (ResponseObj.body!.station2?.coordinates)!)
                case 3:
                    SetupRouteForMetroPart(FromStation: (ResponseObj.body!.station3?.name)!, ToStation: (ResponseObj.body!.station4?.name)!, StationFromLatLong: (ResponseObj.body!.station3?.coordinates)!, StationToLatLong: (ResponseObj.body!.station4?.coordinates)!)
                default:
                    MLog.log(string: "Invalid Selection")
                }
                JPPartYPosition +=  200
            }
            
        }
        YPosition += JPPartYPosition
        self.JourneyBackView.frame.size.height = YPosition
        self.ContentHeight.constant = CGFloat(YPosition)
        self.scrollview.contentSize.height = YPosition
        
        let FromLatLongArr = ResponseObj.body?.part1?.walk!.path!.first!.components(separatedBy: ",")
        let FromLatitude = Double((FromLatLongArr?.first)!)
        let FromLongitude = Double((FromLatLongArr?.last)!)
        let Fromcoordinates = CLLocationCoordinate2D(latitude: FromLatitude!, longitude: FromLongitude!)
        
        let ToLatitude = Double((ToLatLongArr.first)!)
        let ToLongitude = Double((ToLatLongArr.last)!)
        let Tocoordinates = CLLocationCoordinate2D(latitude: ToLatitude!, longitude: ToLongitude!)
        
        let bounds = GMSCoordinateBounds(coordinate: Fromcoordinates, coordinate: Tocoordinates)
        let camera = mapView.camera(for: bounds, insets: UIEdgeInsets())!
        mapView.camera = camera
       
    }
    
    func SetupRouteForNonMetroParts(FromStation: String, ToStation: String, partoption: OptionDetails, AddEndMarker: Bool, PartNo: Int) {
        
        if (partoption.path!.count) != 0 {
                   
            switch PartNo {
            case 0:
                let FromLatLongArr = partoption.path!.first!.components(separatedBy: ",")
                // Plot Start marker
                let FromLatitude = Double((FromLatLongArr.first)!)
                let FromLongitude = Double((FromLatLongArr.last)!)
                let Frommarker = GMSMarker()
                Frommarker.snippet = ""
                Frommarker.position = CLLocationCoordinate2D(latitude: FromLatitude!, longitude: FromLongitude!)
                Frommarker.title = FromStation
                Frommarker.icon = UIImage(named: "start-map-marker")
                Frommarker.map = mapView
                
                let path = GMSMutablePath()
                for x in 0..<(partoption.path!.count) {
                    let PathFromLatLongArr = partoption.path![x].components(separatedBy: ",")
                    let PathFromLatitude = Double((PathFromLatLongArr.first)!)
                    let PathFromLongitude = Double((PathFromLatLongArr.last)!)
                    let Fromcoordinates = CLLocationCoordinate2D(latitude: PathFromLatitude!, longitude: PathFromLongitude!)
                    path.add(Fromcoordinates)
                
                    if x != 0 {
                        if x != partoption.path!.endIndex - 1 {
                        let marker = GMSMarker()
                        marker.position = Fromcoordinates
                        marker.title = ToStation
                        marker.snippet = ""
                        switch JourneyPart1Option {
                        case .Walk:
                            marker.icon = UIImage(named: "wallk - map-marker")
                        case .Drive:
                            marker.icon = UIImage(named: "car - map-marker")
                        case .Bus:
                            marker.icon = UIImage(named: "bus - map-marker")
                        }
                        marker.map = mapView
                      }
                    }
                }
                let polylinePart1 = GMSPolyline(path: path)
                polylinePart1.strokeWidth = 4.0
                polylinePart1.strokeColor = CustomColors.COLOR_MEDIUM_GRAY
                polylinePart1.geodesic = true
                polylinePart1.map = mapView
                
            case 2:
                if AddEndMarker {
                    let ToLatLongArr = partoption.path!.last!.components(separatedBy: ",")
                    // Plot End marker for 5 part
                    let ToLatitude = Double((ToLatLongArr.first)!)
                    let ToLongitude = Double((ToLatLongArr.last)!)
                    let Tomarker = GMSMarker()
                    Tomarker.position = CLLocationCoordinate2D(latitude: ToLatitude!, longitude: ToLongitude!)
                    Tomarker.title = ToStation
                    Tomarker.snippet = ""
                    Tomarker.icon = UIImage(named: "end-map-marker")
                    Tomarker.map = mapView
                }
                let path = GMSMutablePath()
                for x in 0..<(partoption.path!.count) {
                    let PathFromLatLongArr = partoption.path![x].components(separatedBy: ",")
                    let PathFromLatitude = Double((PathFromLatLongArr.first)!)
                    let PathFromLongitude = Double((PathFromLatLongArr.last)!)
                    let Fromcoordinates = CLLocationCoordinate2D(latitude: PathFromLatitude!, longitude: PathFromLongitude!)
                    path.add(Fromcoordinates)
                    
                    if x != 0 {
                        if x != partoption.path!.endIndex - 1 {
                        let marker = GMSMarker()
                        marker.position = Fromcoordinates
                        marker.title = ToStation
                        marker.snippet = ""
                        switch JourneyPart3Option {
                        case .Walk:
                            marker.icon = UIImage(named: "wallk - map-marker")
                        case .Drive:
                            marker.icon = UIImage(named: "car - map-marker")
                        case .Bus:
                            marker.icon = UIImage(named: "bus - map-marker")
                        }
                        marker.map = mapView
                      }
                        
                    }

                }
                let polylinePart3 = GMSPolyline(path: path)
                polylinePart3.strokeWidth = 4.0
                polylinePart3.strokeColor = CustomColors.COLOR_MEDIUM_GRAY
                polylinePart3.geodesic = true
                polylinePart3.map = mapView
                
            case 4:
                let ToLatLongArr = partoption.path!.last!.components(separatedBy: ",")
                // Plot End marker for 5 part
                let ToLatitude = Double((ToLatLongArr.first)!)
                let ToLongitude = Double((ToLatLongArr.last)!)
                let Tomarker = GMSMarker()
                Tomarker.position = CLLocationCoordinate2D(latitude: ToLatitude!, longitude: ToLongitude!)
                Tomarker.title = ToStation
                Tomarker.snippet = ""
                Tomarker.icon = UIImage(named: "end-map-marker")
                Tomarker.map = mapView
                let path = GMSMutablePath()
                for x in 0..<(partoption.path!.count) {
                    let PathFromLatLongArr = partoption.path![x].components(separatedBy: ",")
                    let PathFromLatitude = Double((PathFromLatLongArr.first)!)
                    let PathFromLongitude = Double((PathFromLatLongArr.last)!)
                    let Fromcoordinates = CLLocationCoordinate2D(latitude: PathFromLatitude!, longitude: PathFromLongitude!)
                    path.add(Fromcoordinates)
                    
                    if x != 0 {
                        if x != partoption.path!.endIndex - 1 {
                        let marker = GMSMarker()
                        marker.position = Fromcoordinates
                        marker.title = ToStation
                        marker.snippet = ""
                        switch JourneyPart5Option {
                        case .Walk:
                            marker.icon = UIImage(named: "wallk - map-marker")
                        case .Drive:
                            marker.icon = UIImage(named: "car - map-marker")
                        case .Bus:
                            marker.icon = UIImage(named: "bus - map-marker")
                        }
                        marker.map = mapView
                      }
                        
                    }
                    
                }
                let polylinePart5 = GMSPolyline(path: path)
                polylinePart5.strokeWidth = 4.0
                polylinePart5.strokeColor = CustomColors.COLOR_MEDIUM_GRAY
                polylinePart5.geodesic = true
                polylinePart5.map = mapView
                
            default:
                break
            }
            
        }
       
    }
    
    func SetupRouteForMetroPart(FromStation: String, ToStation: String, StationFromLatLong: String, StationToLatLong: String) {
        
        let path = GMSMutablePath()
        
        let PathFromLatLongArr = StationFromLatLong.components(separatedBy: ",")
        let PathFromLatitude = Double((PathFromLatLongArr.first)!)
        let PathFromLongitude = Double((PathFromLatLongArr.last)!)
        let Fromcoordinates = CLLocationCoordinate2D(latitude: PathFromLatitude!, longitude: PathFromLongitude!)
        
        let PathToLatLongArr = StationToLatLong.components(separatedBy: ",")
        let PathToLatitude = Double((PathToLatLongArr.first)!)
        let PathToLongitude = Double((PathToLatLongArr.last)!)
        let Tocoordinates = CLLocationCoordinate2D(latitude: PathToLatitude!, longitude: PathToLongitude!)
        
        path.add(Fromcoordinates)
        path.add(Tocoordinates)
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 6.0
        polyline.strokeColor = CustomColors.COLOR_PURPLE_LINE
        polyline.geodesic = true
        polyline.map = mapView
        
        let Frommarker = GMSMarker()
        Frommarker.position = Fromcoordinates
        Frommarker.title = FromStation
        Frommarker.snippet = "Metro Station"
        Frommarker.icon = UIImage(named: "metro station - purple-marker")
        Frommarker.map = mapView
        
        let Tomarker = GMSMarker()
        Tomarker.position = Tocoordinates
        Tomarker.title = ToStation
        Tomarker.snippet = "Metro Station"
        Tomarker.icon = UIImage(named: "metro station - purple-marker")
        Tomarker.map = mapView
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
          // Take Action on Notification
        // NotificationCenter.default.removeObserver(self, name: Notification.Name("GetTotalTimeAndDuration"), object: nil)
        let TotalDuration = notification.userInfo!["TotalDuration"]
        let TotalDistance = notification.userInfo!["TotalDistance"]
        self.TotalTimeValuelbl.text = TotalDuration as? String
        self.TotalDistanceValuelbl.text = TotalDistance as? String
        self.TotalTimelbl.text = "Total Time:".localized(using: "Localization")
        self.TotalDistancelbl.text = "Total Distance:".localized(using: "Localization")
       
        let selectedPart = notification.userInfo!["SelectedPart"] as? Int
        MLog.log(string: selectedPart)
        let SelectedOptionType = notification.userInfo!["SelectedOptionType"] as? Int
        MLog.log(string: SelectedOptionType)
        let ResponseObj = self.journeyPlannerModel.JPResultDataObj!
        var TitleStr = ""
        var DescriptionStr = [""]
        if selectedPart == 0 {
            return
        }
        DescriptionStr.removeAll()
        switch selectedPart {
        case 1:
            TitleStr = "\(self.fromPlace) > \((ResponseObj.body!.station1?.name)!)"
            switch SelectedOptionType {
            case 1:
                // Walk
                MLog.log(string: "Part1 Walk")
                if JourneyPart1Option == .Walk {
                    DescriptionStr = ResponseObj.body!.part1!.walk!.directions!
                }
                JourneyPart1Option = .Walk
            case 2:
                // Drive
                MLog.log(string: "Part1 Drive")
                if JourneyPart1Option == .Drive {
                    DescriptionStr = ResponseObj.body!.part1!.drive!.directions!
                }
                JourneyPart1Option = .Drive
            case 3:
                // Bus
                MLog.log(string: "Part1 Bus")
                if JourneyPart1Option == .Bus {
                    DescriptionStr = ResponseObj.body!.part1!.partPublic!.directions!
                }
                JourneyPart1Option = .Bus
            default:
                MLog.log(string: "Invalid Selection")
            }
        case 3:
            if self.TotalNumberOfParts == 3 {
                TitleStr = "\((ResponseObj.body!.station2?.name)!) > \(self.toPlace)"
                switch SelectedOptionType {
                case 1:
                    // Walk
                    MLog.log(string: "Part3 Walk")
                    if JourneyPart3Option == .Walk {
                        DescriptionStr = ResponseObj.body!.part3!.walk!.directions!
                    }
                    JourneyPart3Option = .Walk
                case 2:
                    // Drive
                    MLog.log(string: "Part3 Drive")
                    if JourneyPart3Option == .Drive {
                        DescriptionStr = ResponseObj.body!.part3!.drive!.directions!
                    }
                    JourneyPart3Option = .Drive
                case 3:
                    // Bus
                    MLog.log(string: "Part3 Bus")
                    if JourneyPart3Option == .Bus {
                        DescriptionStr = ResponseObj.body!.part3!.partPublic!.directions!
                    }
                    JourneyPart3Option = .Bus
                default:
                    MLog.log(string: "Invalid Selection")
                }
            } else {
                TitleStr = "\((ResponseObj.body!.station2?.name)!) > \((ResponseObj.body!.station3?.name)!)"
                switch SelectedOptionType {
                case 1:
                    // Walk
                    MLog.log(string: "Part3 Walk")
                    if JourneyPart3Option == .Walk {
                        DescriptionStr = ResponseObj.body!.part3!.walk!.directions!
                    }
                    JourneyPart3Option = .Walk
                case 2:
                    // Drive
                    MLog.log(string: "Part3 Drive")
                    if JourneyPart3Option == .Drive {
                        DescriptionStr = ResponseObj.body!.part3!.drive!.directions!
                    }
                    JourneyPart3Option = .Drive
                case 3:
                    // Bus
                    MLog.log(string: "Part3 Bus")
                    if JourneyPart3Option == .Bus {
                        DescriptionStr = ResponseObj.body!.part3!.partPublic!.directions!
                    }
                    JourneyPart3Option = .Bus
                default:
                    MLog.log(string: "Invalid Selection")
                }
            }
        case 5:
            TitleStr = "\((ResponseObj.body!.station4?.name)!) > \(self.toPlace)"
            switch SelectedOptionType {
            case 1:
                // Walk
                MLog.log(string: "Part5 Walk")
                if JourneyPart5Option == .Walk {
                    DescriptionStr = ResponseObj.body!.part5!.walk!.directions!
                }
                JourneyPart5Option = .Walk
            case 2:
                // Drive
                MLog.log(string: "Part5 Drive")
                if JourneyPart5Option == .Drive {
                    DescriptionStr = ResponseObj.body!.part5!.drive!.directions!
                }
                JourneyPart5Option = .Drive
            case 3:
                // Bus
                MLog.log(string: "Part5 Bus")
                if JourneyPart5Option == .Bus {
                    DescriptionStr = ResponseObj.body!.part5!.partPublic!.directions!
                }
                JourneyPart5Option = .Bus
            default:
                MLog.log(string: "Invalid Selection")
            }
        default:
            MLog.log(string: "Invalid Selection")
         }
 
         if !DescriptionStr.isEmpty {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "JourneyDescriptionViewController") as! JourneyDescriptionViewController
            journeyResultVC.TitleStr = TitleStr
            journeyResultVC.DescriptionStr = DescriptionStr
            self.present(journeyResultVC, animated: true)
            return
        }
        // Plot new route as per selection
        self.mapView.clear()
        for i in 0..<self.TotalNumberOfParts {
            if i == 0 || i == 2 || i == 4 {
                switch i {
                case 0:
                    switch JourneyPart1Option {
                    case .Walk:
                        SetupRouteForNonMetroParts(FromStation: self.fromPlace, ToStation: (ResponseObj.body!.station1?.name)!, partoption: ResponseObj.body!.part1!.walk!, AddEndMarker: false, PartNo: i)
                    case .Drive:
                        SetupRouteForNonMetroParts(FromStation: self.fromPlace, ToStation: (ResponseObj.body!.station1?.name)!, partoption: ResponseObj.body!.part1!.drive!, AddEndMarker: false, PartNo: i)
                    case .Bus:
                        SetupRouteForNonMetroParts(FromStation: self.fromPlace, ToStation: (ResponseObj.body!.station1?.name)!, partoption: ResponseObj.body!.part1!.partPublic!, AddEndMarker: false, PartNo: i)
                    }
                case 2:
                    if self.TotalNumberOfParts == 3 {
                       
                        switch JourneyPart3Option {
                        case .Walk:
                            SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station2?.name)!, ToStation: self.toPlace, partoption: ResponseObj.body!.part3!.walk!, AddEndMarker: true, PartNo: i)
                        case .Drive:
                            SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station2?.name)!, ToStation: self.toPlace, partoption: ResponseObj.body!.part3!.drive!, AddEndMarker: true, PartNo: i)
                        case .Bus:
                            SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station2?.name)!, ToStation: self.toPlace, partoption: ResponseObj.body!.part3!.partPublic!, AddEndMarker: true, PartNo: i)
                        }
                        
                    } else {
                        
                        switch JourneyPart3Option {
                        case .Walk:
                            SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station2?.name)!, ToStation: (ResponseObj.body!.station3?.name)!, partoption: ResponseObj.body!.part3!.walk!, AddEndMarker: false, PartNo: i)
                        case .Drive:
                            SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station2?.name)!, ToStation: (ResponseObj.body!.station3?.name)!, partoption: ResponseObj.body!.part3!.drive!, AddEndMarker: false, PartNo: i)
                        case .Bus:
                            SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station2?.name)!, ToStation: (ResponseObj.body!.station3?.name)!, partoption: ResponseObj.body!.part3!.partPublic!, AddEndMarker: false, PartNo: i)
                        }
                        
                    }
                case 4:
                    switch JourneyPart3Option {
                    case .Walk:
                        SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station4?.name)!, ToStation: self.toPlace, partoption: ResponseObj.body!.part5!.walk!, AddEndMarker: true, PartNo: i)
                    case .Drive:
                        SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station4?.name)!, ToStation: self.toPlace, partoption: ResponseObj.body!.part5!.drive!, AddEndMarker: true, PartNo: i)
                    case .Bus:
                        SetupRouteForNonMetroParts(FromStation: (ResponseObj.body!.station4?.name)!, ToStation: self.toPlace, partoption: ResponseObj.body!.part5!.partPublic!, AddEndMarker: true, PartNo: i)
                    }
                    
                default:
                    break
                }
                
            } else {
                // Part2 metro
                
                switch i {
                case 1:
                    SetupRouteForMetroPart(FromStation: (ResponseObj.body!.station1?.name)!, ToStation: (ResponseObj.body!.station2?.name)!, StationFromLatLong: (ResponseObj.body!.station1?.coordinates)!, StationToLatLong: (ResponseObj.body!.station2?.coordinates)!)
                case 3:
                    SetupRouteForMetroPart(FromStation: (ResponseObj.body!.station3?.name)!, ToStation: (ResponseObj.body!.station4?.name)!, StationFromLatLong: (ResponseObj.body!.station3?.coordinates)!, StationToLatLong: (ResponseObj.body!.station4?.coordinates)!)
                default:
                    MLog.log(string: "Invalid Selection")
                }
                
            }
            
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("GetTotalTimeAndDuration"), object: nil)
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    func getBearingBetweenTwoPoints(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.latitude)
        let lon1 = degreesToRadians(degrees: point1.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.latitude)
        let lon2 = degreesToRadians(degrees: point2.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
}
enum JourneyTabSelection {
    case Instruction
    case Map
}
enum JourneyOptionsSelection {
    case Fastest
    case Cheapest
    case LeastHopes
}
