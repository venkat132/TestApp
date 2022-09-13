//
//  CustomColors.swift
//  PuneMetro
//
//  Created by Admin on 16/04/21.
//

import Foundation
import UIKit

class CustomColors {

    static let COLOR_DARK_BLUE = hexStringToUIColor(hex: "#0C2670")
    static let COLOR_DARK_GRAY = hexStringToUIColor(hex: "#666666")
    static let COLOR_MEDIUM_GRAY = hexStringToUIColor(hex: "#999999")
    static let COLOR_LIGHT_GRAY = hexStringToUIColor(hex: "#bbbbbb")
    static let GRADIENT_BOTTOM = hexStringToUIColor(hex: "#A3ACC9")
    static let COLOR_VIOLET = hexStringToUIColor(hex: "#612291")
    static let COLOR_LIGHTEST_GREEN = hexStringToUIColor(hex: "#e0e8d1")
    static let COLOR_LIGHT_GREEN = hexStringToUIColor(hex: "#aac576")
    static let COLOR_GREEN = hexStringToUIColor(hex: "#a2cf38")
    static let COLOR_PROGRESS_GREEN = hexStringToUIColor(hex: "#a3d20c")
    static let COLOR_PROGRESS_YELLOW = hexStringToUIColor(hex: "#f8da46")
    static let COLOR_PROGRESS_RED = hexStringToUIColor(hex: "#f70707")
    static let COLOR_PROGRESS_BLUE = hexStringToUIColor(hex: "#3f98cc")
    static let COLOR_LIGHT_ORANGE = hexStringToUIColor(hex: "#f7a707")
    static let COLOR_ORANGE = hexStringToUIColor(hex: "#ee6123")
    
    static let COLOR_AQUA_LINE = hexStringToUIColor(hex: "#00DBFF")
    static let COLOR_PURPLE_LINE = hexStringToUIColor(hex: "#D15CA2")
    
    static let TOP_BAR_GRADIENT_TOP = hexStringToUIColor(hex: "#095C8C")
    static let TOP_BAR_GRADIENT_BOTTOM = hexStringToUIColor(hex: "#022F49")
    
    static let TAB_BAR_GRADIENT_TOP = hexStringToUIColor(hex: "#095C8C")
    static let TAB_BAR_GRADIENT_BOTTOM = hexStringToUIColor(hex: "#A1E1FC")
    static let COLOR_WHITE = hexStringToUIColor(hex: "#FFFFFF")
    static let COLOR_WHITE6 = hexStringToUIColor(hex: "#F2F2F7")
    
    static let LOADER_BG = hexStringToUIColor(hex: "#222222").withAlphaComponent(0.4)
    

    static func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
class SplashBG {
    var gl: CAGradientLayer!

    init() {
        let colorTop = UIColor.white.cgColor
        let colorBottom = CustomColors.GRADIENT_BOTTOM.cgColor

        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 0.7]
    }
}
class TopBarBG {
    var gl: CAGradientLayer!
    
    init() {
        let colorTop = CustomColors.TOP_BAR_GRADIENT_TOP.cgColor
        let colorBottom = CustomColors.TOP_BAR_GRADIENT_BOTTOM.cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 0.7]
    }
}
class TabBarBG {
    var gl: CAGradientLayer!
    
    init() {
        let colorTop = CustomColors.TAB_BAR_GRADIENT_TOP.cgColor
        let colorBottom = CustomColors.TAB_BAR_GRADIENT_BOTTOM.cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 0.7]
    }
}

class ImageOverlay {
    var gl: CAGradientLayer!
    
    init() {
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 0.9]
    }
}
