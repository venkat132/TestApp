//
//  HomeNavigationViewController.swift
//  PuneMetro
//
//  Created by Admin on 21/04/21.
//

import Foundation
import UIKit

class HomeNavigationController: UINavigationController, UINavigationControllerDelegate {

    public var imageView: UIImageView?
    public var titleText: UILabel?
    public var backButton: UIButton?
    override func viewDidLoad() {
        self.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadApp), name: UIApplication.willEnterForegroundNotification, object: nil)
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 0.1)!, NSAttributedString.Key.foregroundColor: UIColor.clear]
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
        UIApplication.shared.statusBarUIView!.backgroundColor = CustomColors.TOP_BAR_GRADIENT_TOP
//        navigationBar.layer.cornerRadius = 20
//
//        navigationBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.largeTitleDisplayMode = .always
        navigationBar.addShadow(shadowColor: UIColor.gray.cgColor, shadowOffset: CGSize(width: 1, height: 2), shadowOpacity: 0.5, shadowRadius: 20)
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationBar.tintColor = UIColor.white
        navigationBar.backgroundColor = .clear
        let backgroundLayer = TopBarBG().gl
        backgroundLayer!.frame = navigationBar.frame
        navigationBar.layer.insertSublayer(backgroundLayer!, at: 0)
        navigationBar.clipsToBounds = true
        let image = UIImage(named: "profile-1")
        imageView = UIImageView(image: image)
        MLog.log(string: "Navigation Bar Height: ", self.navigationBar.largeTitleHeight, self.navigationBar.sizeThatFits(CGSize.zero).height)
        let bannerSize = self.navigationBar.frame.size
//        let bannerHeight: CGFloat = 96.5
        let bannerHeight: CGFloat = self.navigationBar.frame.height
        
        let imageSize = CGSize(width: 30, height: 30)
        let bannerX = bannerSize.width - ((bannerHeight - 30)/2) - 30
        imageView!.frame = CGRect(origin: CGPoint(x: bannerX, y: (bannerHeight - 30)/2), size: imageSize)
        imageView!.contentMode = .scaleAspectFit
        self.navigationBar.addSubview(imageView!)
        
        titleText = UILabel(frame: CGRect(origin: CGPoint(x: 75, y: 0), size: CGSize(width: bannerSize.width - 150, height: bannerHeight)))
        titleText!.font = UIFont(name: "Roboto-Medium", size: 23)
        titleText!.backgroundColor = .clear
        titleText!.textAlignment = .center
        titleText!.baselineAdjustment = .alignCenters
        titleText!.numberOfLines = 1
        titleText!.textColor = UIColor.white
        titleText!.text = "Let's Go"
        titleText!.lineBreakMode = .byTruncatingTail
        self.navigationBar.addSubview(titleText!)
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        if isMovingFromParent {
//            NotificationCenter.default.removeObserver(self)
//        }
//    }

    @objc func reloadApp() {
        MLog.log(string: "Reloading App")
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
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is HomeViewController {
            MLog.log(string: "Showing Home")
            if backButton != nil {
                backButton?.removeFromSuperview()
                backButton = nil
            }
            titleText!.text = "Let's Go"
            self.tabBarController?.tabBar.isHidden = true
//            self.tabBarController?.setTabBarVisible(visible: false, duration: 0.3, animated: true)
        } else {
//            self.tabBarController?.setTabBarVisible(visible: true, duration: 0.3, animated: true)
            MLog.log(string: "Showing Back")
            viewController.navigationItem.setHidesBackButton(true, animated: true)
//            let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//            item.tintColor = .white
//            viewController.navigationItem.backBarButtonItem = item
            if backButton == nil {
                backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                backButton!.setImage(UIImage(named: "back"), for: .normal)
                self.navigationBar.addSubview(backButton!)
                backButton!.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    backButton!.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: Const.ImageRightMargin),
                    backButton!.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor, constant: -Const.ImageBottomMarginForLargeState),
                    backButton!.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
                    backButton!.widthAnchor.constraint(equalTo: backButton!.heightAnchor)
                ])
                backButton!.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
            }
        }
    }
    
    @objc func backPressed(_ sender: UIButton) {
        self.popViewController(animated: true)
    }
    
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 10
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 0
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
}
