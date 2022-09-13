//
//  UIImageViewExt.swift
//  PuneMetro
//
//  Created by Admin on 21/07/21.
//

import Foundation
import UIKit
extension UIImageView {
    func addBadge(value: String = "") {
        self.removeBadge()
        self.clipsToBounds = false
        let badgeLabel = UILabel(frame: CGRect(origin: CGPoint(x: 15, y: -5), size: CGSize(width: 13, height: 13)))
        badgeLabel.backgroundColor = .orange
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont(name: "Roboto-Regular", size: 8)
        badgeLabel.text = value
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 3
        badgeLabel.clipsToBounds = true
        
        self.addSubview(badgeLabel)
        MLog.log(string: "Badge:", self.frame, badgeLabel.frame)
//
//        badgeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        badgeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
//        self.layoutSubviews()
    }
    
    func removeBadge() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}
