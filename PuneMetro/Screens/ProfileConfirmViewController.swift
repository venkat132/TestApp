//
//  ProfileConfirmViewController.swift
//  PuneMetro
//
//  Created by Admin on 19/05/21.
//

import Foundation
import UIKit
class ProfileConfirmViewController: UIViewController, ViewControllerLifeCycle {

    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var bottomBg: UIView!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var hyperlinkLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var emailLable: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderValueLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var dobValueLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var mobileValueLabel: UILabel!
    @IBOutlet weak var submitButton: FilledButton!
    @IBOutlet weak var loader: UIView!
    
    var user: User?
    var isRegistration: Bool = false
    var viewModel = UserProfileConfirmModel()
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
        super.viewDidLoad()
    }
    func prepareUI() {
        MLog.log(string: "Selected Language:")
        metroNavBar.setup(titleStr: "Register".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.dismiss(animated: true, completion: {})}, rightImage: nil, rightTap: {})
        
        confirmationLabel.font = UIFont(name: "Roboto-Regular", size: 30)
        confirmationLabel.text = "Confirmation".localized(using: "Localization")
        loader.backgroundColor = CustomColors.LOADER_BG
        
        let currentYear = LocalDataManager.dataMgr().getCurrentYear()
        copyrightLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        copyrightLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        copyrightLabel.text = "© Pune Metro".localized(using: "Localization") + currentYear
        
        hyperlinkLabel.attributedText = NSAttributedString(string: "Disclaimer".localized(using: "Localization"), attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: CustomColors.COLOR_ORANGE, NSAttributedString.Key.foregroundColor: CustomColors.COLOR_ORANGE, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 30)!])
        hyperlinkLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        hyperlinkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDisclaimer)))
        
        nameLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        nameLabel.text = "Name".localized(using: "Localization").appending(":")
        nameLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        emailLable.font = UIFont(name: "Roboto-Regular", size: 13)
        emailLable.text = "Email".localized(using: "Localization").appending(":")
        emailLable.textColor = CustomColors.COLOR_MEDIUM_GRAY
        genderLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        genderLabel.text = "Gender".localized(using: "Localization").appending(":")
        genderLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        dobLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        dobLabel.text = "Date of Birth".localized(using: "Localization").appending(":")
        dobLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        mobileLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        mobileLabel.text = "Mobile".localized(using: "Localization").appending(":")
        mobileLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        nameValueLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        nameValueLabel.text = user?.name
        emailValueLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        emailValueLabel.text = user?.email
        genderValueLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        genderValueLabel.text = user?.gender?.rawValue.capitalized
        dobValueLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        dobValueLabel.text = DateUtils.returnString(user!.dob)
        mobileValueLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        mobileValueLabel.text = user?.mobile
        
        submitButton.setColor(color: CustomColors.COLOR_DARK_BLUE)
        submitButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        submitButton.setAttributedTitle(title: NSAttributedString(string: "SUBMIT".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        submitButton.onTap = submitTap
        submitButton.setEnable(enable: true)
    }
    func prepareViewModel() {
        viewModel.goToHome = {
            self.goToHome()
        }
        
        viewModel.showError = { err in
            self.showError(errStr: err)
        }
    }
    
    func submitTap() {
        MLog.log(string: "Submit Tapped")
        viewModel.updateProfile(user: self.user!)
    }
    
    func goToHome() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController") as! HomeNavigationController
            //            homeNavigationController.modalPresentationStyle = .fullScreen
            //            self.present(homeNavigationController, animated: true, completion: nil)
            
            let homeTabBarController = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
            homeTabBarController.modalPresentationStyle = .fullScreen
            self.present(homeTabBarController, animated: true, completion: nil)
        }
    }
    
    @objc func showDisclaimer(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            myAlert.titleStr = "Disclaimer".localized(using: "Localization")
            myAlert.message = "disclaimer-message".localized(using: "Localization")
            myAlert.showButton2 = false
            myAlert.showButton1 = true
            myAlert.button1Title = "CLOSE".localized(using: "Localization")
            myAlert.button1OnTap = myAlert.closeTap
            self.present(myAlert, animated: true, completion: nil)
        })
    }
}
