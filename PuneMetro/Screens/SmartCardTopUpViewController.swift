//
//  SmartCardTopUpViewController.swift
//  PuneMetro
//
//  Created by Admin on 02/08/21.
//

import Foundation
import UIKit
class SmartCardTopUpViewController: UIViewController, ViewControllerLifeCycle, UITextFieldDelegate {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterStack: UIStackView!
    @IBOutlet weak var tile100: UIView!
    @IBOutlet weak var label100: UILabel!
    @IBOutlet weak var tile200: UIView!
    @IBOutlet weak var label200: UILabel!
    @IBOutlet weak var tile500: UIView!
    @IBOutlet weak var label500: UILabel!
    @IBOutlet weak var tile1000: UIView!
    @IBOutlet weak var label1000: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var paymentGatewayTile: UIView!
    @IBOutlet weak var paymentGatewayLogo: UIImageView!
    @IBOutlet weak var paymentGatewayLabel: UILabel!
    @IBOutlet weak var paymentGatewayRadio: UIImageView!
    
    @IBOutlet weak var CustomContainer: UIView!
    @IBOutlet weak var AddCustomAmountLbl: UILabel!
    @IBOutlet weak var AddAmountin100Lbl: UILabel!
    @IBOutlet weak var AmountTFT: UITextField!
    @IBOutlet weak var PaymentMethodLbl: UILabel!

    var selectedAmount = 100.0
    var viewModel = SmartCardTopUpModel()
    var flagGoToPG = false
    var idTransaction = ""
    
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
//        if let tabBarController = tabBarController {
//            scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
//        }
        metroNavBar.setup(titleStr: "Smart Card".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.textColor = .black
        titleLabel.text = "Top Up".localized(using: "Localization")
        
        paymentGatewayLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        paymentGatewayLabel.textColor = CustomColors.COLOR_DARK_GRAY
        paymentGatewayLogo.tintColor = CustomColors.COLOR_DARK_GRAY
        paymentGatewayTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPaymentTap)))
        
        AddCustomAmountLbl.text = "Add custom amount".localized(using: "Localization")
        AddCustomAmountLbl.textColor = UIColor.black
        AddCustomAmountLbl.font = UIFont(name: "Roboto-Medium", size: 12)
        
        AddAmountin100Lbl.text = "(Add amount in multiples of 100)".localized(using: "Localization")
        AddAmountin100Lbl.textColor = CustomColors.COLOR_DARK_GRAY
        AddAmountin100Lbl.font = UIFont(name: "Roboto-Medium", size: 10)
        
