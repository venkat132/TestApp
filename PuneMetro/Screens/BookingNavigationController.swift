//
//  HomeNavigationViewController.swift
//  PuneMetro
//
//  Created by Admin on 21/04/21.
//

import Foundation
import UIKit

class BookingNavigationController: UINavigationController, UINavigationControllerDelegate {

    public var imageView: UIImageView?
    public var titleText: UILabel?
    public var backButton: UIButton?
    override func viewDidLoad() {
        self.delegate = self
        self.view.backgroundColor = UIColor.white
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        MLog.log(string: "Showing VC:", viewController)
        self.navigationBar.isHidden = true
    }
    
    @objc func backPressed(_ sender: UIButton) {
        self.popViewController(animated: true)
    }
}
