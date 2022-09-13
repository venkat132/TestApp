//
//  CustomAlertViewController.swift
//  PuneMetro
//
//  Created by Admin on 31/05/21.
//

import Foundation
import UIKit
class CustomAlertViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var button1: FilledButton!
    @IBOutlet weak var button2: FilledButton!
    
    var button1Action: (() -> Void)?
    
    var titleStr: String = "Alert"
    var message: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In et mauris ultrices, vulputate dolor at, accumsan leo. Aliquam sollicitudin elementum dolor, vel posuere neque convallis non. Sed et accumsan velit. Nulla molestie mauris et lacus gravida maximus. Duis sed augue non orci mollis elementum. Vivamus bibendum diam ut congue tempor. In sagittis ligula vitae dolor consequat condimentum."
    
    var showButton1: Bool = false
    var showButton2: Bool = false
    var button1Title: String = ""
    var button2Title: String = ""
    var button1OnTap: (() -> Void)?
    var button2OnTap: (() -> Void)?
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgTapped)))
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 28)
        titleLabel.text = titleStr
        
        messageLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        messageLabel.text = message
        
        button2.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        button2.setAttributedTitle(title: NSAttributedString(string: button2Title, attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        button2.onTap = button2OnTap ?? closeTap
        button2.isHidden = !showButton2
        button2.setEnable(enable: true)
        
        button1.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        button1.setAttributedTitle(title: NSAttributedString(string: button1Title, attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        button1.onTap = button1OnTap ?? closeTap
        button1.isHidden = !showButton1
        button1.setEnable(enable: true)
        
    }
    func prepareViewModel() {
        
    }
    
    public func closeTap() {
        self.dismiss(animated: true, completion: {})
    }
    
    @objc func bgTapped(_ sender: UITapGestureRecognizer) {
        self.closeTap()
    }
}
