//
//  CCOurOfficesViewController.swift
//  PuneMetro
//
//  Created by Admin on 10/07/21.
//

import Foundation
import UIKit
class CCOurOfficesViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLogo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoContainer: UIStackView!
    @IBOutlet weak var address1Title: UILabel!
    @IBOutlet weak var address1line1: CCItemLine!
    @IBOutlet weak var address1line2: CCItemLine!
    @IBOutlet weak var address2Title: UILabel!
    @IBOutlet weak var address2Line1: CCItemLine!
    @IBOutlet weak var address2Line2: CCItemLine!
    @IBOutlet weak var address3Title: UILabel!
    @IBOutlet weak var address3line1: CCItemLine!
    @IBOutlet weak var address4Line1: CCItemLine!
    @IBOutlet weak var address3Line2: CCItemLine!
    @IBOutlet weak var address4Title: UILabel!
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
        titleLabel.text = "Our Offices".localized(using: "Localization")
        titleLabel.textColor = .black
        
        address1Title.text = "1. Koregaon Park Office".localized(using: "Localization")
        address1Title.font = UIFont(name: "Roboto-Medium", size: 15)
        address1line1.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address1line2.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address2Title.text = "2. Office of Director (Works)\nDirector (Stategic Planning)\nDirector (Operations & Maintainance)".localized(using: "Localization")
        address2Title.font = UIFont(name: "Roboto-Medium", size: 15)
        address2Line1.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address2Line2.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        
        address3Title.text = "3. Office Of Executive Director (Reach -1 & Reach - 2)\nExecutive Director (Signal) GM (Safety, O&M) CPM (Telecom) ACPM (AFC)".localized(using: "Localization")
        address3Title.font = UIFont(name: "Roboto-Medium", size: 15)
        address3line1.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address3Line2.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address4Title.text = "4. Office of Executive Director (system) CPM (Rolling Stock) GM ( planning & Design)".localized(using: "Localization")
        address4Title.font = UIFont(name: "Roboto-Medium", size: 15)
        address4Line1.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address1line2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContactTileTap)))
        address1line2.tag = 101
        address2Line2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContactTileTap)))
        address2Line2.tag = 102
        address3Line2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContactTileTap)))
        address3Line2.tag = 103
        address4Line1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContactTileTap)))
        address4Line1.tag = 104
    }
    func prepareViewModel() {
        
    }
    @objc func onContactTileTap(_ sender: UITapGestureRecognizer? = nil) {
        switch (sender?.view?.tag)  {
        case 101:
            callToNumber(phoneNumber: "18002705501")
        case 102:
            callToNumber(phoneNumber: "18002705501")
        case 103:
            callToNumber(phoneNumber: "18002705501")
        case 104:
            callToNumber(phoneNumber: "02029702497")
        default :
            break
        }
    }
    private func callToNumber(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        } else {
            MLog.log(string: "Cannot Call:", phoneNumber)
        }
    }
}
