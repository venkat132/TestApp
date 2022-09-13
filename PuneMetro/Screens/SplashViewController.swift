//
//  SplashViewController.swift
//  PuneMetro
//
//  Created by Admin on 20/04/21.
//

import Foundation
import UIKit
import Localize_Swift

class SplashViewController: UIViewController, ViewControllerLifeCycle {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var splashImageView: UIImageView!
    let viewModel = SplashModel()
    @IBOutlet weak var splashTopImage: UIImageView!
    @IBOutlet weak var splashBottomImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MLog.log(string: "Localizer", Localize.availableLanguages())
        Localize.setCurrentLanguage(LocalDataManager.dataMgr().userLanguage.localeVal())
        MLog.log(string: "Localizer", Localize.currentLanguage())
        MLog.log(string: "Localizer", "NEXT".localized(using: "Localization"))
        prepareUI()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Globals.SPLASH_DELAY, execute: {
            self.prepareViewModel()
        })
        
    }

    override func viewDidAppear(_ animated: Bool) {
//        viewModel.validateToken()
    }

    func prepareViewModel() {
        viewModel.setLoading = {(loading) in
            MLog.log(string: "Set Loading:", loading)
        }
        viewModel.deviceDidChecked = { usedBefore in
            MLog.log(string: "Device Checked", usedBefore)
            if usedBefore {
                self.viewModel.validateToken(deviceId: UIDevice.current.identifierForVendor!.uuidString)
            } else {
                self.goToLogin(isRegistration: true)
            }
        }
        viewModel.goToAuth = {
          ///  self.goToAuth()
            self.goToPin()
        }
        viewModel.goToProfile = {
            self.goToProfileInput()
        }
        viewModel.validateBiometric = {
            self.validateBiometric()
        }
        viewModel.goToLogin = {
            self.goToLogin(isRegistration: false)
        }
        viewModel.goToSetMPin = {
           // self.goToSetMPin()
           // self.goToPin()
            self.goToHome()
        }
        viewModel.goToHome = {
            self.goToHome()
        }
        viewModel.onHaltTrue = { msg in
            self.showAlert(msg: msg)
        }
        viewModel.checkDevice(deviceId: UIDevice.current.identifierForVendor!.uuidString)
        
        viewModel.shownetworktimeout = {
            // Call Screen with retry
            MLog.log(string: "Network error")
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
//            journeyResultVC.modalPresentationStyle = .fullScreen
//            journeyResultVC.isNetworkError = true
//            self.present(journeyResultVC, animated: true)
        }
    }

    func prepareUI() {
        
        do {
            let gif = try UIImage(gifName: "splash-transparent.gif")
            self.splashImageView.setGifImage(gif, loopCount: 1)
        } catch let e {
            MLog.log(string: "Splash Error 1:", e.localizedDescription)
        }
        self.splashBottomImage.setImage(UIImage(named: "splash-bottom-new")!)
//        do {
//            let gif2 = try UIImage(gifName: "splash-bottom.gif")
//            self.splashBottomImage.setGifImage(gif2, loopCount: -1)
//        } catch let e {
//            MLog.log(string: "Splash Error 2:", e.localizedDescription)
//        }
        
        var branch = ""
        
        if UrlsManager.API.contains("24002") {
            branch = Globals.BRANCH_DEV
        } else if UrlsManager.API.contains("24003") {
            branch = Globals.BRANCH_RELEASE
        } else if UrlsManager.API.contains("24001") {
            branch = Globals.BRANCH_MASTER
        } else {
            branch = "\(Globals.BRANCH_FEATURE) \(UrlsManager.API)"
        }
        
        // hiding branch text
        branch = ""
        
        versionLabel.textColor = CustomColors.COLOR_DARK_GRAY
        versionLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        versionLabel.text = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String) \(branch)"
        
//        let str1 = "Auth-Scheme \(UrlsManager.API_KEY)"
//        MLog.log(string: "str:", str1)
    }

    func validateBiometric() {
        viewModel.authenticateUserTouchID()
    }
    func goToPin() {
        DispatchQueue.main.async {
            if LocalDataManager.sharedInstance?.getUserMobileNumber() ==  "" {
                self.goToLogin(isRegistration: false)
            } else {
                var idUser = ""
                let defaults: UserDefaults = UserDefaults.standard
                do {
                    idUser = try (StorageUtils.decryptData(data: defaults.data(forKey: metroUserIDKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "0")
                }
                catch let error {
                    MLog.log(string: "Defaults Parsing", error.localizedDescription)
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let otpViewController = storyboard.instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                otpViewController.modalPresentationStyle = .fullScreen
                otpViewController.isRegistration = false
                otpViewController.idUser = idUser
                otpViewController.mobileNumber = LocalDataManager.sharedInstance?.getUserMobileNumber()
                otpViewController.isResetMPin = false
                otpViewController.timestampOtpResendEnable = 1661762249
                self.present(otpViewController, animated: true, completion: nil)
            }
        }
    }
    func goToAuth() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true, completion: nil)
        }
    }

    func goToSetMPin() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let setMPinViewController = storyboard.instantiateViewController(withIdentifier: "SetMPinViewController") as! SetMPinViewController
            setMPinViewController.modalPresentationStyle = .fullScreen
            setMPinViewController.isRegistration = false
            self.present(setMPinViewController, animated: true, completion: nil)
        }
    }
    
    func goToProfileInput() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileInputViewController = storyboard.instantiateViewController(withIdentifier: "ProfileInputViewController") as! ProfileInputViewController
            profileInputViewController.modalPresentationStyle = .fullScreen
            profileInputViewController.isRegistration = false
            self.present(profileInputViewController, animated: true, completion: nil)
        }
    }

    func goToLogin(isRegistration: Bool) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            loginViewController.modalPresentationStyle = .fullScreen
            loginViewController.isRegistration = isRegistration
            self.present(loginViewController, animated: true, completion: nil)
        }
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
    
    func showAlert(msg: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok".localized(using: "Localization"), style: UIAlertAction.Style.default, handler: {_ in
                if let serviceUrl = URL(string: "https://apps.apple.com/in/app/pune-metro-official-app/id1571012648") {
                    let application: UIApplication = UIApplication.shared
                    if (application.canOpenURL(serviceUrl)) {
                        application.open(serviceUrl, options: [:], completionHandler: nil)
                    }
                } else {
                    MLog.log(string: "Cannot Open:", "https://apps.apple.com/in/app/pune-metro-official-app/id1571012648")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        })
    }
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
//            myAlert.message = msg
//            myAlert.showButton1 = true
//            myAlert.button1Title = "Ok".localized(using: "Localization")
//            myAlert.button1Action = {
//                    if let serviceUrl = URL(string: "https://apps.apple.com/in/app/pune-metro-official-app/id1571012648") {
//                        let application:UIApplication = UIApplication.shared
//                        if (application.canOpenURL(serviceUrl)) {
//                            application.open(serviceUrl, options: [:], completionHandler: nil)
//                        }
//                    } else {
//                        MLog.log(string: "Cannot Open:", "https://apps.apple.com/in/app/pune-metro-official-app/id1571012648")
//                    }
////                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
////                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (_) in
////                    exit(0)
////                }
//            }
//            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//            self.present(myAlert, animated: true, completion: nil)
//        })

}
