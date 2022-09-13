//
//  HelpViewController.swift
//  PuneMetro
//
//  Created by Admin on 02/06/21.
//

import Foundation
import UIKit

class HelpViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var helpTitleContainer: UIView!
    @IBOutlet weak var helpTitleLabel: UILabel!
    @IBOutlet weak var helpTileStack: UIStackView!
    
    @IBOutlet weak var faqTile: MenuTile!
    @IBOutlet weak var lostTile: MenuTile!
    @IBOutlet weak var grievancesTile: MenuTile!
    @IBOutlet weak var feedbackTile: MenuTile!
    @IBOutlet weak var contactTile: MenuTile!
    @IBOutlet weak var aboutTile: MenuTile!
    @IBOutlet weak var termsTile: MenuTile!
    @IBOutlet weak var privacyTile: MenuTile!
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    
    func prepareUI() {
        metroNavBar.setup(titleStr: "Help".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        helpTitleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        helpTitleLabel.textColor = .black
        helpTitleLabel.text = "How can we help you?".localized(using: "Localization")
        
        faqTile.isHidden = true
        faqTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        faqTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHelpTileTap)))
        lostTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        lostTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHelpTileTap)))
        grievancesTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        grievancesTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHelpTileTap)))
        feedbackTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        feedbackTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHelpTileTap)))
        contactTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        contactTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHelpTileTap)))
        aboutTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        aboutTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHelpTileTap)))
        termsTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        termsTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHelpTileTap)))
        privacyTile.setup(font: UIFont(name: "Roboto-Regular", size: 14)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        privacyTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHelpTileTap)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func prepareViewModel() {
        
    }
    
    @objc func onHelpTileTap(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case faqTile: MLog.log(string: "FAQ Tapped")
            showAlert(titleStr: "FAQ".localized(using: "Localization"), message: "Feature coming soon...")
        case lostTile: MLog.log(string: "Lost & Found Tapped")
//            showAlert(titleStr: "Lost & Found".localized(using: "Localization"), message: "Feature coming soon...")
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let LostAndFoundVC = storyboard.instantiateViewController(withIdentifier: "LostAndFoundViewController") as! LostAndFoundViewController
                LostAndFoundVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(LostAndFoundVC, animated: true)
            }
        case grievancesTile: MLog.log(string: "Grievances Tapped")
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let LostAndFoundVC = storyboard.instantiateViewController(withIdentifier: "GrievancesViewController") as! GrievancesViewController
                LostAndFoundVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(LostAndFoundVC, animated: true)
            }
        case feedbackTile: MLog.log(string: "Feedback Tapped")
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let LostAndFoundVC = storyboard.instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
                LostAndFoundVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(LostAndFoundVC, animated: true)
            }
        case contactTile: MLog.log(string: "Contact Us Tapped")
            callNumber(phoneNumber: Globals.CC_PHONE)
        case aboutTile: MLog.log(string: "About Us Tapped")
            showAlert(titleStr: "About Us".localized(using: "Localization"), message: "Pune, the cultural and historical capital of the state of Maharashtra, known as the ‘Queen of Deccan’ due to its scenic beauty and rich natural resources.\nThe birth place of holy saint Tukaram, Capital of the greatest warrior king of all time Chhatrapati Shivaji Maharaj who established 'Hindavi Swarajya', Social reformers Mahatma Jyotiba Phule, Savitribai Phule, Maharshi Karve, home of great freedom fighters like Bal Gangadhar Tilak, Agarkar and Gopal Krishna Gokhale.\nPune city is known in the world map because of its educational, research and development institutions, IT Parks and automobiles industry in western Maharashtra.\nIn last decades, the city witnessed a rise in population and people migrating from a different part of the country for job opportunities. However, the sustainable infrastructure to facilitate easy commute to the citizens was missing. Average travel time for citizens using public transport in Pune is over ~100 mins a day. This makes more and more citizens use their personal vehicle, which causes traffic chaos and congestion issues.\nThus there is a need for a safe, reliable, efficient, affordable, commuter friendly and environmentally sustainable rapid public transport system for the Pune Metro Region.")
        case termsTile: MLog.log(string: "Terms Tapped")
            showAlert(titleStr: "Terms of services".localized(using: "Localization"), message: "terms-message".localized(using: "Localization"))
        case privacyTile: MLog.log(string: "Privacy Tapped")
            showAlert(titleStr: "Privacy Policy".localized(using: "Localization"), message: "privacy-message".localized(using: "Localization"))
        default: MLog.log(string: "Invalid Help Tile")
        }
    }
    
    func showAlert(titleStr: String, message: String? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            myAlert.titleStr = titleStr
            if message != nil {
                myAlert.message = message!
            }
            myAlert.showButton2 = false
            myAlert.showButton1 = true
            myAlert.button1Title = "CLOSE".localized(using: "Localization")
            myAlert.button1OnTap = myAlert.closeTap
            self.present(myAlert, animated: true, completion: nil)
        })
    }
    
    private func callNumber(phoneNumber: String) {
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
