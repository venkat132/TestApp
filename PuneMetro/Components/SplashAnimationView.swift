//
//  SplashAnimationView.swift
//  PuneMetro
//
//  Created by Admin on 18/05/21.
//

import Foundation
import UIKit
import SwiftyGif

class SplashAnimationView: UIView {
    
    var logoGifImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        do {
            logoGifImageView = try UIImageView(gifImage: UIImage(gifName: "splash-new.gif"), loopCount: 1)
            logoGifImageView.contentMode = .scaleAspectFill
            backgroundColor = UIColor.clear
            addSubview(logoGifImageView)
            logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
            logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            logoGifImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            logoGifImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        } catch let e {
            MLog.log(string: "Gif IV Error:", e.localizedDescription)
        }
    }
}
