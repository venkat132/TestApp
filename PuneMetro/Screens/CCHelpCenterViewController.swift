//
//  CCHelpCenterViewController.swift
//  PuneMetro
//
//  Created by Admin on 10/07/21.
//

import Foundation
import UIKit
class CCHelpCenterViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLogo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoContainer: UIStackView!
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var address1Title: UILabel!
    @IBOutlet weak var address1line1: CCItemLine!
    @IBOutlet weak var address1line2: CCItemLine!
    @IBOutlet weak var address2Title: UILabel!
    @IBOutlet weak var address2Line1: CCItemLine!
    @IBOutlet weak var address2Line2: CCItemLine!
    @IBOutlet weak var address3Title: UILabel!
    @IBOutlet weak var address3line1: CCItemLine!
    @IBOutlet weak var address3line2: CCItemLine!
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
        titleLabel.text = "Help Center".localized(using: "Localization")
        titleLabel.textColor = .black
        
        infoTitle.text = "SAHAYOG KENDRA".localized(using: "Localization")
        infoTitle.font = UIFont(name: "Roboto-Medium", size: 18)
        
        address1Title.text = "Pimpri".localized(using: "Localization")
        address1Title.font = UIFont(name: "Roboto-Medium", size: 15)
        address1line1.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address1line2.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        
        address2Title.text = "Vanaz".localized(using: "Localization")
        address2Title.font = UIFont(name: "Roboto-Medium", size: 15)
        address2Line1.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address2Line2.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        
        address3Title.text = "Bund Garden".localized(using: "Localization")
        address3Title.font = UIFont(name: "Roboto-Medium", size: 15)
        address3line1.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address3line2.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
    }
    func prepareViewModel() {
        
    }

}
