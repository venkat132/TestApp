//
//  LoginViewController.swift
//  PuneMetro
//
//  Created by Admin on 16/04/21.
//

import Foundation
import UIKit
import SimpleCheckbox
import ActiveLabel

class LoginViewController: UIViewController, ViewControllerLifeCycle {

    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var bottomBg: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var welcomeBackContainer: UIView!
    @IBOutlet weak var welcomeBackLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var infoIcon: UIImageView!
    
    @IBOutlet weak var checkBoxTnC: Checkbox!
    @IBOutlet weak var labelTnC: ActiveLabel!

    @IBOutlet weak var checkboxInfo: Checkbox!
    @IBOutlet weak var labelInfo: UILabel!

    @IBOutlet weak var checkBoxContainer: UIView!
    @IBOutlet weak var submitButton: FilledButton!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBOutlet weak var isdInput: UITextField!
    @IBOutlet weak var mobileInput: UITextField!
    @IBOutlet weak var loader: UIView!
    
    var isRegistration: Bool = false

    let viewModel = UserLoginViewModel()

    var mobileNumber = ""
    
    var errRefreshTimer: Timer?

    var originHeight: CGFloat?

    // Keyboard Setup
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        if errRefreshTimer != nil {
            errRefreshTimer!.invalidate()
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
            if self.view.firstResponder is UITextField {
                MLog.log(string: "UITextField Focused:", self.view.firstResponder)
                self.scrollView.scrollToView(view: self.view.firstResponder!, animated: true)
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
                self.scrollView.scrollToView(view: self.view.firstResponder!, animated: true)
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
            self.layoutSubviews()
            MLog.log(string: "Origin on Keyboard Disappear", self.view.frame)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        prepareViewModel()
//        MLog.log(string: "Localizer:", LocalizeUtils.defaultLocalizer.stringForKey(key: "NEXT"), LocalizeUtils.defaultLocalizer.appbundle, "NEXT".localized(lang: "mr"))
    }

    func prepareViewModel() {
        viewModel.deviceDidChecked = { usedBefore in
            self.isRegistration = !usedBefore
        }
        viewModel.dataDidChange = {(isTermsAccepted, isInfoAccepted, mobileError) in
            self.submitButton.setEnable(enable: (isTermsAccepted && isInfoAccepted && mobileError))
            if mobileError {
                self.view.endEditing(true)
            }
            self.checkBoxTnC.isChecked = isTermsAccepted
            self.checkboxInfo.isChecked = isInfoAccepted
        }

        viewModel.setLoading = {(loading) in
            self.loader.isHidden = !loading
        }

        viewModel.goToPin = {(idUser, timestamp) in
            self.goToOTP(idUser: idUser, timestampOtpResendEnable: timestamp)
        }

        viewModel.showError = { msg in
            self.showError(errStr: msg)
        }
//        viewModel.checkDevice(deviceId: UIDevice.current.identifierForVendor!.uuidString)
        viewModel.mobileNumber = mobileNumber
        viewModel.isInfoAccepted = (mobileNumber != "" || !isRegistration)
        viewModel.isTermsAccepted = (mobileNumber != "" || !isRegistration)
        
        viewModel.showErrorNoTimeout = {timestamp in
            self.showErrorNoTimeout(timestamp: timestamp)
        }
        
        viewModel.shownetworktimeout = {
            // Call Screen with retry
            MLog.log(string: "Network error")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
            journeyResultVC.modalPresentationStyle = .fullScreen
            journeyResultVC.isNetworkError = true
            self.present(journeyResultVC, animated: true)
        }
    }

    func prepareUI() {
        self.hideKeyboardWhenTappedAround()
        UIApplication.shared.statusBarUIView!.backgroundColor = CustomColors.TOP_BAR_GRADIENT_TOP
        metroNavBar.setup(titleStr: isRegistration ? "Register".localized(using: "Localization") : "Sign In".localized(using: "Localization"), leftImage: nil, leftTap: {}, rightImage: nil, rightTap: {})
        
        progressImage.isHidden = !isRegistration
        welcomeBackContainer.isHidden = isRegistration
        welcomeBackLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        welcomeBackLabel.text = "Welcome Back!".localized(using: "Localization")
        
        loginLabel.font = UIFont(name: "Roboto-Regular", size: 28)
        loginLabel.text = "Enter phone number".localized(using: "Localization")
        
        loader.backgroundColor = CustomColors.LOADER_BG
        
        infoIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAlert)))
        mobileInput.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mobileInput.attributedPlaceholder = NSAttributedString(string: "10 Digit Mobile Number".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: CustomColors.COLOR_MEDIUM_GRAY, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 18)!])
        mobileInput.text = mobileNumber
        mobileInput.font = UIFont(name: "Roboto-Medium", size: 18)
        isdInput.font = UIFont(name: "Roboto-Medium", size: 20)
        
        prepareCheckboxes()
        
        submitButton.setColor(color: CustomColors.COLOR_DARK_BLUE)

        submitButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        submitButton.setAttributedTitle(title: NSAttributedString(string: "NEXT".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        submitButton.setEnable(enable: false)

        submitButton.onTap = submitTap
        submitButton.setEnable(enable: false)
        
        mobileInput.layer.cornerRadius = 5
        mobileInput.layer.borderWidth = 0.5
        mobileInput.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        
        isdInput.layer.cornerRadius = 5
        isdInput.layer.borderWidth = 0.5
        isdInput.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        isdInput.isUserInteractionEnabled = false
        
        let currentYear = LocalDataManager.dataMgr().getCurrentYear()
        copyrightLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        copyrightLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        copyrightLabel.text = "© Pune Metro".localized(using: "Localization") + currentYear
        mobileInput.becomeFirstResponder()
    }
    
    func prepareCheckboxes() {
        if isRegistration {
            checkBoxContainer.isHidden = false
            checkBoxTnC.layer.cornerRadius = 3
            checkBoxTnC.checkmarkStyle = .tick
            checkBoxTnC.checkboxFillColor = UIColor.clear
            checkBoxTnC.checkmarkColor = CustomColors.COLOR_ORANGE
            checkBoxTnC.checkedBorderColor = CustomColors.COLOR_ORANGE
            checkBoxTnC.uncheckedBorderColor = UIColor.gray
            checkBoxTnC.isUserInteractionEnabled = true
            checkBoxTnC.addTarget(self, action: #selector(checkToggle), for: .valueChanged)
            checkBoxContainer.isUserInteractionEnabled = true
//            let screenSize: CGRect = checkBoxTnC.bounds
//            let myView = UIView(frame: CGRect(x: checkBoxTnC.frame.origin.x, y: checkBoxTnC.frame.origin.y, width: screenSize.width, height: screenSize.height))
//            myView.backgroundColor = .red
//            myView.isUserInteractionEnabled = true
//            myView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsTap)))
//            checkBoxContainer.addSubview(myView)
            
            let customType = ActiveType.custom(pattern: "By providing your mobile number you have accepted our".localized(using: "Localization"))
            let customTypeLink = ActiveType.custom(pattern: "\\s\("Terms and Conditions".localized(using: "Localization"))")
            labelTnC.enabledTypes = [customTypeLink, customType]
            
            labelTnC.font = UIFont(name: "Roboto-Regular", size: 12)
            labelTnC.textColor = .black
            labelTnC.customColor[customType] = UIColor.gray
            labelTnC.customColor[customTypeLink] = CustomColors.COLOR_ORANGE
            labelTnC.customSelectedColor[customTypeLink] = CustomColors.COLOR_ORANGE
            labelTnC.configureLinkAttribute = { (type, attributes, _) in
                var retDic = attributes
                switch type {
                case customTypeLink:
                    retDic[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.thick.rawValue
                case customType:
                    retDic[NSAttributedString.Key.underlineStyle] = nil
                default: break
                }
                return retDic
            }
            labelTnC.text = "\("By providing your mobile number you have accepted our".localized(using: "Localization")) \("Terms and Conditions".localized(using: "Localization"))"
            labelTnC.handleCustomTap(for: customTypeLink, handler: { _ in
                self.view.endEditing(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    myAlert.titleStr = "Terms".localized(using: "Localization")
                    myAlert.message = "terms-message".localized(using: "Localization")
                    myAlert.showButton2 = false
                    myAlert.showButton1 = true
                    myAlert.button1Title = "CLOSE".localized(using: "Localization")
                    myAlert.button1OnTap = myAlert.closeTap
                    self.present(myAlert, animated: true, completion: nil)
                })
            })
            labelTnC.handleCustomTap(for: customType, handler: {_ in
                 self.termsTap(UITapGestureRecognizer())
            })
            
            labelInfo.font = UIFont(name: "Roboto-Regular", size: 12)
            labelInfo.text = "Pune Metro may keep you informed via personalised emails and sms about products and services".localized(using: "Localization")
            checkboxInfo.layer.cornerRadius = 3
            checkboxInfo.checkmarkStyle = .tick
            checkboxInfo.checkboxFillColor = UIColor.clear
            checkboxInfo.checkmarkColor = CustomColors.COLOR_ORANGE
            checkboxInfo.checkedBorderColor = CustomColors.COLOR_ORANGE
            checkboxInfo.uncheckedBorderColor = UIColor.gray
            checkboxInfo.addTarget(self, action: #selector(checkToggle), for: .valueChanged)
            labelInfo.textColor = UIColor.gray
            labelInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(infoTap)))
            
        } else {
            checkBoxContainer.isHidden = true
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == mobileInput {
            viewModel.mobileNumber = textField.text!.replacingOccurrences(of: " ", with: "")
            self.removeError()
            if errRefreshTimer != nil {
                errRefreshTimer!.invalidate()
                errRefreshTimer = nil
            }
        }
    }

    @objc func termsTap(_ sender: UITapGestureRecognizer) {
        checkBoxTnC.isChecked = !checkBoxTnC.isChecked
        checkToggle(sender: checkBoxTnC)
    }

    @objc func infoTap(_ sender: UITapGestureRecognizer) {
        checkboxInfo.isChecked = !checkboxInfo.isChecked
        checkToggle(sender: checkboxInfo)
    }

    @objc func checkToggle(sender: Checkbox) {
        if sender == checkBoxTnC {
            self.viewModel.isTermsAccepted = sender.isChecked
        } else if sender == checkboxInfo {
            self.viewModel.isInfoAccepted = sender.isChecked
        }
    }

    func submitTap() {
        MLog.log(string: "Submit Tapped")
        viewModel.initiateLogin(mobileInput: mobileInput.text!)
//        goToOTP(idUser: "0", timestampOtpResendEnable: 0.0)
    }

    func goToOTP(idUser: String, timestampOtpResendEnable: Double) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let otpViewController = storyboard.instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
        otpViewController.isRegistration = isRegistration
        otpViewController.idUser = idUser
        otpViewController.timestampOtpResendEnable = timestampOtpResendEnable
        otpViewController.mobileNumber = mobileInput.text
        otpViewController.modalPresentationStyle = .fullScreen
        self.present(otpViewController, animated: true, completion: nil)
    }
    
    @objc func showAlert(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            myAlert.titleStr = "Register".localized(using: "Localization")
            myAlert.message = "Please enter your mobile number of this device. You will receive a verification SMS on the device before we register the same to allow you to book tickets and provide other functionality via the mobile app.".localized(using: "Localization")
            myAlert.showButton2 = false
            myAlert.showButton1 = true
            myAlert.button1Title = "CLOSE".localized(using: "Localization")
            myAlert.button1OnTap = myAlert.closeTap
            self.present(myAlert, animated: true, completion: nil)
        })
    }
    
    func showErrorNoTimeout(timestamp: Double) {
        if errRefreshTimer != nil {
            errRefreshTimer?.invalidate()
            errRefreshTimer = nil
        }
        
        errRefreshTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {_ in
            if Date(timeIntervalSince1970: timestamp) > Date() {
                self.showErrorNoTimeout(errStr: "Because of multiple incorrect OTP entries, yout account weill remain blocked for [TIME] as a security measure.".localized(using: "Localization").replacingOccurrences(of: "[TIME]", with: Date(timeIntervalSince1970: timestamp).timeAgoSimple()!))
            } else {
                self.removeError()
                self.errRefreshTimer?.invalidate()
                self.errRefreshTimer = nil
            }
        })
    }

}
