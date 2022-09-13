//
//  OtpViewController.swift
//  PuneMetro
//
//  Created by Admin on 19/04/21.
//

import Foundation
import UIKit
import KWVerificationCodeView

class SetMPinViewController: UIViewController, KWVerificationCodeViewDelegate, ViewControllerLifeCycle {

    @IBOutlet weak var metroNavBar: MetroNavBar!
    
    @IBOutlet weak var bottomBg: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var infoIcon: UIImageView!
    
    @IBOutlet weak var mPinLabel: UILabel!
    @IBOutlet weak var confirmMessageLabel: UILabel!
    @IBOutlet weak var mPinTextField: KWVerificationCodeView!

    @IBOutlet weak var submitButton: FilledButton!
    @IBOutlet weak var loader: UIView!
    
    var idUser: String?

    var originHeight: CGFloat?

    let viewModel = UserSetMPinModel()
    
    var isRegistration: Bool = false

    // Keyboard Setup
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardDidChangeFrame(_ notification: NSNotification) {
        self.copyrightLabel.isHidden = false
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if originHeight == nil {
                originHeight = self.view.frame.height
            } else if self.view.frame.height == originHeight {
                self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height - keyboardSize.height))
            }
            if self.view.firstResponder is UITextField {
                MLog.log(string: "UITextField Focused:", self.view.firstResponder)
//                self.scrollView.scrollToView(view: self.view.firstResponder!, animated: true)
            }
        }
    }
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        self.copyrightLabel.isHidden = true
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            MLog.log(string: "Keyboard appear Original height:", originHeight)
            MLog.log(string: "Keyboard size on Keyboard Appear", keyboardSize)
            if originHeight == nil {
                originHeight = self.view.frame.height
            } else if self.view.frame.height == originHeight {
                self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height - keyboardSize.height))
            }
            MLog.log(string: "Origin on Keyboard Appear", self.view.frame)
            MLog.log(string: "UITextField Focusing:", self.view.firstResponder)
            if self.view.firstResponder is UITextField {
                MLog.log(string: "UITextField Focused:", self.view.firstResponder)
//                self.scrollView.scrollToView(view: self.view.firstResponder!, animated: true)
            }
        }
    }
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        self.copyrightLabel.isHidden = false
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //            hideKeyboardWhenTappedAroundPlayer(remove: true);
            MLog.log(string: "Keyboard Disappear Original height:", originHeight)
            if originHeight == nil {
                self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height + keyboardSize.height))
            } else {
                self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: originHeight!))
            }
            MLog.log(string: "Origin on Keyboard Disappear", self.view.frame)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        prepareViewModel()

    }

    func prepareViewModel() {
        viewModel.dataDidChange = { (success) in
            self.submitButton.setEnable(enable: success)
            if success {
                self.view.endEditing(true)
                self.submitTap()
            } else {
                if self.viewModel.isConf! && (self.viewModel.otpConf ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) > 3 {
                    MLog.log(string: "Conf OTP Length", (self.viewModel.otpConf ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8))
                    self.mPinTextField.clear()
                    self.view.endEditing(true)
                    self.showError(errStr: "mPIN doesn't match.")
                    
                }
            }
        }
        viewModel.setLoading = {(loading) in
            self.loader.isHidden = !loading
        }
        viewModel.confChange = {(isConf) in
            self.infoIcon.isHidden = isConf
            self.confirmMessageLabel.isHidden = !isConf
            if isConf {
                self.progressImage.image = UIImage(named: "registration-4")
                self.mPinLabel.text = "Re-enter mPIN".localized(using: "Localization")
                
            } else {
                self.progressImage.image = UIImage(named: "registration-3")
                self.mPinLabel.text = "Setup mPIN".localized(using: "Localization")
            }
        }
        viewModel.goToHome = {
            self.goToHome()
        }
        viewModel.goToProfile = {
            self.goToProfile()
        }
        viewModel.isConf = false
    }

    func prepareUI() {
        self.hideKeyboardWhenTappedAround()
        UIApplication.shared.statusBarUIView!.backgroundColor = CustomColors.TOP_BAR_GRADIENT_TOP
        metroNavBar.setup(titleStr: isRegistration ? "Register".localized(using: "Localization") : "Sign In".localized(using: "Localization"), leftImage: nil, leftTap: {}, rightImage: nil, rightTap: {})
        
        let currentYear = LocalDataManager.dataMgr().getCurrentYear()
        mPinLabel.font = UIFont(name: "Roboto-Regular", size: 28)
        copyrightLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        copyrightLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        copyrightLabel.text = "© Pune Metro".localized(using: "Localization") + currentYear
        confirmMessageLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        confirmMessageLabel.text = "Confirm previously entered mPIN".localized(using: "Localization")
        loader.backgroundColor = CustomColors.LOADER_BG
        infoIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAlert)))
        mPinTextField.delegate = self

        submitButton.setColor(color: CustomColors.COLOR_DARK_BLUE)

        submitButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        submitButton.setAttributedTitle(title: NSAttributedString(string: "NEXT".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        submitButton.setEnable(enable: false)
        submitButton.onTap = submitTap
        
//        mPinTextField.underlineColor = CustomColors.COLOR_GREEN
//        mPinTextField.underlineSelectedColor = CustomColors.COLOR_LIGHT_ORANGE
        mPinTextField.focus()
    }

    func didChangeVerificationCode() {
        MLog.log(string: "MPin Changed:", mPinTextField.getVerificationCode())
        if viewModel.isConf! {
            viewModel.otpConf = mPinTextField.getVerificationCode()
        } else {
            viewModel.otp = mPinTextField.getVerificationCode()
        }
    }

    func submitTap() {
        MLog.log(string: "Submit Tapped")
        if Globals.PROHIBITED_MPINS.contains(viewModel.otp!) {
            showError(errStr: "This mPIN is not allowed".localized(using: "Localization"))
            return
        }
        if viewModel.isConf! {
            viewModel.updateMPin()
        } else {
            viewModel.isConf = true
            mPinTextField.clear()
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
    
    func goToProfile() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileInputViewController = storyboard.instantiateViewController(withIdentifier: "ProfileInputViewController") as! ProfileInputViewController
            profileInputViewController.modalPresentationStyle = .fullScreen
            profileInputViewController.isRegistration = self.isRegistration
            self.present(profileInputViewController, animated: true, completion: nil)
        }
    }
    
    @objc func showAlert(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            myAlert.titleStr = "Register".localized(using: "Localization")
            myAlert.message = "Set a 4 digit MPIN to secure the usage of this application".localized(using: "Localization")
            myAlert.showButton2 = false
            myAlert.showButton1 = true
            myAlert.button1Title = "CLOSE".localized(using: "Localization")
            myAlert.button1OnTap = myAlert.closeTap
            self.present(myAlert, animated: true, completion: nil)
        })
    }
}
