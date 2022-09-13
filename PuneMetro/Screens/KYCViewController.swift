//
//  KYCViewController.swift
//  PuneMetro
//
//  Created by Admin on 09/09/21.
//

import Foundation
import UIKit

class KYCViewController: UIViewController, ViewControllerLifeCycle, UINavigationControllerDelegate {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uploadDocumentsLabel: UILabel!
    @IBOutlet weak var aadharCardTile: UIView!
    @IBOutlet weak var aadharCardLogo: UIImageView!
    @IBOutlet weak var aadharCardLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var voterIdTile: UIView!
    @IBOutlet weak var voterIdLogo: UIImageView!
    @IBOutlet weak var voterIdLabel: UILabel!
    @IBOutlet weak var KYCStatusView: UIView!
    @IBOutlet weak var KYCStatusImage: UIImageView!
    @IBOutlet weak var KYCVerificationImage: UIImageView!
    @IBOutlet weak var KYCStatusLbl: UILabel!
    @IBOutlet weak var KYCVerificationLbl: UILabel!
    @IBOutlet weak var KYCVerificationFailedLbl: UILabel!
    var imagePicker: UIImagePickerController!
    var viewModel = KYCModel()
   
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    
    func prepareUI() {
        metroNavBar.setup(titleStr: "KYC".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.text = "Know Your Customer".localized(using: "Localization")
        titleLabel.textColor = .black
        
        uploadDocumentsLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        uploadDocumentsLabel.text = "Please upload documents".localized(using: "Localization")
        uploadDocumentsLabel.textColor = .black
        
        aadharCardLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        aadharCardLabel.text = "Aadhar Card".localized(using: "Localization")
        aadharCardLabel.textColor = CustomColors.COLOR_DARK_GRAY
        aadharCardLogo.tintColor = CustomColors.COLOR_DARK_GRAY
        
        orLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        orLabel.text = "OR".localized(using: "Localization")
        orLabel.textColor = CustomColors.COLOR_DARK_GRAY
        
        voterIdLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        voterIdLabel.text = "Voter ID".localized(using: "Localization")
        voterIdLabel.textColor = CustomColors.COLOR_DARK_GRAY
        voterIdLogo.tintColor = CustomColors.COLOR_DARK_GRAY
        
        KYCStatusLbl.font = UIFont(name: "Roboto-Medium", size: 18)
        KYCStatusLbl.textColor = .black
        
        KYCVerificationLbl.font = UIFont(name: "Roboto-Medium", size: 18)
        KYCVerificationLbl.textColor = .black
        
        KYCVerificationFailedLbl.font = UIFont(name: "Roboto-Medium", size: 18)
        KYCVerificationFailedLbl.textColor = .black
               
        switch LocalDataManager.dataMgr().user.KYCStatus {
        case 1:
            KYCStatusLbl.text = "KYC Completed".localized(using: "Localization")
            KYCVerificationImage.isHidden = true
        case 2:
            KYCStatusLbl.text = "Document Uploaded".localized(using: "Localization")
            KYCVerificationLbl.text = "Verification Pending".localized(using: "Localization")
        case 3:
            KYCStatusLbl.text = "Document Uploaded".localized(using: "Localization")
            KYCVerificationLbl.text = "Verification Failed".localized(using: "Localization")
            KYCVerificationFailedLbl.text = "Verification Failed".localized(using: "Localization")
            KYCVerificationFailedLbl.isHidden = false
        default:
            KYCStatusLbl.text = "Uploading document..".localized(using: "Localization")
        }
        
        if LocalDataManager.dataMgr().user.KYCStatus == 0 {
            KYCStatusView.isHidden = true
            aadharCardTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAadharTap)))
            aadharCardTile.tag = 1
            voterIdTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAadharTap)))
            voterIdTile.tag = 2
        } else {
            if LocalDataManager.dataMgr().user.KYCStatus != 3 {
                self.ShowKYCStatus()
            }
        }
        
    }
    func prepareViewModel() {
        
        viewModel.goToHome = {
            self.goToHome()
        }

    }
    func ShowKYCStatus() {
        KYCStatusView.isHidden = false
        uploadDocumentsLabel.isHidden = true
        aadharCardTile.isHidden = true
        voterIdTile.isHidden = true
        orLabel.isHidden = true
    }
    func ShowLoadingLbl() {
        KYCStatusView.isHidden = true
        aadharCardTile.isHidden = true
        voterIdTile.isHidden = true
        orLabel.isHidden = true
        uploadDocumentsLabel.text = "Uploading document..".localized(using: "Localization")
    }
    
    @objc func onAadharTap(_ sender: UITapGestureRecognizer) {
        
        if sender.view?.tag == 1 {
            MLog.log(string: "Aadhar Tapped")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                MLog.log(string: "Aadhar Processed:")
            })
        } else {
            MLog.log(string: "VoterId Tapped")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                MLog.log(string: "VoterId Processed:")
            })
        }
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    return
        }
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.view.tag = sender.view!.tag
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
        
    }
    func goToHome() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let splashViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
            splashViewController.modalPresentationStyle = .fullScreen
            self.present(splashViewController, animated: true, completion: nil)
        }
    }
}
extension KYCViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
//        Image Upload
        MLog.log(string: "Send Image To Server")
        var KycType = "aadhar"
        if picker.view.tag != 1 {
            KycType = "voterid"
        }
        self.ShowLoadingLbl()
       
        viewModel.ProcessImageUpload(KYC_Type: KycType, Image_Name: "User_\(KycType).png", Image: selectedImage)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
