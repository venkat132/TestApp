//
//  StationDetailsViewController.swift
//  PuneMetro
//
//  Created by Admin on 13/05/21.
//

import Foundation
import UIKit

class StationDetailsViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stationImage: UIImageView!
    @IBOutlet weak var stationNameContainer: UIView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationDetailsLabel: UILabel!
    @IBOutlet weak var stationProps: StationProps!
    
    var station: Station = Station()
    
    override func viewWillAppear(_ animated: Bool) {
        if self.navigationController is HomeNavigationController {
            let nav = self.navigationController as! HomeNavigationController
            nav.titleText!.text = station.name
        }
    }
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
        super.viewDidLoad()
    }
    func prepareUI() {
        if let tabBarController = tabBarController {
            scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        metroNavBar.setup(titleStr: "Stations List".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        stationNameLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        stationNameLabel.text = station.name.localized(using: "Localization")
        stationImage.image = UIImage(named: station.imageUrl)
        stationDetailsLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        stationDetailsLabel.text = station.details.localized(using: "Localization")
        stationProps.initWithStation(stn: station)
        stationProps.nearestStnValLabel.text = ""
        stationProps.nearestStnLabel.text = "Available Facilities".localized(using: "Localization")
        stationProps.card.backgroundColor = .clear
        stationProps.topImage.isHidden = true
    }
    func prepareViewModel() {
        
    }
}
