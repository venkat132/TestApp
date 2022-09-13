//
//  SmartCardHomeViewController.swift
//  PuneMetro
//
//  Created by Admin on 29/07/21.
//

import Foundation
import UIKit
class SmartCardHomeViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleCenterLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var topUpTile: UIView!
    @IBOutlet weak var topUpLogo: UIImageView!
    @IBOutlet weak var topUpLabel: UILabel!
    @IBOutlet weak var statementTile: UIView!
    @IBOutlet weak var statementLogo: UIImageView!
    @IBOutlet weak var statementLabel: UILabel!
    @IBOutlet weak var delinkTile: UIView!
    @IBOutlet weak var delinkLogo: UIImageView!
    @IBOutlet weak var delinkLabel: UILabel!
    
    var isLinked: Bool = false
    var viewModel = SmartCardHomeModel()
    var flagReload = false
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        if flagReload {
            self.flagReload = false
            self.viewDidLoad()
        }
    }
    func prepareUI() {
        if let tabBarController = tabBarController {
            scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        metroNavBar.setup(titleStr: "Smart Card".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        titleCenterLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleCenterLabel.textColor = .black
        titleCenterLabel.text = "Link One Pune Card".localized(using: "Localization")
        
        balanceLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        balanceLabel.textColor = .black
        balanceLabel.text = "Available Balance".localized(using: "Localization")
        balanceLabel.isHidden = true
        
        balanceValueLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        balanceValueLabel.textColor = .black
        balanceValueLabel.text = "₹ 00.00"
        balanceValueLabel.isHidden = true
        
        self.cardImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkTapped)))
        topUpTile.isHidden = true
        statementTile.isHidden = true
        delinkTile.isHidden = true
        cardImage.isHidden = true
        
        // Disabled for coming soon
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let alert = UIAlertController(title: "Smart Card".localized(using: "Localization"), message: "Coming soon".localized(using: "Localization"), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok".localized(using: "Localization"), style: UIAlertAction.Style.default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        })
    }
    func prepareViewModel() {
        viewModel.didLinkedCardFound = { cardFound in
            self.isLinked = cardFound
            self.setLinked()
        }
        viewModel.didBalanceReceived = { balance in
            self.titleCenterLabel.isHidden = true
            self.balanceLabel.isHidden = false
            self.balanceValueLabel.isHidden = false
            let nf = NumberFormatter()
            nf.minimumFractionDigits = 2
            nf.maximumFractionDigits = 2
            self.balanceValueLabel.textColor = (balance > 0) ? .black : CustomColors.COLOR_LIGHT_GRAY
            self.balanceValueLabel.text = "₹ \(nf.string(from: NSNumber(value: balance))!)"
        }
        viewModel.didRequestCardToken = {txnId in
            self.goToOTP(txnId: txnId)
        }
        viewModel.getLinkedCard()
    }
    
    func setLinked() {
        cardImage.isHidden = false
        if isLinked {
            cardImage.image = UIImage(named: "card-linked")!
            topUpTile.isHidden = false
            topUpLabel.font = UIFont(name: "Roboto-Regular", size: 18)
            topUpLabel.text = "TOP UP".localized(using: "Localization")
            topUpTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTapped)))
            statementTile.isHidden = false
            statementLabel.font = UIFont(name: "Roboto-Regular", size: 18)
            statementLabel.text = "STATEMENT".localized(using: "Localization")
            statementTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTapped)))
            delinkTile.isHidden = false
            delinkLabel.font = UIFont(name: "Roboto-Regular", size: 18)
            delinkLabel.text = "DELINK".localized(using: "Localization")
            delinkTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTapped)))
            viewModel.getCardBalance()
        } else {
            self.titleCenterLabel.isHidden = false
            self.balanceLabel.isHidden = true
            self.balanceValueLabel.isHidden = true
            topUpTile.isHidden = true
            statementTile.isHidden = true
            delinkTile.isHidden = true
            cardImage.image = UIImage(named: "card-not-linked")!
        }
    }
    
    @objc func linkTapped(_ sender: UITapGestureRecognizer) {
        self.viewModel.requestCardToken()
    }
    
    @objc func tileTapped(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case topUpTile:
            topUpTile.backgroundColor = CustomColors.COLOR_ORANGE
            topUpLogo.tintColor = .white
            topUpLabel.textColor = .white
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                MLog.log(string: "Going to topup")
                self.flagReload = true
                self.topUpTile.backgroundColor = .white
                self.topUpLogo.tintColor = .black
                self.topUpLabel.textColor = .black
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let smartCardTopUpViewController = storyboard.instantiateViewController(withIdentifier: "SmartCardTopUpViewController") as! SmartCardTopUpViewController
                smartCardTopUpViewController.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(smartCardTopUpViewController, animated: true)
            })
        case statementTile:
            statementTile.backgroundColor = CustomColors.COLOR_ORANGE
            statementLogo.tintColor = .white
            statementLabel.textColor = .white
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                MLog.log(string: "Going to statement")
                self.statementTile.backgroundColor = .white
                self.statementLogo.tintColor = .black
                self.statementLabel.textColor = .black
            })
        case delinkTile:
            delinkTile.backgroundColor = CustomColors.COLOR_ORANGE
            delinkLogo.tintColor = .white
            delinkLabel.textColor = .white
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                MLog.log(string: "Going to delink")
                self.delinkTile.backgroundColor = .white
                self.delinkLogo.tintColor = .black
                self.delinkLabel.textColor = .black
            })
        default: MLog.log(string: "Invalid Tile Tapped")
        }
    }
    func goToOTP(txnId: String) {
        self.flagReload = true
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let smartCardOTPViewController = storyboard.instantiateViewController(withIdentifier: "SmartCardOTPViewController") as! SmartCardOTPViewController
            smartCardOTPViewController.txnId = txnId
            smartCardOTPViewController.isTopUp = false
            smartCardOTPViewController.isPayment = false
            smartCardOTPViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(smartCardOTPViewController, animated: true)
        }
    }
}
