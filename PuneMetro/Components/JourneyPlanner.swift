//
//  BookTicketView.swift
//  PuneMetro
//
//  Created by Admin on 20/05/21.
//

import Foundation
import UIKit
class JourneyPlanner: BaseView, UITextFieldDelegate {
    
    @IBOutlet weak var journeyPathImage: UIImageView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var seperator2: UIView!
    @IBOutlet weak var submitButton: FilledButton!
    @IBOutlet weak var fromTextfield: UITextField!
    @IBOutlet weak var toTextfield: UITextField!
    var onTextchange:(() -> Void)?
    
    func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        // self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.clipsToBounds = true
        seperator2.createDottedLine(width: 2, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        
        fromTextfield.delegate = self
        toTextfield.delegate = self
    }
        
}
