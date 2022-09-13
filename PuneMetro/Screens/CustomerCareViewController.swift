//
//  CustomerCareViewController.swift
//  PuneMetro
//
//  Created by Admin on 09/07/21.
//

import Foundation
import UIKit
class CustomerCareViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLogo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var MenuTilesContainer: UIStackView!
    
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var generalCorrespondanceTile: MenuTile!
    @IBOutlet weak var quickResponseTeamTile: MenuTile!
    @IBOutlet weak var helpCenterTile: MenuTile!
    @IBOutlet weak var generalInformationCenterTile: MenuTile!
    @IBOutlet weak var landAquisitionTile: MenuTile!
    @IBOutlet weak var rightToInformationTile: MenuTile!
    @IBOutlet weak var ourOfficesTile: MenuTile!
    @IBOutlet weak var publicRelationTile: MenuTile!
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
        metroNavBar.setup(titleStr: "Customer Care".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.textColor = .black
        titleLabel.text = Globals.CC_PHONE
        
        generalCorrespondanceTile.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        generalCorrespondanceTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        quickResponseTeamTile.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        quickResponseTeamTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        helpCenterTile.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        helpCenterTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        generalInformationCenterTile.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        generalInformationCenterTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        landAquisitionTile.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        landAquisitionTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        rightToInformationTile.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        rightToInformationTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        ourOfficesTile.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        ourOfficesTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        publicRelationTile.setup(font: UIFont(name: "Roboto-Regular", size: 15)!, titleColor: CustomColors.COLOR_DARK_GRAY)
        publicRelationTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tileTap)))
        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContactTileTap)))
        phoneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContactTileTap)))
        phoneIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContactTileTap)))
    }
    func prepareViewModel() {
        
    }
    @objc func onContactTileTap(_ sender: UITapGestureRecognizer? = nil) {
            callToNumber(phoneNumber: "18002705501")
    }
    private func callToNumber(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        } else {
            MLog.log(string: "Cannot Call:", phoneNumber)
        }
    }
    @objc func tileTap(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case generalCorrespondanceTile:
            MLog.log(string: "General Currospondance Tap")
            goToGeneralCorrespondance()
        case quickResponseTeamTile:
            MLog.log(string: "Quick Response Tap")
            goToQuickResponseTeam()
        case helpCenterTile:
            MLog.log(string: "Help Center Tap")
            goToHelpCenter()
        case generalInformationCenterTile:
            MLog.log(string: "General Information Tap")
            goToMahitiKendra()
        case landAquisitionTile:
            MLog.log(string: "Land Aquisition Tap")
            goToLandAquisition()
        case rightToInformationTile:
            MLog.log(string: "RTI Tap")
            goToRTI()
        case ourOfficesTile:
            MLog.log(string: "Our Offices Tap")
            goToOurOffices()
        case publicRelationTile:
            MLog.log(string: "Public Relation Tap")
            goToPublicRelations()
        default:
            MLog.log(string: "Invalid CC Home tile tap")
        }
    }
    func goToGeneralCorrespondance() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cCGeneralCorrespondanceViewController = storyboard.instantiateViewController(withIdentifier: "CCGeneralCorrespondanceViewController") as! CCGeneralCorrespondanceViewController
            cCGeneralCorrespondanceViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(cCGeneralCorrespondanceViewController, animated: true)
        }
    }
    func goToQuickResponseTeam() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cCQuickResponseTeamViewController = storyboard.instantiateViewController(withIdentifier: "CCQuickResponseTeamViewController") as! CCQuickResponseTeamViewController
            cCQuickResponseTeamViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(cCQuickResponseTeamViewController, animated: true)
        }
    }
    func goToHelpCenter() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cCHelpCenterViewController = storyboard.instantiateViewController(withIdentifier: "CCHelpCenterViewController") as! CCHelpCenterViewController
            cCHelpCenterViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(cCHelpCenterViewController, animated: true)
        }
    }
    func goToLandAquisition() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cCLandAquisitionViewController = storyboard.instantiateViewController(withIdentifier: "CCLandAquisitionViewController") as! CCLandAquisitionViewController
            cCLandAquisitionViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(cCLandAquisitionViewController, animated: true)
        }
    }
    func goToRTI() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cCRTIViewController = storyboard.instantiateViewController(withIdentifier: "CCRTIViewController") as! CCRTIViewController
            cCRTIViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(cCRTIViewController, animated: true)
        }
    }
    func goToPublicRelations() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cCPublicRelationsViewController = storyboard.instantiateViewController(withIdentifier: "CCPublicRelationsViewController") as! CCPublicRelationsViewController
            cCPublicRelationsViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(cCPublicRelationsViewController, animated: true)
        }
    }
    func goToOurOffices() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cCOurOfficesViewController = storyboard.instantiateViewController(withIdentifier: "CCOurOfficesViewController") as! CCOurOfficesViewController
            cCOurOfficesViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(cCOurOfficesViewController, animated: true)
        }
    }
    func goToMahitiKendra() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cCMahitiKendraViewController = storyboard.instantiateViewController(withIdentifier: "CCMahitiKendraViewController") as! CCMahitiKendraViewController
            cCMahitiKendraViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(cCMahitiKendraViewController, animated: true)
        }
    }
    
}
