//
//  CCQuickResponseTeamViewController.swift
//  PuneMetro
//
//  Created by Admin on 09/07/21.
//

import Foundation
import UIKit
class CCQuickResponseTeamViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLogo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoContainer: UIStackView!
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var controlRoomTitle: UILabel!
    @IBOutlet weak var tollFreeLabel: UILabel!
    @IBOutlet weak var tollFreeDotsLabel: UILabel!
    @IBOutlet weak var tollFreeValueLabel: UILabel!
    @IBOutlet weak var bsnlLabel: UILabel!
    @IBOutlet weak var bsnlDotsLabel: UILabel!
    @IBOutlet weak var bsnlValueLabel: UILabel!
    @IBOutlet weak var address1Title: UILabel!
    @IBOutlet weak var address1line1: CCItemLine!
    @IBOutlet weak var address1line2: CCItemLine!
    @IBOutlet weak var address1line3: CCItemLine!
    @IBOutlet weak var address2Title: UILabel!
    @IBOutlet weak var address2Line1: CCItemLine!
    @IBOutlet weak var address2Line2: CCItemLine!
    @IBOutlet weak var address2line3: CCItemLine!
    @IBOutlet weak var address3Title: UILabel!
    @IBOutlet weak var address3line1: CCItemLine!
    @IBOutlet weak var address3line2: CCItemLine!
    @IBOutlet weak var address3line3: CCItemLine!
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    
    func prepareUI() {
        if let tabBarController = tabBarController {
            scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        metroNavBar.setup(titleStr: "Customer Care".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.text = "Quick Response Team".localized(using: "Localization")
        titleLabel.textColor = .black
        
        infoTitle.font = UIFont(name: "Roboto-Medium", size: 18)
        infoTitle.text = "EMERGENCY/ACCIDENT/HELP".localized(using: "Localization")
        
        controlRoomTitle.font = UIFont(name: "Roboto-Medium", size: 15)
        controlRoomTitle.text = "Control Room".localized(using: "Localization")
        
        tollFreeLabel.text = "Toll Free No".localized(using: "Localization")
        tollFreeLabel.font = UIFont(name: "Roboto-Regular", size: 15)!
        tollFreeDotsLabel.font = UIFont(name: "Roboto-Regular", size: 15)!
        tollFreeValueLabel.font = UIFont(name: "Roboto-Regular", size: 15)!
        
        bsnlLabel.text = "BSNL No".localized(using: "Localization")
        bsnlLabel.font = UIFont(name: "Roboto-Regular", size: 15)!
        bsnlDotsLabel.font = UIFont(name: "Roboto-Regular", size: 15)!
        bsnlValueLabel.font = UIFont(name: "Roboto-Regular", size: 15)!
        
        address1Title.text = "Shri. Kishore Karande".localized(using: "Localization")
        address1Title.font = UIFont(name: "Roboto-Medium", size: 15)
        address1line1.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address1line2.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address1line3.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        
        address2Title.text = "Shri. Vitthal Chavan".localized(using: "Localization")
        address2Title.font = UIFont(name: "Roboto-Medium", size: 15)
        address2Line1.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address2Line2.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address2line3.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        
        address3Title.text = "Shri. Sharad Jambale".localized(using: "Localization")
        address3Title.font = UIFont(name: "Roboto-Medium", size: 15)
        address3line1.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address3line2.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address3line3.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
    }
    func prepareViewModel() {
   
    }
}
