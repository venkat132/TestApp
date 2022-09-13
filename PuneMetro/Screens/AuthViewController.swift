//
//  AuthViewController.swift
//  PuneMetro
//
//  Created by Admin on 20/04/21.
//

import Foundation
import UIKit
import KWVerificationCodeView

class AuthViewController: UIViewController, KWVerificationCodeViewDelegate, ViewControllerLifeCycle {

    @IBOutlet weak var metroNavBar: MetroNavBar!
    
    @IBOutlet weak var welcomeBackContainer: UIView!
    @IBOutlet weak var welcomeBackLabel: UILabel!
    @IBOutlet weak var bottomBg: UIView!
    @IBOutlet weak var mPinLabel: UILabel!
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var mPinTextField: KWVerificationCodeView!

    @IBOutlet weak var submitButton: FilledButton!
    @IBOutlet weak var resetButton: UnderlineButton!
    @IBOutlet weak var loader: UIView!

    var idUser: String?
    
    var fromReload: Bool = false

    let viewModel = UserAuthModel()

    // Keyboard Setup
    var originHeight: CGFloat?
//    override func viewWillAppear(_ animated: Bool) {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self)
//    }
    @objc func keyboardDidChangeFrame(_ notification: NSNotification) {
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

    func didChangeVerificationCode() {
        MLog.log(string: "MPin Changed:", mPinTextField.getVerificationCode())
        viewModel.mPin = mPinTextField.getVerificationCode()
    }

    func prepareViewModel() {
        viewModel.didMPinChanged = {(enable) in
            self.submitButton.setEnable(enable: enable)
            if enable {
                self.view.endEditing(true)
                self.submitTap()
            }
        }
        viewModel.goToAuth = {
            self.goToAuth()
        }
        viewModel.goToHome = {
            self.goToHome()
        }
        viewModel.showError = {errMsg in
            self.showError(errStr: errMsg)
            self.mPinTextField.clear()
        }
        viewModel.wrongMpinEntered = {
            self.mPinTextField.resignFirstResponder()
            self.view.endEditing(true)
            if LocalDataManager.dataMgr().wrongMPins < (Globals.WRONG_MPIN_ATTEMPTS - 1) {
                LocalDataManager.dataMgr().wrongMPins += 1
                LocalDataManager.dataMgr().saveToDefaults()
                self.showError(errStr: "Wrong mPIN. Attempts remaining: \(Globals.WRONG_MPIN_ATTEMPTS - LocalDataManager.dataMgr().wrongMPins)")
            } else {
                LocalDataManager.dataMgr().blockMPinTime = Calendar.current.date(byAdding: .minute, value: Globals.BLOCK_MPIN_MINUTES, to: Date())
                LocalDataManager.dataMgr().saveToDefaults()
                self.showError(errStr: "mPIN blocked. Can be entered again in \((LocalDataManager.dataMgr().blockMPinTime!.timeAgoSimple())!)")
            }
        }
        viewModel.goToPin = {idUser, mobile in
            self.goToPin(idUser: idUser, mobileNumber: mobile)
        }
        if fromReload {
            if LocalDataManager.dataMgr().getEnableAppLock() {
                viewModel.authenticateUserTouchID()
            } else {
                self.goToHome()
            }
        }
    }
    func goToAuth() {
        DispatchQueue.main.async {
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
    func prepareUI() {
        self.hideKeyboardWhenTappedAround()
        UIApplication.shared.statusBarUIView!.backgroundColor = CustomColors.TOP_BAR_GRADIENT_TOP
        metroNavBar.setup(titleStr: "Sign In".localized(using: "Localization"), leftImage: nil, leftTap: {}, rightImage: nil, rightTap: {})
        
        welcomeBackLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        welcomeBackLabel.text = "Welcome Back!".localized(using: "Localization")
        
        mPinLabel.font = UIFont(name: "Roboto-Regular", size: 28)
        mPinLabel.text = "Enter mPIN".localized(using: "Localization")
        infoIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAlert)))
        loader.backgroundColor = CustomColors.LOADER_BG
        mPinTextField.delegate = self

        submitButton.setColor(color: CustomColors.COLOR_DARK_BLUE)

        submitButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        submitButton.setAttributedTitle(title: NSAttributedString(string: "SUBMIT".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        submitButton.setEnable(enable: false)
        submitButton.onTap = submitTap

        resetButton.backgroundColor = UIColor.clear
        resetButton.setAlignment(align: .right)
        resetButton.setColor(color: CustomColors.COLOR_DARK_BLUE)
        resetButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 20)
        resetButton.setAttributedTitle(title: NSAttributedString(string: "forgot mPIN?".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: CustomColors.COLOR_DARK_GRAY]))
        resetButton.setEnable(enable: true)
        resetButton.onTap = resetTap
        mPinTextField.underlineColor = CustomColors.COLOR_LIGHT_ORANGE
        mPinTextField.underlineSelectedColor = CustomColors.COLOR_GREEN
        if !fromReload {
            
            mPinTextField.focus()
        }
    }

    func submitTap() {
        MLog.log(string: "Submit Tapped")
        if LocalDataManager.dataMgr().blockMPinTime != nil {
            if (LocalDataManager.dataMgr().blockMPinTime)! > Date() {
                self.showError(errStr: "mPIN blocked. Can be entered again in \((LocalDataManager.dataMgr().blockMPinTime!.timeAgoSimple())!)")
                return
            }
        }
        viewModel.checkOtp()
    }

    func resetTap() {
        MLog.log(string: "Reset Tapped")
        viewModel.requestReset()
    }

    func goToHome() {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController") as! HomeNavigationController
//                homeNavigationController.modalPresentationStyle = .fullScreen
//                self.present(homeNavigationController, animated: true, completion: nil)
                let homeTabBarController = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
                homeTabBarController.modalPresentationStyle = .fullScreen
                self.present(homeTabBarController, animated: true, completion: nil)
            }

    }

    func goToPin(idUser: String, mobileNumber: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let otpViewController = storyboard.instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
            otpViewController.modalPresentationStyle = .fullScreen
            otpViewController.isRegistration = false
            otpViewController.idUser = idUser
            otpViewController.mobileNumber = mobileNumber
            otpViewController.isResetMPin = true
            self.present(otpViewController, animated: true, completion: nil)
        }
    }
    
    @objc func showAlert(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            myAlert.titleStr = "Sign In".localized(using: "Localization")
            myAlert.message = "Enter your 4 digit MPIN to authenticate yourself and access the application.".localized(using: "Localization")
            myAlert.showButton2 = false
            myAlert.showButton1 = true
            myAlert.button1Title = "CLOSE".localized(using: "Localization")
            myAlert.button1OnTap = myAlert.closeTap
            self.present(myAlert, animated: true, completion: nil)
        })
    }
}
