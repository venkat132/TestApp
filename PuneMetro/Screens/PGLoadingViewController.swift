//
//  PGLoadingViewController.swift
//  PuneMetro
//
//  Created by Admin on 11/05/21.
//

import Foundation
import UIKit

class PGLoadingViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var prograssImage: UIImageView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomBg: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var retryButton: FilledButton!
    @IBOutlet weak var noButton: FilledButton!
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var refundMessage: UILabel!
    var viewModel = PGLoadingModel()
    var ticket = Ticket()
    
    var isTopUp = false
    var idTransaction = ""
    var serialTransaction = ""
    var transactionAmount = 0.0
    
    override func viewDidAppear(_ animated: Bool) {
        //        self.tabBarController!.setTabBarVisible(visible: false, duration: 0.3, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    //
    override func viewWillDisappear(_ animated: Bool) {
        //        self.tabBarController!.setTabBarVisible(visible: true, duration: 0.3, animated: true)
        if isMovingFromParent {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        prepareUI()
        prepareViewModel()
        super.viewDidLoad()
    }
    
    func prepareViewModel() {
        viewModel.didCompletePayment = {
            self.prograssImage.image = UIImage(named: "book-progress-3")!
            self.statusImage.isHidden = false
            self.statusImage.image = UIImage(named: "payment-successful")
            self.message.text = "Payment Successful".localized(using: "Localization")
            self.retryButton.isHidden = true
            self.noButton.isHidden = true
//            self.viewModel.getTicketDetails()
            if self.isTopUp {
                self.goToTopUp()
            } else {
                Thread.sleep(forTimeInterval: 2) //PMT-1332
                self.goToTicketDetails()
            }
        }
        viewModel.didFetchTicket = { ticket in
            self.ticket = ticket
            self.goToTicketDetails()
        }
        viewModel.didPaymentError = { _ in
            self.prograssImage.image = UIImage(named: "book-progress-2")!
            self.statusImage.isHidden = false
            self.statusImage.image = UIImage(named: "payment-unsuccessful")
            self.message.text = "Payment Failed. Do you want to retry?".localized(using: "Localization")
            self.retryButton.isHidden = false
            self.noButton.isHidden = false
            self.infoIcon.isHidden = false
            self.refundMessage.isHidden = false
//            self.showError(errStr: msg, timeout: 4.0, completionFunction: {
//                self.navigationController?.popViewController(animated: true)
//            })
            
        }
        viewModel.didPaymentCancel = { _ in
            self.prograssImage.image = UIImage(named: "book-progress-2")!
            self.statusImage.isHidden = false
            self.statusImage.image = UIImage(named: "payment-cancelled")
            self.message.text = "Payment Cancelled. Do you want to retry?".localized(using: "Localization")
            self.retryButton.isHidden = false
            self.noButton.isHidden = false
        }
        viewModel.didCreatedTicket = { ticket in
            self.ticket = ticket
            self.viewModel.startPayment(vc: self, ticket: self.ticket)
        }
        if isTopUp {
            viewModel.startTopUpPayment(vc: self, amount: transactionAmount, idTransaction: idTransaction, serial: serialTransaction)
        } else {
            viewModel.startPayment(vc: self, ticket: self.ticket)
        }
        
    }
    
    func prepareUI() {
        
        metroNavBar.setup(titleStr: "Payment".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {
                            self.navigationController?.popViewController(animated: true)
        }, rightImage: nil, rightTap: {})
        message.font = UIFont(name: "Roboto-Regular", size: 15)
        self.statusImage.isHidden = true
        self.infoIcon.isHidden = true
        self.refundMessage.isHidden = true
        self.message.text = "Please wait while we redirect you to payment gateway".localized(using: "Localization")
        prograssImage.isHidden = isTopUp
        titleContainer.isHidden = !isTopUp
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.textColor = .black
        titleLabel.text = "Top Up".localized(using: "Localization")
        
        retryButton.setColor(color: CustomColors.COLOR_DARK_BLUE)
        retryButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        retryButton.setAttributedTitle(title: NSAttributedString(string: "YES".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        retryButton.setEnable(enable: true)
        retryButton.onTap = retryTap
        retryButton.isHidden = true
        
        noButton.setColor(color: CustomColors.COLOR_DARK_BLUE)
        noButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        noButton.setAttributedTitle(title: NSAttributedString(string: "NO".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        noButton.setEnable(enable: true)
        noButton.onTap = noTap
        noButton.isHidden = true
    }
    
    func retryTap() {
        DispatchQueue.main.async {
            self.statusImage.isHidden = true
            self.message.text = "Please wait while we redirect you to payment gateway".localized(using: "Localization")
            self.retryButton.isHidden = true
            self.infoIcon.isHidden = true
            self.refundMessage.isHidden = true
            self.viewModel.createTicket(trip: self.ticket.trip, paymentMethod: self.ticket.paymentMethod!)
        }
    }
    
    func noTap() {
        self.navigationController?.popToRootViewController(animated: false)
        self.tabBarController?.selectedIndex = 0
    }
    
    func goToTicketDetails() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
            if let homeTab = self.tabBarController as? HomeTabBarController {
            homeTab.bookedTicket = true
            homeTab.selectedIndex = 2
            for vc in (self.tabBarController?.viewControllers)! where vc is HomeViewController {
                let homeVc = vc as! HomeViewController
                homeVc.viewModel.getActiveTickets()
            }
            }
        }
    }
    
    func goToTopUp() {
        DispatchQueue.main.async {
            for vc in self.navigationController!.viewControllers where vc is SmartCardTopUpViewController {
                let topUpVc = vc as! SmartCardTopUpViewController
                self.navigationController?.popToViewController(topUpVc, animated: true)
                topUpVc.viewModel.getTransaction(idTransaction: topUpVc.idTransaction)
                
            }
        }
    }
}
