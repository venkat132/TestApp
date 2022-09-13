//
//  FilledButton.swift
//  PuneMetro
//
//  Created by Admin on 16/04/21.
//

import Foundation
import UIKit

class FilledButton: BaseView {

    @IBOutlet weak var titleLabel: UILabel!

    var onTap:(() -> Void)?

    var onTapGR: UITapGestureRecognizer?

    var bgColor: UIColor?
    
    let backgroundLayer = TopBarBG().gl
    
    public func setColor(color: UIColor) {
        self.backgroundColor = color
        self.bgColor = color
    }

    public func setAttributedTitle(title: NSAttributedString) {
        self.titleLabel.attributedText = title
    }

    public func setEnable(enable: Bool) {
        if enable {
//            if bgColor != nil {
//                self.backgroundColor = bgColor
//            }
            titleLabel.isEnabled = true
            self.backgroundColor = .clear
            self.backgroundLayer?.removeFromSuperlayer()
            backgroundLayer!.frame = CGRect(origin: .zero, size: self.frame.size)
            MLog.log(string: backgroundLayer?.frame)
            self.layer.insertSublayer(backgroundLayer!, at: 0)
            if onTapGR != nil {
                self.removeGestureRecognizer(onTapGR!)
            }
            onTapGR = UITapGestureRecognizer(target: self, action: #selector(onTapFunc))
            self.addGestureRecognizer(onTapGR!)
        } else {
            titleLabel.isEnabled = false
            self.backgroundLayer?.removeFromSuperlayer()
            self.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveLinear, animations: {
                self.alpha = 0.5
            }, completion: nil)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.alpha = 0.5
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveLinear, animations: {
                self.alpha = 1.0
            }, completion: nil)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.alpha = 0.5
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveLinear, animations: {
                self.alpha = 1.0
            }, completion: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if backgroundColor == .clear {
            //            if bgColor != nil {
            //                self.backgroundColor = bgColor
            //            }
            self.backgroundColor = .clear
            self.backgroundLayer?.removeFromSuperlayer()
            backgroundLayer!.frame = CGRect(origin: .zero, size: self.frame.size)
            MLog.log(string: backgroundLayer?.frame)
            self.layer.insertSublayer(backgroundLayer!, at: 0)
            if onTapGR != nil {
                self.removeGestureRecognizer(onTapGR!)
            }
            onTapGR = UITapGestureRecognizer(target: self, action: #selector(onTapFunc))
            self.addGestureRecognizer(onTapGR!)
        } else {
            self.backgroundLayer?.removeFromSuperlayer()
            self.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
            if onTapGR != nil {
                self.removeGestureRecognizer(onTapGR!)
                onTapGR = nil
            }
        }
    }
}
