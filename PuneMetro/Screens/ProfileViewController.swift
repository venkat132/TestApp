//
//  ProfileViewController.swift
//  PuneMetro
//
//  Created by Admin on 02/06/21.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var notificationTile: MenuTile!
    @IBOutlet weak var settingsTile: MenuTile!
    @IBOutlet weak var accountTile: MenuTile!
    @IBOutlet weak var kycTile: MenuTile!
    @IBOutlet weak var disclaimerTile: MenuTile!
    @IBOutlet weak var signOutTile: MenuTile!
    @IBOutlet weak var deleteTile: MenuTile!
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        titleLabel.text = LocalDataManager.dataMgr().user.name
    }
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
        metroNavBar.setup(titleStr: "Profile".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {
            MLog.log(string: "Back Tapped")
            self.navigationController?.popViewController(animated: true)
        }, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.textColor = .black
        titleLabel.text = LocalDataManager.dataMgr().user.name
        
        notificationTile.isHidden = true
        notificationTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        notificationTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        settingsTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        settingsTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        accountTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        accountTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        //if LocalDataManager.dataMgr().user.verifiedEmail {
            accountTile.imageView.removeBadge()
//        } else {
//            accountTile.imageView.addBadge(value: "1")
//            kycTile.isHidden = true
//        }
        kycTile.isHidden = true
        kycTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        kycTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        disclaimerTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        disclaimerTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        signOutTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        signOutTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        deleteTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        deleteTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
    }
    func prepareViewModel() {
        
    }
    
    @objc func tileTap(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case notificationTile:
            MLog.log(string: "Profile: Notification Tapped")
        case settingsTile:
            MLog.log(string: "Profile: Settings Tapped")
            goToSettings()
        case accountTile:
            MLog.log(string: "Profile: Account Tapped")
            goToAccount()
        case kycTile:
            MLog.log(string: "Profile: KYC Tapped")
            self.goToKyc()
        case disclaimerTile:
            MLog.log(string: "Profile: Disclaimer Tapped")
            self.showDisclaimer()
        case signOutTile:
            MLog.log(string: "Profile: Sign Out Tapped")
            self.logout()
        case deleteTile:
            MLog.log(string: "Profile: Delete Tapped")
        default:
            MLog.log(string: "Profile: Invalid Tap", sender.view)
        }
    }
    
    func logout() {
        let tabVc = self.tabBarController as! HomeTabBarController
        tabVc.logout()
    }
    
    func showDisclaimer() {
        let tabVc = self.tabBarController as! HomeTabBarController
        tabVc.showDisclaimer()
    }
    
    func goToAccount() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let userAccountViewController = storyboard.instantiateViewController(withIdentifier: "UserAccountViewController") as! UserAccountViewController
            userAccountViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.navigationController?.pushViewController(userAccountViewController, animated: true)
        })
    }
    func goToSettings() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let userSettingsViewController = storyboard.instantiateViewController(withIdentifier: "UserSettingsViewController") as! UserSettingsViewController
            userSettingsViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.navigationController?.pushViewController(userSettingsViewController, animated: true)
        })
    }
    func goToKyc() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let kYCViewController = storyboard.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
            kYCViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.navigationController?.pushViewController(kYCViewController, animated: true)
        })
    }
}
