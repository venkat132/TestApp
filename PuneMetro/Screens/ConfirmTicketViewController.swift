//
//  ConfirmTicketViewController.swift
//  PuneMetro
//
//  Created by Admin on 29/04/21.
//

import Foundation
import UIKit

class ConfirmTicketViewController: UIViewController, ViewControllerLifeCycle {
    
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var confirmTicketView: ConfirmTicketView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var payableAmountLabel: UILabel!
    @IBOutlet weak var payableAmountValueLabel: UILabel!
    @IBOutlet weak var onePuneCardCard: UIView!
    @IBOutlet weak var onePuneCardLogo: UIImageView!
    @IBOutlet weak var onePuneCardLabel: UILabel!
    @IBOutlet weak var onePuneCardRadio: UIImageView!
    @IBOutlet weak var paymentGatewayCard: UIView!
    @IBOutlet weak var paymentGatewayLogo: UIImageView!
    @IBOutlet weak var paymentGatewayLabel: UILabel!
    @IBOutlet weak var paymentGatewayRadio: UIImageView!
    @IBOutlet weak var loyaltyPointsCard: UIView!
    @IBOutlet weak var loyaltyPointsLogo: UIImageView!
    @IBOutlet weak var loyaltyPointsLabel: UILabel!
    @IBOutlet weak var loyaltyPointsRadio: UIImageView!
    @IBOutlet weak var topLoader: UIProgressView!
    
    var viewModel = ConfirmTicketModel()
    var trip = Trip()
    var ticket = Ticket()
    override func viewDidLoad() {
        prepareUI()
        prepareViewModel()
    }
    
    func prepareViewModel() {
        viewModel.didCreatedTicket = { ticket in
            self.ticket = ticket
            MLog.log(string: "Ticket Payment method:", ticket.paymentMethod)
            if ticket.paymentMethod == .paymentGateway {
                self.goToPGLoading()
            } else if ticket.paymentMethod == .smartCard {
                self.viewModel.validateDebit(amount: ticket.trip.fare)
            }
        }
        
        viewModel.didFareReceived = { fare in
            if self.ticket.trip.tripType == .group {
                self.ticket.trip.fare = fare * Double(self.ticket.trip.groupSize)
            } else {
                self.ticket.trip.fare = fare
            }
            self.prepareUI()
            self.enablePaymentGateway()
        }
        viewModel.didSmartCardDebitValidated = {txnId in
            self.goToSmartCardOTP(txnId: txnId)
        }
        viewModel.setLoading = { loading in
            if loading {
                self.topLoader.startIndefinateProgress()
            } else {
                self.topLoader.stopIndefinateProgress()
            }
        }
        viewModel.calculateFare(trip: ticket.trip)
        viewModel.shownetworktimeout = {
            // Call Screen with retry
            MLog.log(string: "Network error")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
            journeyResultVC.modalPresentationStyle = .fullScreen
            journeyResultVC.isNetworkError = true
            self.present(journeyResultVC, animated: true)
        }
        viewModel.showServertimeout = {
            // Call Screen with retry
            MLog.log(string: "Server error")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
            journeyResultVC.modalPresentationStyle = .fullScreen
            journeyResultVC.isNetworkError = false
            self.present(journeyResultVC, animated: true)
        }
    }
    
