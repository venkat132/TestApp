//
//  UITextFieldExt.swift
//  PuneMetro
//
//  Created by Admin on 30/05/21.
//

import Foundation
import UIKit
extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.datePickerMode = .date
        if self.text != nil {
            let date = DateUtils.returnDate(self.text!)
            if date != nil {
                datePicker.setDate(date!, animated: false)
            }
        }
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
       // toolBar.isTranslucent = false
       // toolBar.backgroundColor = .orange
       // toolBar.tintColor = .blue
       // toolBar.barTintColor = CustomColors.COLOR_LIGHT_GRAY
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
//        cancel.tintColor = .black
//        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
//        barButton.tintColor = .orange
//        barButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)

        let cancel = UIButton()
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(CustomColors.COLOR_DARK_BLUE, for: .normal)
        cancel.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
        cancel.addTarget(nil, action: #selector(tapCancel), for: .touchUpInside)
        let cancelBtn = UIBarButtonItem(customView: cancel)
        
        let myFirstButton = UIButton()
           myFirstButton.setTitle("Done", for: .normal)
           myFirstButton.setTitleColor(CustomColors.COLOR_DARK_BLUE, for: .normal)
           myFirstButton.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
           myFirstButton.addTarget(target, action: selector, for: .touchUpInside)
        let sample = UIBarButtonItem(customView: myFirstButton)

        toolBar.setItems([cancelBtn, flexible, sample], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
