//
//  UITabBarControllerExt.swift
//  PuneMetro
//
//  Created by Admin on 17/05/21.
//

import Foundation
import UIKit
extension UITabBarController {
    func setTabBarVisible(visible: Bool, duration: TimeInterval, animated: Bool) {
        if tabBarIsVisible() == visible {
            MLog.log(string: "Returning 1")
            return
        }
        let frame = self.tabBar.frame
        let height = frame.size.height
//        let offsetY = (visible ? -height : height)

        let offsetY = 0
        MLog.log(string: "Tabbar Offset", offsetY)
        // animation
        UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.tabBar.frame.offsetBy(dx: 0, dy: CGFloat(offsetY))
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height + CGFloat(offsetY))
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
    
    func tabBarIsVisible() -> Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}
