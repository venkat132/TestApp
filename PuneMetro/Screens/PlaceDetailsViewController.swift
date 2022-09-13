//
//  PlaceDetailsViewController.swift
//  PuneMetro
//
//  Created by Admin on 12/05/21.
//

import Foundation
import UIKit
class PlaceDetailsViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var stationProps: StationProps!
    @IBOutlet weak var nearestContainer: UIView!
    @IBOutlet weak var nearestLabel: UILabel!
    @IBOutlet weak var nearestValueLabel: UILabel!
    @IBOutlet weak var logoCompact: UIImageView!
    @IBOutlet weak var PlaceNameLabel: UILabel!
    
    var place: TourPlace?
    override func viewWillAppear(_ animated: Bool) {
        if self.navigationController is HomeNavigationController {
            let nav = self.navigationController as! HomeNavigationController
            nav.titleText!.text = place?.title.localized(using: "Localization")
        }
    }
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
        super.viewDidLoad()
    }
    func prepareUI() {
        // For adjusting bottom space if large text available
        if let tabBarController = tabBarController {
            scrollview.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        metroNavBar.setup(titleStr: "Explore Pune".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        topImage.image = UIImage(named: place!.imageUrl)
        let backgroundLayer = ImageOverlay().gl
        backgroundLayer!.frame = view.frame
        topImage.layer.insertSublayer(backgroundLayer!, at: 0)
        topImage.clipsToBounds = true
        
        detailsLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        detailsLabel.text = place?.details.localized(using: "Localization")
//        stationProps.initWithStation(stn: place!.nearStn)
//        stationProps.card.layer.borderWidth = 1
//        stationProps.card.layer.borderColor = CustomColors.COLOR_LIGHT_GREEN.cgColor
        
        nearestLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        nearestLabel.text = "Nearest Station".localized(using: "Localization")
        nearestValueLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        nearestValueLabel.text = place!.nearStn.name.localized(using: "Localization")
        PlaceNameLabel.font = UIFont(name: "Roboto-Medium", size: 20)
        PlaceNameLabel.text = place?.title.localized(using: "Localization")
        
//        if let font = UIFont(name: "Roboto-Regular", size: 14) {
//            let fontAttributes = [NSAttributedString.Key.font: font]
//            let myText = String(format: "%@ %@",nearestLabel.text!,nearestLabel.text!)
//            let size = (myText as NSString).size(withAttributes: fontAttributes)
//            MLog.log(string: "size:", size.width)
//            let totalWidth = size.width + 100
//            nearestContainer.frame = CGRect(x: totalWidth/2, y: nearestContainer.frame.origin.y, width: totalWidth, height: nearestContainer.frame.height)
//        }
        
    }
    func prepareViewModel() {
        
    }
}
