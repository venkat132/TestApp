//
//  HomeTabBarController.swift
//  PuneMetro
//
//  Created by Admin on 27/04/21.
//

import Foundation
import UIKit

class HomeTabBarController: UITabBarController, UITabBarControllerDelegate {
    @IBOutlet var menuBarButton: UIBarButtonItem!
    let layerGradient = CAGradientLayer()
    
    var bookAgainTicket: Ticket?
    
    var bookedTicket: Bool = false
    
    var goingToBackgroundTime: Date?
    
    override func viewDidLoad() {
        self.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(goingToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadApp), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        layerGradient.colors = [CustomColors.TOP_BAR_GRADIENT_TOP.cgColor, CustomColors.TOP_BAR_GRADIENT_BOTTOM.cgColor]
        layerGradient.startPoint = CGPoint(x: 0.5, y: 0)
        layerGradient.endPoint = CGPoint(x: 0.5, y: 1)
        layerGradient.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: tabBar.frame.height + 50)
        layerGradient.cornerRadius = 15
        layerGradient.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.layer.addSublayer(layerGradient)
//
//        tabBar.backgroundColor = .clear
//        let backgroundLayer = TopBarBG().gl
//        backgroundLayer!.frame = tabBar.frame
//        tabBar.layer.insertSublayer(backgroundLayer!, at: 1)
//        tabBar.clipsToBounds = true
        
//        tabBar.frame.size.width = self.view.frame.width + 4
//        tabBar.frame.origin.x = -2
        
        tabBar.tintColor = CustomColors.COLOR_ORANGE
        tabBar.unselectedItemTintColor = UIColor.white
        
//        let numberOfItems = CGFloat(tabBar.items!.count)
//        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height + 15)
//        tabBar.selectionIndicatorImage = UIImage.imageWithColor(UIColor(netHex:0xe00628), size: tabBarItemSize).resizableImageWithCapInsets(UIEdgeInsetsZero)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let numberOfItems = CGFloat(self.tabBar.items!.count)
        let tabBarItemSize = CGSize(width: (self.tabBar.frame.width / numberOfItems) - 25, height: self.tabBar.frame.height)
        //        let tabBarItemSize = CGSize(width: 5, height: tabBar.frame.height + 50)
        
        self.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor.white, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)).withRoundedTopCorners(radius: 15)
        if self.selectedViewController is HomeNavigationController {
            let homeVC  = self.selectedViewController as! HomeNavigationController
            if homeVC.visibleViewController is HomeViewController {
                self.tabBar.isHidden = true
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        MLog.log(string: "Showing Booking", viewController is BookingNavigationController)
        
        if self.navigationController is HomeNavigationController {
            let homeNavigationController = self.navigationController as! HomeNavigationController
            if viewController is BookViewController {
                homeNavigationController.titleText?.text = "Book"
            } else if viewController is HomeViewController {
                homeNavigationController.titleText?.text = "Let's Go"
            } else if viewController is TicketsListViewController {
                homeNavigationController.titleText?.text = "My Tickets"
            }
        }
        
        if viewController is HomeNavigationController {
            let navController = viewController as! HomeNavigationController
            if navController.topViewController is HomeViewController {
                MLog.log(string: "Top Home")
            } else {
                MLog.log(string: "Showing Other")
            }
        } else {
            self.tabBar.isHidden = false
        }
        
        if viewController is BookViewController {
//            self.navigationItem.leftBarButtonItems = [self.menuBarButton]
            self.navigationItem.leftBarButtonItems = []
        } else {
            self.navigationItem.leftBarButtonItems = []
        }
        self.navigationItem.rightBarButtonItems = []
    }
    
    @objc func goingToBackground() {
        goingToBackgroundTime = Date()
        MLog.log(string: "Going to backGround", goingToBackgroundTime)
    }
    
    @objc func reloadApp() {
        let sec = Calendar.current.dateComponents([.second], from: goingToBackgroundTime ?? Date(), to: Date()).second ?? 0
        MLog.log(string: "Reloading App: \(sec) sec.")
        if sec >= Globals.REFRESH_TIMEOUT_SEC {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //            let splashViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
                //            splashViewController.modalPresentationStyle = .fullScreen
                //            self.present(splashViewController, animated: true, completion: nil)
                let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
                authViewController.modalPresentationStyle = .fullScreen
                authViewController.fromReload = true
                self.present(authViewController, animated: true, completion: nil)
            }
        }
    }
    func setTabPostion() {
        for vc in self.viewControllers! {
            if vc is HomeNavigationController {
                let homeNav = vc as! HomeNavigationController
                homeNav.popToRootViewController(animated: false)
            }
            if vc is BookingNavigationController {
                let bookNav = vc as! BookingNavigationController
                bookNav.popToRootViewController(animated: false)
            }
        }

    }
    func logout() {
//        LocalDataManager.dataMgr().user = User()
//        LocalDataManager.dataMgr().wrongMPins = 0
//        LocalDataManager.dataMgr().blockMPinTime = nil
//        LocalDataManager.dataMgr().activeTicketsStr = "[]"
//        LocalDataManager.dataMgr().saveToDefaults()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let splashViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
//        splashViewController.modalPresentationStyle = .fullScreen
//        self.present(splashViewController, animated: true, completion: nil)
        for vc in self.viewControllers! {
            if vc is HomeNavigationController {
                let homeNav = vc as! HomeNavigationController
                homeNav.popToRootViewController(animated: false)
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    loginViewController.modalPresentationStyle = .fullScreen
                    loginViewController.isRegistration = true
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
            if vc is BookingNavigationController {
                let bookNav = vc as! BookingNavigationController
                bookNav.popToRootViewController(animated: false)
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    loginViewController.modalPresentationStyle = .fullScreen
                    loginViewController.isRegistration = true
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
        }
        
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            authViewController.modalPresentationStyle = .fullScreen
            authViewController.fromReload = true
            self.present(authViewController, animated: true, completion: nil)
        }
    }
    
    func goToProfile() {
        DispatchQueue.main.async {
            self.selectedIndex = 0
            for vc in self.viewControllers! where vc is HomeNavigationController {
                let homeVC = vc as! HomeNavigationController
                homeVC.popToRootViewController(animated: false)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                profileViewController.modalPresentationStyle = .fullScreen
                homeVC.pushViewController(profileViewController, animated: true)
            }
        }
    }
    
    func showDisclaimer() {
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
