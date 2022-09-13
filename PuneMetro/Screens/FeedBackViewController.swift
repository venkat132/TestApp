//
//  LostAndFoundViewController.swift
//  PuneMetro
//
//  Created by Admin on 14/12/21.
//

import UIKit

class FeedBackViewController: UIViewController, ViewControllerLifeCycle, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var tabsStack: UIStackView!
    @IBOutlet weak var activeTab: UIView!
    @IBOutlet weak var activeTabLabel: UILabel!
    @IBOutlet weak var activeTabBottomLine: UIView!
    
    @IBOutlet weak var pastTab: UIView!
    @IBOutlet weak var pastTabLabel: UILabel!
    @IBOutlet weak var pastTabBottomLine: UIView!
    
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var ArrowImage: UIImageView!
    
    @IBOutlet weak var stackview: UIStackView!

    @IBOutlet weak var selectedImageBack: UIView!
    @IBOutlet weak var selectedPhoto: UIImageView!
    @IBOutlet weak var RemovePhotoBtn: UIButton!
    
    @IBOutlet weak var descBack: UIView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var selectPhotoBack: UIView!
    @IBOutlet weak var selectPhotoBtn: UIButton!
    @IBOutlet weak var cameraImage: UIImageView!
    
    @IBOutlet weak var submitBack: UIView!
    @IBOutlet weak var submitBtn: FilledButton!
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLbl: UILabel!
    
    var selection: FeedBackTabSelection = .new
    var imagePicker: UIImagePickerController!
    
    var isUploading: Bool = false
    
    var viewModel = LostAndFoundModel()
    
    override func viewDidLoad() {
        prepareUI()
        prepareViewModel()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func prepareViewModel() {
        viewModel.goToHome = {
            self.loaderView.isHidden = true
            self.indicator.stopAnimating()
            let alert = UIAlertController(title: "Feedback".localized(using: "Localization"), message: "Reported Successfully", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func prepareUI() {
        metroNavBar.setup(titleStr: "Feedback".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})

        activeTabLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        activeTabLabel.text = "New".localized(using: "Localization")
        activeTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSelectionTab)))
        pastTabLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        pastTabLabel.text = "Old".localized(using: "Localization")
        pastTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSelectionTab)))
        
        activeTab.layer.cornerRadius = 10
        activeTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        activeTab.layer.borderWidth = 0
        activeTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        
        pastTab.layer.cornerRadius = 10
        pastTab.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        pastTab.layer.borderWidth = 0
        pastTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
      
        optionView.layer.cornerRadius = 10
        optionView.layer.borderWidth = 1
        optionView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
        
        descBack.layer.cornerRadius = 10
        descBack.layer.borderWidth = 0.5
        descBack.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
        
        descriptionView.font = UIFont(name: "Roboto-Regular", size: 15)
        descriptionView.text = "Please Describe".localized(using: "Localization")
        descriptionView.textColor = UIColor.lightGray
        descriptionView.delegate = self
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        let myFirstButton = UIButton()
           myFirstButton.setTitle("Done", for: .normal)
           myFirstButton.setTitleColor(CustomColors.COLOR_DARK_BLUE, for: .normal)
           myFirstButton.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
           myFirstButton.addTarget(target, action: #selector(self.doneWithNumberPad), for: .touchUpInside)
        let sample = UIBarButtonItem(customView: myFirstButton)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        numberToolbar.setItems([flexible, sample], animated: false)
        numberToolbar.sizeToFit()
        descriptionView.inputAccessoryView = numberToolbar
        
        submitBtn.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        submitBtn.setAttributedTitle(title: NSAttributedString(string: "SUBMIT".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        submitBtn.onTap = SubmitTapped
        submitBtn.setEnable(enable: true)
        
        selectedImageBack.isHidden = true
     
        loaderView.backgroundColor = UIColor.white
        loaderView.isHidden = false
        isUploading = false
        setSelection()
        
    }
    @objc func doneWithNumberPad() {
        descriptionView.resignFirstResponder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please Describe".localized(using: "Localization")
            textView.textColor = UIColor.lightGray
        }
    }
    func setSelection() {
        switch selection {
        case .new:
            activeTab.backgroundColor = CustomColors.COLOR_ORANGE
            activeTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            activeTabLabel.textColor = .white
            activeTabBottomLine.backgroundColor = CustomColors.COLOR_ORANGE
            
            pastTab.backgroundColor = .white
            pastTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            pastTabLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            pastTabBottomLine.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
            
            if !isUploading {
                loaderView.isHidden = true
                loadingLbl.text = "Uploading.."
                indicator.startAnimating()
            } else {
                loaderView.isHidden = false
                loadingLbl.font = UIFont(name: "Roboto-Medium", size: 15)
                loadingLbl.text = "Uploading.."
                indicator.startAnimating()
            }
        case .old:
            activeTab.backgroundColor = .white
            activeTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            activeTabLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            activeTabBottomLine.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
            
            pastTab.backgroundColor = CustomColors.COLOR_ORANGE
            pastTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            pastTabLabel.textColor = .white
            pastTabBottomLine.backgroundColor = CustomColors.COLOR_ORANGE
            
            loaderView.isHidden = false
            loadingLbl.font = UIFont(name: "Roboto-Medium", size: 18)
            loadingLbl.text = "Coming Soon"
            indicator.stopAnimating()
        }
        
    }
    @objc func setSelectionTab(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case activeTab:
            selection = .new
        case pastTab:
            selection = .old
        default:
            MLog.log(string: "Invalid Selection")
        }
        setSelection()
    }

    @IBAction func TakePhotoTapped(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    return
        }
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func RemovePhotoTapped(_ sender: UIButton) {
        selectedImageBack.isHidden = true
    }
    
    @objc func SubmitTapped() {
       
        // MLog.log(string: optionBtn.titleLabel?.text)
        
        var Description = descriptionView.text
        if Description == "Please Describe".localized(using: "Localization") {
            Description = ""
        }
        
        loaderView.isHidden = false
        indicator.startAnimating()
        loadingLbl.font = UIFont(name: "Roboto-Regular", size: 15)
        loadingLbl.text = "Uploading.."
        isUploading = true
        if selectedImageBack.isHidden {
            MLog.log(string: "Image not available!")
          //  viewModel.ProcessImageUpload(Option_Type: "", Description: Description!, Image: UIImage(), From: UrlsManager.API_FEEDBACK_MULTIPART)
            
        } else {
         //   viewModel.ProcessImageUpload(Option_Type: "", Description: Description!, Image: selectedPhoto.image!, From: UrlsManager.API_FEEDBACK_MULTIPART)
        }
        
    }

}
extension FeedBackViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }

        selectedImageBack.isHidden = false
        selectedPhoto.image = selectedImage
        
        // self.ShowLoadingLbl()
       
        // viewModel.ProcessImageUpload(KYC_Type: KycType, Image_Name: "User_\(KycType).png", Image: selectedImage)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
enum FeedBackTabSelection {
        case new
        case old
}
