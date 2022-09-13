//
//  CCGeneralCorrespondanceViewController.swift
//  PuneMetro
//
//  Created by Admin on 09/07/21.
//

import Foundation
import UIKit

class CCGeneralCorrespondanceViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLogo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuTilesContainer: UIStackView!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var addressTile: MenuTile!
    @IBOutlet weak var phoneTile: MenuTile!
    @IBOutlet weak var emailTile: MenuTile!
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
        metroNavBar.setup(titleStr: "Customer Care".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.text = "General Correspondance".localized(using: "Localization")
        titleLabel.textColor = .black
        
        menuTitle.text = "Pune Metro Rail Project".localized(using: "Localization")
        menuTitle.font = UIFont(name: "Roboto-Medium", size: 18)
        
        addressTile.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        phoneTile.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        phoneTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContactTileTap)))
        emailTile.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
    }
    func prepareViewModel() {
        
    }
    @objc func onContactTileTap(_ sender: UITapGestureRecognizer? = nil) {
            callToNumber(phoneNumber: "02026051074")
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
