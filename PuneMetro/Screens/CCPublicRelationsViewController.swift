//
//  CCPublicRelationsViewController.swift
//  PuneMetro
//
//  Created by Admin on 10/07/21.
//

import Foundation
import UIKit
class CCPublicRelationsViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLogo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoContainer: UIStackView!
    @IBOutlet weak var address1Title: UILabel!
    @IBOutlet weak var address1line1: CCItemLine!
    @IBOutlet weak var address1line2: CCItemLine!
    @IBOutlet weak var address1line3: CCItemLine!
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
        titleLabel.text = "Public Relation Matters".localized(using: "Localization")
        titleLabel.textColor = .black
        
        address1Title.text = "Shri. Hemant R Sonawane".localized(using: "Localization")
        address1Title.font = UIFont(name: "Roboto-Medium", size: 15)
        address1line1.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address1line2.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address1line3.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        address1line3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContactTileTap)))
    }
    func prepareViewModel() {
        
    }
    @objc func onContactTileTap(_ sender: UITapGestureRecognizer? = nil) {
            callToNumber(phoneNumber: "+912026051072")
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
