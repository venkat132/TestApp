//
//  MetroNavBar.swift
//  PuneMetro
//
//  Created by Admin on 19/05/21.
//

import Foundation
import UIKit
class MetroNavBar: BaseView {
    @IBOutlet weak var topBg: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIImageView!
    @IBOutlet weak var rightButton: UIImageView!
    
    @IBOutlet weak var bottomCard: UIImageView!
    
    var leftTap: (() -> Void)?
    var rightTap: (() -> Void)?
    
    var backgroundLayer: CAGradientLayer?
    func setup(titleStr: String, leftImage: UIImage?, leftTap: @escaping (() -> Void), rightImage: UIImage?, rightTap: @escaping (() -> Void)) {
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 25)
        titleLabel.text = titleStr
        
        leftButton.image = leftImage
        self.leftTap = leftTap
        leftButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLeftTap)))
        rightButton.image = rightImage
        self.rightTap = rightTap
        rightButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRightTap)))
        self.layoutSubviews()
    }
    
    @objc func onLeftTap(_ sender: UITapGestureRecognizer) {
        if leftTap != nil {
            leftTap!()
        }
    }
    
    @objc func onRightTap(_ sender: UITapGestureRecognizer) {
        if rightTap != nil {
            rightTap!()
        }
    }
    override func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth]
        addSubview(view)
        contentView = view
    }
    
    override func layoutSubviews() {
        self.backgroundColor = .clear
        topBg.backgroundColor = .clear
        if backgroundLayer != nil {
            backgroundLayer?.removeFromSuperlayer()
        }
        backgroundLayer = TopBarBG().gl
        backgroundLayer!.frame = CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: self.frame.height * 0.4))
        topBg.layer.insertSublayer(backgroundLayer!, at: 0)
        MLog.log(string: "Top bg frames:", self.frame, topBg.frame, backgroundLayer?.frame)
        super.layoutSubviews()
    }
}
