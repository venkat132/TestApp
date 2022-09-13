//
//  UINavigationBarExt.swift
//  PuneMetro
//
//  Created by Admin on 11/05/21.
//

import Foundation
import UIKit
extension UINavigationBar {
    var largeTitleHeight: CGFloat {
        let maxSize = self.subviews
            .filter { $0.frame.origin.y > 0 }
            .max { $0.frame.origin.y < $1.frame.origin.y }
            .map { $0.frame.size }
        return maxSize?.height ?? 0
    }
}
