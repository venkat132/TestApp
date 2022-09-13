//
//  UserSettingsViewController.swift
//  PuneMetro
//
//  Created by Admin on 10/07/21.
//

import Foundation
import UIKit
class UserSettingsViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationSwitchContainer: UIView!
    @IBOutlet weak var locationSwitchLabel: UILabel!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var promotionSwitchContainer: UIView!
    @IBOutlet weak var promotionSwitchLabel: UILabel!
    @IBOutlet weak var promotionSwitch: UISwitch!
    @IBOutlet weak var appLockSwitchContainer: UIView!
    @IBOutlet weak var appLockSwitchLabel: UILabel!
    @IBOutlet weak var appLockSwitch: UISwitch!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageStackShadow: UIView!
    @IBOutlet weak var languageStack: UIStackView!
    @IBOutlet weak var marathiView: UIView!
    @IBOutlet weak var marathiLabel: UILabel!
    @IBOutlet weak var hindiView: UIView!
    @IBOutlet weak var hindiLabel: UILabel!
    @IBOutlet weak var englishView: UIView!
    @IBOutlet weak var englishLabel: UILabel!
    var selectedLanguage: Language?
    var viewModel = UserAccountModel()
    var campaignOpted: String!
    var enableAppLock: String!
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
        metroNavBar.setup(titleStr: "Settings".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.textColor = .black
        titleLabel.text = LocalDataManager.dataMgr().user.name
        locationSwitchLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        locationSwitchLabel.text = "Access Location".localized(using: "Localization")
        locationSwitchLabel.textColor = CustomColors.COLOR_DARK_GRAY
        locationSwitch.onTintColor = CustomColors.COLOR_ORANGE
        locationSwitch.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        locationSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        promotionSwitchLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        appLockSwitchLabel.text = "Enable promotional messages".localized(using: "Localization")
        promotionSwitchLabel.textColor = CustomColors.COLOR_DARK_GRAY
        promotionSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        promotionSwitch.onTintColor = CustomColors.COLOR_ORANGE
        promotionSwitch.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        promotionSwitch.addTarget(self, action: #selector(appLockSwitchStateChanged(_:)), for: .valueChanged)
        appLockSwitchLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        promotionSwitchLabel.text = "Enable App Lock".localized(using: "Localization")
        appLockSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        appLockSwitchLabel.textColor = CustomColors.COLOR_DARK_GRAY
        appLockSwitch.onTintColor = CustomColors.COLOR_ORANGE
        appLockSwitch.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        appLockSwitch.addTarget(self, action: #selector(promotionSwitchStateChanged(_:)), for: .valueChanged)
        enableAppLock = LocalDataManager.dataMgr().geEnableAppLock()
        campaignOpted = LocalDataManager.dataMgr().geCampaignOpted()
        styleSelectionBoxes()
        selectedLanguage = LocalDataManager.dataMgr().userLanguage
        setLanguageSelection(reload: false)
       
    }
    @objc func appLockSwitchStateChanged(_ mjSwitch: UISwitch) {
        enableAppLock = mjSwitch.isOn == true ? "1" : "0"
        setOptingCampaigns()
       }
    @objc func promotionSwitchStateChanged(_ mjSwitch: UISwitch) {
        campaignOpted = mjSwitch.isOn == true ? "1" : "0"
        setOptingCampaigns()
       }
    @IBAction func locationSwitchChanged(_ sender: MJMaterialSwitch) {
        MLog.log(string: "Location Switch Changed:", sender.isOn)
    }
    @IBAction func appLockSwitchChanged(_ sender: MJMaterialSwitch) {
        
    }
    
    @IBAction func prootionSwitchChanged(_ sender: MJMaterialSwitch) {
        
    }
    private func setOptingCampaigns() {
        viewModel.optingCampaigns(campaignOpted: campaignOpted, enableAppLock: enableAppLock)
    }
    func styleSelectionBoxes() {
        languageLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        languageLabel.text = "Select Language".localized(using: "Localization")
        languageStack.layer.cornerRadius = 10
        languageStack.layer.borderWidth = 0.5
        languageStack.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        marathiLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        hindiLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        hindiView.layer.borderWidth = 0.5
        hindiView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        englishLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        
        marathiView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLanguageSelect)))
        hindiView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLanguageSelect)))
        englishView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLanguageSelect)))
    }
    func prepareViewModel() {
        viewModel.didReceiveProfile = {
            let enableAppLock = self.viewModel.promotionResp?["enableAppLock"] ?? ""
            let campaignOpted = self.viewModel.promotionResp?["campaignOpted"] ?? ""
            self.promotionSwitch.setOn(enableAppLock == "1" ? true : false, animated: false)
            self.appLockSwitch.setOn(campaignOpted == "1" ? true : false, animated: false)
            self.enableAppLock = enableAppLock
            self.campaignOpted = campaignOpted
        }
        viewModel.goBack = {
           // self.goBack()
        }
        viewModel.didReceiveOptingCampaigns = {
          //  self.goBack()
        }
        viewModel.getProfile()
    }
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onLanguageSelect(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case marathiView:
            selectedLanguage = .marathi
        case hindiView:
            selectedLanguage = .hindi
        case englishView:
            selectedLanguage = .english
        default:
            MLog.log(string: "Invalid Selection")
        }
        LocalDataManager.dataMgr().userLanguage = selectedLanguage!
        LocalDataManager.dataMgr().saveToDefaults()
        setLanguageSelection(reload: true)
    }
    
    func setLanguageSelection(reload: Bool) {
        if selectedLanguage == nil {
            return
        }
        switch selectedLanguage! {
        case .marathi:
            marathiView.backgroundColor = CustomColors.COLOR_ORANGE
            marathiLabel.textColor = .white
            hindiView.backgroundColor = .white
            hindiLabel.textColor = CustomColors.COLOR_DARK_GRAY
            englishView.backgroundColor = .white
            englishLabel.textColor = CustomColors.COLOR_DARK_GRAY
        case .hindi:
            marathiView.backgroundColor = .white
            marathiLabel.textColor = CustomColors.COLOR_DARK_GRAY
            hindiView.backgroundColor = CustomColors.COLOR_ORANGE
            hindiLabel.textColor = .white
            englishView.backgroundColor = .white
            englishLabel.textColor = CustomColors.COLOR_DARK_GRAY
        case .english:
            marathiView.backgroundColor = .white
            marathiLabel.textColor = CustomColors.COLOR_DARK_GRAY
            hindiView.backgroundColor = .white
            hindiLabel.textColor = CustomColors.COLOR_DARK_GRAY
            englishView.backgroundColor = CustomColors.COLOR_ORANGE
            englishLabel.textColor = .white
        }
        if reload {
            reloadApp()
        }
    }
    
    func reloadApp() {
        MLog.log(string: "Reloading App")
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let splashViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
            splashViewController.modalPresentationStyle = .fullScreen
            self.present(splashViewController, animated: true, completion: nil)
        }
    }
    
}
