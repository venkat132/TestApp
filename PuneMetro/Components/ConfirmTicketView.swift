//
//  ConfirmTicketView.swift
//  PuneMetro
//
//  Created by Admin on 21/05/21.
//

import Foundation
import UIKit
class ConfirmTicketView: BaseView {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var cardSeperator: UIView!
    @IBOutlet weak var journeyPathImage: UIImageView!
    @IBOutlet weak var stationsSeperator: UIView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var originValueLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var destinationValueLabel: UILabel!
    @IBOutlet weak var journeyTypeLabel: UILabel!
    @IBOutlet weak var journeyTypeValueLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var totalFareLabel: UILabel!
    @IBOutlet weak var totalFareValueLabel: UILabel!
    
    func setupTicket(ticket: Ticket) {
        journeyPathImage.image = UIImage(named: "single-journey-path")
        if ticket.trip.isReturn {
            journeyPathImage.image = UIImage(named: "return-journey-path")
        }
        originValueLabel.text = ticket.trip.fromStn.name
        destinationValueLabel.text = ticket.trip.toStn.name
        
        journeyTypeValueLabel.text = "\(ticket.trip.groupSize) - \(ticket.trip.tripType.rawValue)"
        
        totalFareValueLabel.text = "₹ \(ticket.trip.fare)"
        totalFareValueLabel.adjustsFontSizeToFitWidth = true
        
        dateLabel.text = "\(Date().get(.day))"
        monthYearLabel.text = "\(Globals.MONTHS[Date().get(.month) - 1]),\(Date().get(.year))"
    }
    
    func addCircle() {
//        let height = (monthYearLabel.bounds.height + dateLabel.bounds.height) / 2
        let height = CGFloat(30)
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: height, y: height), radius: height, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        MLog.log(string: "Date View height1", dateView.frame.width, height)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        // Change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        // You can change the stroke color
        shapeLayer.strokeColor = CustomColors.COLOR_ORANGE.cgColor
        // You can change the line width
        shapeLayer.lineWidth = 1.0
        
        dateView.layer.addSublayer(shapeLayer)
    }
}
