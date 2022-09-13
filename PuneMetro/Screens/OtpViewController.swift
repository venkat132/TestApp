//
//  OtpViewController.swift
//  PuneMetro
//
//  Created by Admin on 19/04/21.
//

import Foundation
import UIKit
import KWVerificationCodeView

class OtpViewController: UIViewController, KWVerificationCodeViewDelegate, ViewControllerLifeCycle {

//    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var bottomBg: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var welcomeBackContainer: UIView!
    @IBOutlet weak var welcomeBackLabel: UILabel!
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var smsLabel: UILabel!

    @IBOutlet weak var copyrightLabel: UILabel!
    //    @IBOutlet weak var otpField: OTPTextField!
    @IBOutlet weak var otpTextField: KWVerificationCodeView!

    @IBOutlet weak var submitButton: FilledButton!
    @IBOutlet weak var resendButton: UnderlineButton!
    @IBOutlet weak var changeMobileButton: UnderlineButton!
    @IBOutlet weak var loader: UIView!
    
    var isRegistration: Bool = false
    
    var isResetMPin: Bool = false

    var idUser: String?

    var mobileNumber: String?

    var timestampOtpResendEnable: Double?

    var resendTimer: Timer?

    var originHeight: CGFloat?

    let viewModel = UserEnterOTPModel()
    
    var errRefreshTimer: Timer?

    // Keyboard handling
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.resendTimer?.invalidate()
        if errRefreshTimer != nil {
            self.errRefreshTimer?.invalidate()
        }
    }
    @objc func keyboardDidChangeFrame(_ notification: NSNotification) {
        self.copyrightLabel.isHidden = false
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if originHeight == nil {
                originHeight = self.view.frame.height
            } else if self.view.frame.height == originHeight {
                self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height - keyboardSize.height))
            }
