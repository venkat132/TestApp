//
//  UIViewControllerExt.swift
//  PuneMetro
//
//  Created by Admin on 16/04/21.
//

import Foundation
import UIKit

protocol ViewControllerLifeCycle {
    func prepareViewModel()
    func prepareUI()
}

extension UIViewController {
    var errView: UIView? {
        get {
            return self.view.viewWithTag(1010)
        }
        set {
            
        }
    }
    func hideKeyboardWhenTappedAround(remove: Bool = false) {

        var tap: UITapGestureRecognizer?
        tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap!.cancelsTouchesInView = false
        if !remove {
            view.addGestureRecognizer(tap!)
        } else {
            view.removeGestureRecognizer(tap!)
        }
    }

    @objc func dismissKeyboard() {
        MLog.log(string: "Dismissing Keyboard")
        view.endEditing(true)
    }

    func showError(errStr: String, timeout: Double? = nil, completionFunction: @escaping (() -> Void) = {}) {
        MLog.log(string: "Showing Error", errStr)
        if errView != nil {
            errView!.removeFromSuperview()
        }
        var height: Float = 20
        if let tabBarController = tabBarController {
            height +=  Float(tabBarController.tabBar.frame.height)
        }
        let size = UIUtils.rectForText(text: errStr, font: UIFont(name: "Roboto-Regular", size: 15)!, maxSize: self.view.bounds.size)
        let errContainer = UIView(frame: CGRect(origin: CGPoint(x: 0, y: self.view.frame.height - size.height - CGFloat(height)), size: CGSize(width: self.view.frame.width, height: size.height + 20)))
        errContainer.tag = 1010
        errContainer.backgroundColor = UIColor.red
        errView = errContainer
        let errLabel = UILabel(frame: CGRect(x: 10, y: 10, width: errContainer.frame.width - 20, height: errContainer.frame.height - 20))
        errLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        errLabel.numberOfLines = 0
        errLabel.textAlignment = .center
        errLabel.textColor = UIColor.white
        errLabel.text = errStr
        
        self.view.addSubview(errContainer)
        errContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        errView!.addSubview(errLabel)

        DispatchQueue.main.asyncAfter(deadline: .now() + (timeout ?? Globals.SNACKBAR_TIMEOUT)) {
            if self.errView != nil {
                self.errView!.removeFromSuperview()
            }
            completionFunction()
        }
    }
    
    func showErrorNoTimeout(errStr: String, completionFunction: @escaping (() -> Void) = {}) {
        MLog.log(string: "Showing Error", errStr)
        if errView != nil {
            errView!.removeFromSuperview()
        }
        let size = UIUtils.rectForText(text: errStr, font: UIFont(name: "Roboto-Regular", size: 15)!, maxSize: self.view.bounds.size)
        let errContainer = UIView(frame: CGRect(origin: CGPoint(x: 0, y: self.view.frame.height - size.height - 20), size: CGSize(width: self.view.frame.width, height: size.height + 20)))
        errContainer.tag = 1010
        errContainer.backgroundColor = UIColor.red
        errView = errContainer
        let errLabel = UILabel(frame: CGRect(x: 10, y: 10, width: errContainer.frame.width - 20, height: errContainer.frame.height - 20))
        errLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        errLabel.numberOfLines = 0
        errLabel.textAlignment = .left
        errLabel.textColor = UIColor.white
        errLabel.text = errStr
        
        self.view.addSubview(errContainer)
        errContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        errView!.addSubview(errLabel)
        
    }
    
    func removeError() {
        if errView != nil {
            errView!.removeFromSuperview()
        }
    }
    
    func layoutSubviews() {
        if errView != nil {
            errView?.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height - self.errView!.frame.height), size: CGSize(width: self.errView!.frame.width, height: self.errView!.frame.height))
        }
        self.view.layoutSubviews()
    }
}
