//
//  HelpTile.swift
//  PuneMetro
//
//  Created by Admin on 02/06/21.
//

import Foundation
import UIKit

class MenuTile: BaseView {
    @IBInspectable var imageName: String = ""
    @IBInspectable var text: String = ""
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(font: UIFont, titleColor: UIColor) {
        imageView.image = UIImage(named: imageName)
        imageView.tintColor = titleColor
        
        titleLabel.text = text.localized(using: "Localization")
        titleLabel.textColor = titleColor
        titleLabel.font = font
    }
    
}