    func prepareUI() {
        metroNavBar.setup(titleStr: "Book Ticket".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        topLoader.stopIndefinateProgress()
        topLoader.trackTintColor = CustomColors.LOADER_BG
        topLoader.progressTintColor = CustomColors.COLOR_PROGRESS_BLUE
        ticket.trip = trip
        confirmTicketView.dateLabel.font = UIFont(name: "Roboto-Regular", size: 25)
        confirmTicketView.monthYearLabel.font = UIFont(name: "Roboto-Regular", size: 10)
        
        confirmTicketView.originLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        confirmTicketView.originLabel.text = "From".localized(using: "Localization")
        confirmTicketView.originLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        confirmTicketView.originValueLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        confirmTicketView.originValueLabel.textColor = .black
        
        confirmTicketView.destinationLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        confirmTicketView.destinationLabel.text = "To".localized(using: "Localization")
        confirmTicketView.destinationLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        confirmTicketView.destinationValueLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        confirmTicketView.destinationValueLabel.textColor = .black
        
        confirmTicketView.journeyTypeLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        confirmTicketView.journeyTypeLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        confirmTicketView.journeyTypeValueLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        confirmTicketView.journeyTypeValueLabel.textColor = .black
        
        confirmTicketView.totalFareLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        confirmTicketView.totalFareLabel.text = "Total Fare".localized(using: "Localization")
        confirmTicketView.totalFareLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        confirmTicketView.totalFareValueLabel.font = UIFont(name: "Roboto-Medium", size: 35)
        confirmTicketView.totalFareValueLabel.textColor = CustomColors.COLOR_DARK_GRAY
        
        confirmTicketView.durationLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        confirmTicketView.durationLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        confirmTicketView.setupTicket(ticket: ticket)
        
        confirmTicketView.addCircle()
        
        preparePaymentGatewayViews()
        
        // Hiding one pune card and Loyalty points
        // onePuneCardCard.isHidden = true
        paymentGatewayCard.isHidden = true
        loyaltyPointsCard.isHidden = true
        // your next animation within a completion handler of previous animation
     
    }
    
    func preparePaymentGatewayViews() {
        paymentMethodLabel.font = UIFont(name: "Roboto-Medium", size: 20)
        paymentMethodLabel.text = "PAYMENT METHOD".localized(using: "Localization")
        payableAmountLabel.font = UIFont(name: "Roboto-Regular", size: 10)
        payableAmountLabel.text = "Payable amount".localized(using: "Localization")
        payableAmountValueLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        payableAmountValueLabel.text = "₹ \(ticket.trip.fare)"
        
//        onePuneCardLabel.font = UIFont(name: "Roboto-Medium", size: 15)
//        onePuneCardLabel.text = "One Pune Card".localized(using: "Localization")
//        onePuneCardLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
//        onePuneCardLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        
        onePuneCardLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        onePuneCardLabel.text = "Payment Gateway (PayU)".localized(using: "Localization")
        onePuneCardLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        onePuneCardLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        onePuneCardLogo.image = paymentGatewayLogo.image
        
        paymentGatewayLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        paymentGatewayLabel.text = "Payment Gateway (PayU)".localized(using: "Localization")
        paymentGatewayLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        paymentGatewayLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        
//        paymentGatewayLabel.font = UIFont(name: "Roboto-Medium", size: 15)
//        paymentGatewayLabel.textColor = CustomColors.COLOR_DARK_GRAY
//        paymentGatewayLogo.tintColor = CustomColors.COLOR_DARK_GRAY
//        paymentGatewayCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(confirmTap)))
        
        loyaltyPointsLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        loyaltyPointsLabel.text = "Loyalty Points".localized(using: "Localization")
        loyaltyPointsLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        loyaltyPointsLogo.tintColor = CustomColors.COLOR_MEDIUM_GRAY
        
    }
    
    func enablePaymentGateway() {
//        paymentGatewayLabel.font = UIFont(name: "Roboto-Medium", size: 15)
//        paymentGatewayLabel.textColor = CustomColors.COLOR_DARK_GRAY
//        paymentGatewayLogo.tintColor = CustomColors.COLOR_DARK_GRAY
//        paymentGatewayCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymentGatewayTap)))
        
//        onePuneCardLabel.font = UIFont(name: "Roboto-Medium", size: 15)
//        onePuneCardLabel.textColor = CustomColors.COLOR_DARK_GRAY
//        onePuneCardLogo.tintColor = CustomColors.COLOR_DARK_GRAY
//        onePuneCardCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(smartCardTap)))
        
        onePuneCardLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        onePuneCardLabel.textColor = CustomColors.COLOR_DARK_GRAY
        onePuneCardLogo.tintColor = CustomColors.COLOR_DARK_GRAY
        onePuneCardCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymentGatewayTap)))
    }
    
    @objc func paymentGatewayTap(_ sender: UITapGestureRecognizer) {
        
        // PMT-1288 Start
//        paymentGatewayLogo.tintColor = .white
//        paymentGatewayLabel.textColor = .white
//        paymentGatewayRadio.image = UIImage(named: "radio-button-selected")
//        paymentGatewayCard.backgroundColor = CustomColors.COLOR_ORANGE
        onePuneCardLogo.tintColor = .white
        onePuneCardLabel.textColor = .white
        onePuneCardRadio.image = UIImage(named: "radio-button-selected")
        onePuneCardCard.backgroundColor = CustomColors.COLOR_ORANGE
        
        //PMT-1288 End
        
        MLog.log(string: "PayU Tapped")
        self.ticket.paymentMethod = .paymentGateway
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.viewModel.createTicket(trip: self.trip, paymentMethod: .paymentGateway)
        })
    }
    
    @objc func smartCardTap(_ sender: UITapGestureRecognizer) {
        onePuneCardLogo.tintColor = .white
        onePuneCardLabel.textColor = .white
        onePuneCardRadio.image = UIImage(named: "radio-button-selected")
        onePuneCardCard.backgroundColor = CustomColors.COLOR_ORANGE
        MLog.log(string: "SmartCard  Tapped")
        self.ticket.paymentMethod = .smartCard
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.viewModel.createTicket(trip: self.trip, paymentMethod: .smartCard)
        })
    }
    
    func goToSmartCardOTP(txnId: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let smartCardOTPViewController = storyboard.instantiateViewController(withIdentifier: "SmartCardOTPViewController") as! SmartCardOTPViewController
            smartCardOTPViewController.txnId = txnId
            smartCardOTPViewController.amount = self.ticket.trip.fare
            smartCardOTPViewController.idTicket = "\(self.ticket.id)"
            smartCardOTPViewController.isTopUp = false
            smartCardOTPViewController.isPayment = true
            smartCardOTPViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(smartCardOTPViewController, animated: true)
        }
    }

    func goToPGLoading() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pgLoadingViewController = storyboard.instantiateViewController(withIdentifier: "PGLoadingViewController") as! PGLoadingViewController
            pgLoadingViewController.ticket = self.ticket
            pgLoadingViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(pgLoadingViewController, animated: true)
        }
    }
}