//        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
//        AmountTFT.leftView = paddingView
//        AmountTFT.leftViewMode = .always
        AmountTFT.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        AmountTFT.layer.cornerRadius = 25
        AmountTFT.layer.borderWidth = 1
        AmountTFT.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        AmountTFT.attributedPlaceholder = NSAttributedString(string: "Enter Amount".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: CustomColors.COLOR_MEDIUM_GRAY, NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 18)!])
        AmountTFT.delegate = self
        
        PaymentMethodLbl.text = "PAYMENT METHOD".localized(using: "Localization")
        PaymentMethodLbl.textColor = CustomColors.COLOR_DARK_GRAY
        PaymentMethodLbl.font = UIFont(name: "Roboto-Medium", size: 15)
        
        CustomContainer.isHidden = true
        
        prepareAmounts()
    }
    func prepareViewModel() {
        viewModel.didTopUpValidated = { idTransaction, serial in
            self.goToPGLoading(idTransaction: idTransaction, amount: self.selectedAmount, serial: serial)
        }
        viewModel.didTransactionReceived = {txnId in
            self.goToOTP(txnId: txnId)
        }
        viewModel.getPaymentGatewayKey()
    }
    func prepareAmounts() {
        tile100.backgroundColor = .white
        tile100.layer.borderWidth = 0.5
        tile100.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        label100.font = UIFont(name: "Roboto-Medium", size: 12)
        label100.text = "100"
        label100.textColor = CustomColors.COLOR_DARK_GRAY
        tile100.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAmountTap)))
        
        tile200.backgroundColor = .white
        tile200.layer.borderWidth = 0.5
        tile200.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        label200.font = UIFont(name: "Roboto-Medium", size: 12)
        label200.text = "200"
        label200.textColor = CustomColors.COLOR_DARK_GRAY
        tile200.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAmountTap)))
        
        tile500.backgroundColor = .white
        tile500.layer.borderWidth = 0.5
        tile500.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        label500.font = UIFont(name: "Roboto-Medium", size: 12)
        label500.text = "500"
        label500.textColor = CustomColors.COLOR_DARK_GRAY
        tile500.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAmountTap)))
        
        tile1000.backgroundColor = .white
        tile1000.layer.borderWidth = 0.5
        tile1000.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        label1000.font = UIFont(name: "Roboto-Medium", size: 12)
        label1000.text = "Custom"
        label1000.textColor = CustomColors.COLOR_DARK_GRAY
        tile1000.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAmountTap)))
        
        setAmountSelection()
    }
    func setAmountSelection() {
        tile100.backgroundColor = (selectedAmount == 100) ? CustomColors.COLOR_ORANGE : .white
        tile100.layer.borderColor = (selectedAmount == 100) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        label100.textColor = (selectedAmount == 100) ? .white : CustomColors.COLOR_DARK_GRAY
        
        tile200.backgroundColor = (selectedAmount == 200) ? CustomColors.COLOR_ORANGE : .white
        tile200.layer.borderColor = (selectedAmount == 200) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        label200.textColor = (selectedAmount == 200) ? .white : CustomColors.COLOR_DARK_GRAY
        
        tile500.backgroundColor = (selectedAmount == 500) ? CustomColors.COLOR_ORANGE : .white
        tile500.layer.borderColor = (selectedAmount == 500) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        label500.textColor = (selectedAmount == 500) ? .white : CustomColors.COLOR_DARK_GRAY
        
        tile1000.backgroundColor = (selectedAmount == 001) ? CustomColors.COLOR_ORANGE : .white
        tile1000.layer.borderColor = (selectedAmount == 001) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        label1000.textColor = (selectedAmount == 001) ? .white : CustomColors.COLOR_DARK_GRAY
    }
    
    @objc func onAmountTap(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case tile100:
            selectedAmount = 100
            CustomContainer.isHidden = true
            AmountTFT.text = ""
        case tile200:
            selectedAmount = 200
            CustomContainer.isHidden = true
            AmountTFT.text = ""
        case tile500:
            selectedAmount = 500
            CustomContainer.isHidden = true
            AmountTFT.text = ""
        case tile1000: selectedAmount = 001
             CustomContainer.isHidden = false
        default: MLog.log(string: "Invalid Amount Selection")
        }
        self.view.endEditing(true)
        setAmountSelection()
    }
    
    @objc func onPaymentTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        paymentGatewayLogo.tintColor = .white
        paymentGatewayLabel.textColor = .white
        paymentGatewayRadio.image = UIImage(named: "radio-button-selected")
        paymentGatewayTile.backgroundColor = CustomColors.COLOR_ORANGE
        MLog.log(string: "PG Tapped")
        
        if selectedAmount ==  001 {
            if AmountTFT.text?.isEmpty ?? true {
                self.showError(errStr: "Add amount in multiples of 100".localized(using: "Localization"))
                return
            }
            let amount: Int? = Int(AmountTFT.text!)
            if amount!.isMultiple(of: 100) {
                MLog.log(string: amount)
                selectedAmount = Double(amount!)
            } else {
                self.showError(errStr: "Add amount in multiples of 100".localized(using: "Localization"))
                return
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            MLog.log(string: "PG Processed:", self.selectedAmount)
            self.viewModel.validateTopUp(amount: self.selectedAmount)
        })
    }
    
    func goToOTP(txnId: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let smartCardOTPViewController = storyboard.instantiateViewController(withIdentifier: "SmartCardOTPViewController") as! SmartCardOTPViewController
            smartCardOTPViewController.txnId = txnId
            smartCardOTPViewController.amount = self.selectedAmount
            smartCardOTPViewController.isTopUp = true
            smartCardOTPViewController.isPayment = false
            smartCardOTPViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(smartCardOTPViewController, animated: true)
        }
    }
    
    func goToPGLoading(idTransaction: String, amount: Double, serial: String) {
        self.flagGoToPG = true
        self.idTransaction = idTransaction
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pgLoadingViewController = storyboard.instantiateViewController(withIdentifier: "PGLoadingViewController") as! PGLoadingViewController
            pgLoadingViewController.isTopUp = true
            pgLoadingViewController.idTransaction = idTransaction
            pgLoadingViewController.serialTransaction = serial
            pgLoadingViewController.transactionAmount = amount
            pgLoadingViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(pgLoadingViewController, animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
