//
//  SmartCardOTPViewController.swift
//  PuneMetro
//
//  Created by Admin on 29/07/21.
//

import Foundation
import UIKit
import KWVerificationCodeView
class SmartCardOTPViewController: UIViewController, ViewControllerLifeCycle, KWVerificationCodeViewDelegate {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var textLabelBold: UILabel!
    @IBOutlet weak var textLabelThin1: UILabel!
    @IBOutlet weak var textLabelThin2: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var amountLable: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var otpTextField: KWVerificationCodeView!
    @IBOutlet weak var submitButton: FilledButton!
    @IBOutlet weak var backButton: UnderlineButton!
    
    var viewModel = SmartCardOTPModel()
    var isPayment = false
    var isTopUp = false
    var txnId = ""
    var idTicket = ""
    var amount = 0.0
    // Keyboard handling
    var originHeight: CGFloat?
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardDidChangeFrame(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if originHeight == nil {
                originHeight = self.view.frame.height
            } else if self.view.frame.height == originHeight {
                self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height - keyboardSize.height))
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
        }
    }
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
        if let tabBarController = tabBarController {
            scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        metroNavBar.setup(titleStr: "Smart Card".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.textColor = .black
        progressImage.isHidden = !isPayment
        titleContainer.isHidden = isPayment
        
        otpTextField.delegate = self
        // backButton.isHidden = true
        backButton.setColor(color: CustomColors.COLOR_DARK_BLUE)
        backButton.titleLabel.font = UIFont(name: "Roboto-Regular", size: 20)
        backButton.setAttributedTitle(title: NSAttributedString(string: "Resend OTP".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15)!, NSAttributedString.Key.foregroundColor: CustomColors.COLOR_DARK_GRAY]))
        backButton.onTap = resendTap
        backButton.setEnable(enable: false)
        backButton.setAlignment(align: .right)
        
        submitButton.setColor(color: CustomColors.COLOR_DARK_BLUE)
        
        submitButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        if !isPayment && !isTopUp {
            submitButton.setAttributedTitle(title: NSAttributedString(string: "VERIFY".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        } else {
            submitButton.setAttributedTitle(title: NSAttributedString(string: "SUBMIT".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        }
        submitButton.setEnable(enable: false)
        submitButton.onTap = submitTap
        
        textLabelBold.font = UIFont(name: "Roboto-Medium", size: 18)
        textLabelBold.isHidden = isPayment
        balanceLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        balanceLabel.text = "Available Balance".localized(using: "Localization")
        balanceLabel.isHidden = !isPayment
        balanceValueLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        balanceValueLabel.isHidden = !isPayment
        amountValueLabel.isHidden = !isPayment
        amountValueLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        amountLable.isHidden = !isPayment
        amountLable.font = UIFont(name: "Roboto-Medium", size: 18)
        amountLable.text = "Payable Amount".localized(using: "Localization")
        textLabelThin1.text = "OTP has been sent on the registered mobile number.".localized(using: "Localization")
        textLabelThin2.text = "Please enter it below to proceed further".localized(using: "Localization")
        textLabelThin1.font = UIFont(name: "Roboto-Regular", size: 15)
        textLabelThin2.font = UIFont(name: "Roboto-Regular", size: 15)
        if isPayment {
            cardImage.image = UIImage(named: "card-linked")!
            let nf = NumberFormatter()
            nf.minimumFractionDigits = 2
            nf.maximumFractionDigits = 2
            self.amountValueLabel.textColor = .black
            self.amountValueLabel.text = "₹ \(nf.string(from: NSNumber(value: amount))!)"
        } else if isTopUp {
            titleLabel.text = "Top Up".localized(using: "Localization")
            cardImage.image = UIImage(named: "card-linked")!
            textLabelBold.text = "Topup request initiated for card registered to mobile number XXXXXX0000".localized(using: "Localization").replacingOccurrences(of: "0000", with: LocalDataManager.dataMgr().user.mobile.suffix(4))
        } else {
            titleLabel.text = "Link One Pune Card".localized(using: "Localization")
            textLabelBold.text = "Card found against registered mobile number XXXXXX0000".localized(using: "Localization").replacingOccurrences(of: "0000", with: LocalDataManager.dataMgr().user.mobile.suffix(4))
        }
        
        otpTextField.underlineColor = CustomColors.COLOR_LIGHT_GRAY
        otpTextField.underlineSelectedColor = CustomColors.COLOR_GREEN
        otpTextField.focus()
    }
    func prepareViewModel() {
        viewModel.dataDidChange = {(success) in
            self.submitButton.setEnable(enable: success)
            if success {
                self.view.endEditing(true)
            }
        }
        viewModel.showError = { msg in
            self.otpTextField.clear()
            self.otpTextField.resignFirstResponder()
            self.view.endEditing(true)
            // self.showError(errStr: msg)
            var MsgStr = "Your card could not be linked for the following reason".localized(using: "Localization")
            MsgStr += "\n\n"
            MsgStr += msg
            MsgStr += "\n\n"
            MsgStr += "Please contact customer care".localized(using: "Localization")
            let alert = UIAlertController(title: "", message: MsgStr, preferredStyle: UIAlertController.Style.alert)
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 28), NSAttributedString.Key.foregroundColor: UIColor.red]
            let titleString = NSAttributedString(string: "Smart Card Error\n", attributes: titleAttributes as [NSAttributedString.Key: Any])
            alert.setValue(titleString, forKey: "attributedTitle")
            alert.addAction(UIAlertAction(title: "Home", style: UIAlertAction.Style.default, handler: {_ in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Call", style: UIAlertAction.Style.default, handler: {_ in
                guard let number = URL(string: "tel://18002705501") else { return }
                UIApplication.shared.open(number)
                self.navigationController?.popToRootViewController(animated: true)
            }))
//            alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]), forKey: "attributedTitle")
            // alert.view.tintColor = UIColor.red
            self.present(alert, animated: true, completion: nil)
            
        }
        viewModel.didBalanceReceived = { balance in
            self.balanceLabel.isHidden = false
            self.balanceValueLabel.isHidden = false
            let nf = NumberFormatter()
            nf.minimumFractionDigits = 2
            nf.maximumFractionDigits = 2
            self.balanceValueLabel.textColor = (balance > 0) ? .black : CustomColors.COLOR_LIGHT_GRAY
            self.balanceValueLabel.text = "₹ \(nf.string(from: NSNumber(value: balance))!)"
        }
        viewModel.didDebitProccessed = {
            self.viewModel.issueAndUpdate(txnId: self.txnId, idTicket: self.idTicket)
        }
        viewModel.goBack = {
            if self.isPayment {
                self.goToTicketDetails()
            } else {
                self.goBack()
            }
        }
        if isPayment {
            viewModel.getCardBalance()
        }
    }
    func resendTap() {
        MLog.log(string: "Resend Tapped")
        self.otpTextField.clear()
//        viewModel.resendOtp(idUser: idUser!)
//        self.resendButton.setEnable(enable: false)
    }
    
    func didChangeVerificationCode() {
        MLog.log(string: "OTP Changed:", otpTextField.getVerificationCode())
        viewModel.otp = otpTextField.getVerificationCode()
    }
    
    func submitTap() {
        if isPayment {
            viewModel.processDebit(txnId: txnId, amount: amount)
        } else if isTopUp {
            viewModel.processTopUp(txnId: txnId, amount: amount)
        } else {
            viewModel.generateCardToken(txnId: txnId)
        }
    }
    func goBack() {
        if isTopUp {
            let viewControllers: [UIViewController] = (self.navigationController?.viewControllers)!
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    func goToTicketDetails() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
            let homeTab = self.tabBarController as! HomeTabBarController
            homeTab.bookedTicket = true
            homeTab.selectedIndex = 2
            for vc in (self.tabBarController?.viewControllers)! where vc is HomeViewController {
                let homeVc = vc as! HomeViewController
                homeVc.viewModel.getActiveTickets()
            }
        }
    }
}
