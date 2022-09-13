//
//  HelpTile.swift
//  PuneMetro
//
//  Created by Admin on 02/06/21.
//

import Foundation
import UIKit

class CCItemLine: BaseView {
    @IBInspectable var title: String = ""
    @IBInspectable var text: String = ""
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dotsLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    func setup(font: UIFont, titleColor: UIColor) {
        titleLabel.font = font
        titleLabel.textColor = titleColor
        titleLabel.text = title.localized(using: "Localization")
        
        dotsLabel.font = font
        dotsLabel.textColor = titleColor
        
        textLabel.font = font
        textLabel.textColor = titleColor
        textLabel.text = text.localized(using: "Localization")
        textLabel.numberOfLines = 0
        textLabel.sizeToFit()
    }
    
}