//            if self.view.firstResponder is UITextField {
//                MLog.log(string: "UITextField Focused:", self.view.firstResponder)
//                self.scrollView.scrollToView(view: self.view.firstResponder!, animated: true)
//            }
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
//            if self.view.firstResponder is UITextField {
//                MLog.log(string: "UITextField Focused:", self.view.firstResponder)
//                self.scrollView.scrollToView(view: self.view.firstResponder!, animated: true)
//            }
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
            self.layoutSubviews()
            MLog.log(string: "Origin on Keyboard Disappear", self.view.frame)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        prepareViewModel()

    }

    func prepareViewModel() {
        viewModel.dataDidChange = {(success) in
            self.submitButton.setEnable(enable: success)
            if success {
                self.view.endEditing(true)
                self.submitTap()
            }
        }

        viewModel.setLoading = {(loading) in
            self.loader.isHidden = !loading
        }
        viewModel.showError = { msg in
            self.otpTextField.clear()
            self.otpTextField.resignFirstResponder()
            self.view.endEditing(true)
            self.showError(errStr: msg)
        }
        viewModel.goToMPin = {
            // self.goToMPin()
            if LocalDataManager.dataMgr().user.profileUpdated {
                self.goToHome()
            } else {
                self.goToProfile()
            }
           
        }
        viewModel.goToHome = {
            self.goToHome()
           // self.goToProfile()
        }
        viewModel.goToProfile = {
            self.goToProfile()
        }
        viewModel.enableResend = { timestamp in
            self.timestampOtpResendEnable = timestamp
            self.resendTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {timer in
                MLog.log(string: NSDate().timeIntervalSince1970, " -1:- ", self.timestampOtpResendEnable!)
                MLog.log(string: Date(timeIntervalSince1970: self.timestampOtpResendEnable!).timeAgoSimple())
                if NSDate().timeIntervalSince1970 >= self.timestampOtpResendEnable! {
                    self.resendButton.setAttributedTitle(title: NSAttributedString(string: "Resend OTP", attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: CustomColors.COLOR_DARK_GRAY]))
                    self.resendButton.setEnable(enable: true)
                    timer.invalidate()
                } else {
                    self.resendButton.setAttributedTitle(title: NSAttributedString(string: "Resend OTP in " + Date(timeIntervalSince1970: self.timestampOtpResendEnable!).timeAgoSimple()!, attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: CustomColors.COLOR_DARK_GRAY]))
                    self.resendButton.setEnable(enable: false)
                }
            })
        }
        viewModel.showErrorNoTimeout = {timestamp in
            self.showErrorNoTimeout(timestamp: timestamp)
        }
    }

    func prepareUI() {
        self.hideKeyboardWhenTappedAround()
        metroNavBar.setup(titleStr: isRegistration ? "Register".localized(using: "Localization") : "Sign In".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: changeTap, rightImage: nil, rightTap: {})
        
        progressImage.isHidden = !isRegistration
        welcomeBackContainer.isHidden = isRegistration
        welcomeBackLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        welcomeBackLabel.text = "Welcome Back!".localized(using: "Localization")
        
        let currentYear = LocalDataManager.dataMgr().getCurrentYear()
        copyrightLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        copyrightLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        copyrightLabel.text = "© Pune Metro".localized(using: "Localization") + currentYear
        
        otpLabel.font = UIFont(name: "Roboto-Regular", size: 28)
        
        if isResetMPin {
            otpLabel.text = "Enter OTP to reset mPin".localized(using: "Localization")
        } else {
            otpLabel.text = "Verify phone number".localized(using: "Localization")
        }

        smsLabel.font = UIFont(name: "Roboto-Regular", size: 20)
        
        smsLabel.text = "Enter OTP shared on mobile XXXXXX0000".localized(using: "Localization").replacingOccurrences(of: "0000", with: mobileNumber!.suffix(4))

        loader.backgroundColor = CustomColors.LOADER_BG
        otpTextField.delegate = self
        submitButton.setColor(color: CustomColors.COLOR_DARK_BLUE)

        submitButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        submitButton.setAttributedTitle(title: NSAttributedString(string: "NEXT".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        submitButton.setEnable(enable: false)
        submitButton.onTap = submitTap
        
        prepareButtons()
        
//        otpTextField.underlineColor = CustomColors.COLOR_GREEN
//        otpTextField.underlineSelectedColor = CustomColors.COLOR_LIGHT_ORANGE
        otpTextField.focus()
    }
    
    func prepareButtons() {
        changeMobileButton.isHidden = true
        if isResetMPin {
            self.resendButton.isHidden = true
        } else {
            resendButton.setColor(color: CustomColors.COLOR_DARK_BLUE)
            resendButton.titleLabel.font = UIFont(name: "Roboto-Regular", size: 20)
            resendButton.setAttributedTitle(title: NSAttributedString(string: "Resend OTP".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15)!, NSAttributedString.Key.foregroundColor: CustomColors.COLOR_DARK_GRAY]))
            resendButton.onTap = resendTap
            resendButton.setEnable(enable: false)
            resendButton.setAlignment(align: .right)
            
            changeMobileButton.setColor(color: CustomColors.COLOR_DARK_BLUE)
            changeMobileButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 20)
            changeMobileButton.setAttributedTitle(title: NSAttributedString(string: "Change Mobile Number".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: CustomColors.COLOR_DARK_GRAY]))
            changeMobileButton.onTap = changeTap
            changeMobileButton.setEnable(enable: true)
            
            changeMobileButton.setAlignment(align: .center)
            
            resendTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                MLog.log(string: NSDate().timeIntervalSince1970, " -:- ", self.timestampOtpResendEnable!)
                MLog.log(string: Date(timeIntervalSince1970: self.timestampOtpResendEnable!).timeAgoSimple())
                if NSDate().timeIntervalSince1970 >= self.timestampOtpResendEnable! {
                    self.resendButton.setAttributedTitle(title: NSAttributedString(string: "Resend OTP".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: CustomColors.COLOR_DARK_GRAY]))
                    self.resendButton.setEnable(enable: true)
                    timer.invalidate()
                } else {
                    self.resendButton.setAttributedTitle(title: NSAttributedString(string: "Resend OTP in [TIME]".localized(using: "Localization").replacingOccurrences(of: "[TIME]", with: Date(timeIntervalSince1970: self.timestampOtpResendEnable!).timeAgoSimple()!), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: CustomColors.COLOR_DARK_GRAY]))
                    self.resendButton.setEnable(enable: false)
                }
            })
        }
    }

    func didChangeVerificationCode() {
        MLog.log(string: "OTP CHanged:", otpTextField.getVerificationCode())
        viewModel.otp = otpTextField.getVerificationCode()
        self.removeError()
        if errRefreshTimer != nil {
            errRefreshTimer!.invalidate()
            errRefreshTimer = nil
        }
    }
    func submitTap() {
        MLog.log(string: "Submit Tapped")
        if isResetMPin {
            viewModel.resetMPinValidateOTP()
        } else {
            let deviceId = UIDevice.current.identifierForVendor!.uuidString
            MLog.log(string: "Device ID")
            viewModel.validateLogin(idUser: idUser!, deviceId: deviceId)
        }
    }

    func resendTap() {
        MLog.log(string: "Resend Tapped")
        self.otpTextField.clear()
        viewModel.resendOtp(idUser: idUser!)
        self.resendButton.setEnable(enable: false)
    }

    func changeTap() {
        MLog.log(string: "Change Mobile Tapped")
        goToLogin()
    }

    func goToMPin() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mPinViewController = storyboard.instantiateViewController(withIdentifier: "SetMPinViewController") as! SetMPinViewController
            mPinViewController.modalPresentationStyle = .fullScreen
            mPinViewController.isRegistration = self.isRegistration
            self.present(mPinViewController, animated: true, completion: nil)
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

    func goToLogin() {
        DispatchQueue.main.async {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            loginViewController.modalPresentationStyle = .fullScreen
//            loginViewController.mobileNumber = self.mobileNumber!
//            loginViewController.isRegistration = self.isRegistration
//            self.present(loginViewController, animated: true, completion: nil)
            self.dismiss(animated: true, completion: {})
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
    
    func showErrorNoTimeout(timestamp: Double) {
        if errRefreshTimer != nil {
            errRefreshTimer?.invalidate()
            errRefreshTimer = nil
        }
        
        errRefreshTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in
            if Date(timeIntervalSince1970: timestamp) > Date() {
                self.showErrorNoTimeout(errStr: "Because of multiple incorrect OTP entries, yout account weill remain blocked for [TIME] as a security measure.".localized(using: "Localization").replacingOccurrences(of: "[TIME]", with: Date(timeIntervalSince1970: timestamp).timeAgoSimple()!))
                if self.resendTimer != nil {
                    self.resendTimer?.invalidate()
                    self.resendTimer = nil
                    self.resendButton.setAttributedTitle(title: NSAttributedString(string: "Resend OTP".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15)!, NSAttributedString.Key.foregroundColor: CustomColors.COLOR_DARK_GRAY]))
                    self.resendButton.setEnable(enable: false)
                }
            } else {
                self.removeError()
                self.errRefreshTimer?.invalidate()
                self.errRefreshTimer = nil
            }
        })
    }
}
