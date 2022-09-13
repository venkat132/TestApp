//
//  CCMahitiKendraViewController.swift
//  PuneMetro
//
//  Created by Admin on 10/07/21.
//

import Foundation
import UIKit
class CCMahitiKendraViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLogo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoContainer: UIStackView!
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var mahitiKendraImage: UIImageView!
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
        metroNavBar.setup(titleStr: "Customer Care".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.text = "Mahiti Kendra".localized(using: "Localization")
        titleLabel.textColor = .black
        
        infoTitle.text = "GENERAL INFORMATION CENTER".localized(using: "Localization")
        infoTitle.font = UIFont(name: "Roboto-Medium", size: 16)
        
        sectionTitle.text = "Near Balgandharv Rangamandir, Jangli Maharaj Road".localized(using: "Localization")
        sectionTitle.font = UIFont(name: "Roboto-Medium", size: 15)
    }
    func prepareViewModel() {
        
    }
}
