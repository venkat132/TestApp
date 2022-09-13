//
//  FilledButton.swift
//  PuneMetro
//
//  Created by Admin on 16/04/21.
//

import Foundation
import UIKit

class UnderlineButton: BaseView {

    @IBInspectable var title: String!
    @IBInspectable var underlineColor: UIColor!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var underline: UIView!
    var onTap:(() -> Void)?

    var onTapGR: UITapGestureRecognizer?

    var bgColor: UIColor?
    var textColor: UIColor?

    override func xibSetup() {
        super.xibSetup()
        self.underline.backgroundColor = underlineColor
        self.titleLabel.text = title
    }
    
    public func setAlignment(align: NSTextAlignment) {
        for constraint in titleLabel.constraints {
            guard constraint.firstAnchor == centerXAnchor || constraint.firstAnchor == trailingAnchor else { continue }
            constraint.isActive = false
            break
        }
        if align == .right {
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        } else {
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        
        self.layoutSubviews()
    }

    public func setColor(color: UIColor) {
        self.underline.backgroundColor = color
        self.bgColor = color
    }

    public func setAttributedTitle(title: NSAttributedString) {
        self.titleLabel.attributedText = title
        self.textColor = self.titleLabel.textColor
    }

    public func setEnable(enable: Bool) {
        if enable {
            if textColor != nil {
                self.underline.backgroundColor = textColor
            }
            if textColor != nil {
                self.titleLabel.textColor = textColor
            }
            if onTapGR != nil {
                self.removeGestureRecognizer(onTapGR!)
            }
            onTapGR = UITapGestureRecognizer(target: self, action: #selector(onTapFunc))
            self.addGestureRecognizer(onTapGR!)
        } else {
            self.underline.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
            self.titleLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            if onTapGR != nil {
                self.removeGestureRecognizer(onTapGR!)
                onTapGR = nil
            }
        }
    }

    @objc func onTapFunc(_ sender: UITapGestureRecognizer) {
        if onTap != nil {
            onTap!()
        }
    }
}
