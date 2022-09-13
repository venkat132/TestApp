//
//  QRUtils.swift
//  PuneMetro
//
//  Created by Admin on 29/04/21.
//

import Foundation
import UIKit

class QRUtils {
    public static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    public static func updateQRCode(qrStr: String) -> String {
        let curr = Int(Date().timeIntervalSince1970)
        let currStr = String(UInt(exactly: curr)!, radix: 16, uppercase: true)
        let newQrStr = qrStr.appending("#{\(currStr)|0|0|0|0}")
        return newQrStr
    }
}
