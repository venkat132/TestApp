//
//  LostAndFoundViewController.swift
//  PuneMetro
//
//  Created by Admin on 14/12/21.
//

import UIKit
import DropDown

class LostAndFoundViewController: UIViewController, ViewControllerLifeCycle, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var metroNavBar: MetroNavBar!
   
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var ArrowImage: UIImageView!

    @IBOutlet weak var statioumberView: UIView!
    @IBOutlet weak var statioumberBtn: UIButton!
    @IBOutlet weak var statioumberArrowImage: UIImageView!

    @IBOutlet weak var locatioTextField: UITextField!
    @IBOutlet weak var articleTextField: UITextField!
    
    @IBOutlet weak var descriptionView: UITextView!
    
    @IBOutlet weak var submitBtn: FilledButton!
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var attachmetText: UIButton!
    
    @IBOutlet weak var scrollToView: UIScrollView!
    var selection: LostFoundTabSelection = .report
    var imagePicker: UIImagePickerController!
    
    var isUploading: Bool = false
    
    var viewModel = LostAndFoundModel()
    var bookinngViewModel = BookingModel()
    var allStnNames: [Station] = []
    var allLostNames: [String] = []
    var fromStnDropdown = DropDown()
    var lostDropdown = DropDown()
    var originHeight: CGFloat?
    var selectedImage: UIImage!
    var strLost = ""
    var strStatioNName = ""
    var strArticalDec = ""
    var strLocation = ""
    var strDec = ""
    // Keyboard Setup
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidChangeFrame(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if originHeight == nil {
                originHeight = self.view.frame.height
            } else if self.view.frame.height == originHeight {
                self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height - keyboardSize.height))
            }
            if self.view.firstResponder is UITextField || self.view.firstResponder is UITextView {
                MLog.log(string: "UITextField Focused:", self.view.firstResponder)
                self.scrollToView.scrollToView(view: self.view.firstResponder!, animated: true)
            }
        }
    }
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            MLog.log(string: "Keyboard appear Original height:", originHeight)
            MLog.log(string: "Keyboard size on Keyboard Appear", keyboardSize)
            if originHeight == nil {
                originHeight = self.view.frame.height
            } else if self.view.frame.height == originHeight {
                self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height - keyboardSize.height))
            }
            MLog.log(string: "Origin on Keyboard Appear", self.view.frame)
            MLog.log(string: "UITextField Focusing:", self.view.firstResponder)
            if self.view.firstResponder is UITextField {
                MLog.log(string: "UITextField Focused:", self.view.firstResponder)
                self.scrollToView.scrollToView(view: self.view.firstResponder!, animated: true)
            }
        }
    }
    @objc func keyboardWillDisappear(_ notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //            hideKeyboardWhenTappedAroundPlayer(remove: true);
            MLog.log(string: "Keyboard Disappear Original height:", originHeight)
            if originHeight == nil {
                self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height + keyboardSize.height))
            } else {
                self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: originHeight!))
            }
            self.layoutSubviews()
            MLog.log(string: "Origin on Keyboard Disappear", self.view.frame)
        }
    }

    override func viewDidLoad() {
        prepareUI()
        prepareViewModel()
        prepareBookingViewModel()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func prepareViewModel() {
        viewModel.goToHome = {
            self.loaderView.isHidden = true
            self.indicator.stopAnimating()
            let alert = UIAlertController(title: "Lost & Found".localized(using: "Localization"), message: "Reported Successfully", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func prepareUI() {
        scrollToView.layer.borderColor = UIColor.lightGray.cgColor
        scrollToView.layer.borderWidth = 0.5
        scrollToView.layer.cornerRadius = 10
        metroNavBar.setup(titleStr: "Lost & Found".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})

        optionBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        optionBtn.setTitle("Select Lost/Found".localized(using: "Localization"), for: UIControl.State.normal)
        optionBtn.setTitleColor(UIColor.darkGray, for: .normal)
        optionBtn.tag = 1
    
        statioumberBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        statioumberBtn.setTitle("Select Station Name*".localized(using: "Localization"), for: UIControl.State.normal)
        statioumberBtn.setTitleColor(UIColor.darkGray, for: .normal)
        statioumberBtn.tag = 2
        
        descriptionView.font = UIFont(name: "Roboto-Regular", size: 15)
        descriptionView.text = "Description*".localized(using: "Localization")
        descriptionView.textColor = UIColor.darkGray
        descriptionView.delegate = self
        descriptionView.attributedText =  NSAttributedString(string: "Description*".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15)!])
        
        locatioTextField.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        locatioTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        locatioTextField.font = UIFont(name: "Roboto-Medium", size: 15)
        locatioTextField.placeholder = "Location"
        locatioTextField.attributedPlaceholder = NSAttributedString(string: "Location".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15)!])
       // locatioTextField.text = mobileNumber
        locatioTextField.delegate = self
        locatioTextField.typingAttributes![NSAttributedString.Key.foregroundColor] =
            UIColor.darkGray
        
        articleTextField.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        articleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        articleTextField.font = UIFont(name: "Roboto-Medium", size: 15)
        articleTextField.placeholder = "Article Description*"
        articleTextField.attributedPlaceholder = NSAttributedString(string: "Article Description*".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15)!])
      //  articleTextField.text = mobileNumber
        articleTextField.delegate = self
        articleTextField.typingAttributes![NSAttributedString.Key.foregroundColor] =
            UIColor.darkGray
        
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
        descriptionView.clipsToBounds = true
        descriptionView.layer.shadowOpacity=0.4
        descriptionView.layer.shadowOffset = CGSize(width: 3, height: 3)
        descriptionView.backgroundColor = CustomColors.COLOR_WHITE
        descriptionView.layer.masksToBounds = true
        submitBtn.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        submitBtn.setAttributedTitle(title: NSAttributedString(string: "SUBMIT".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        submitBtn.onTap = SubmitTapped
        submitBtn.setEnable(enable: true)
        attachmetText.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        attachmetText.setTitleColor(UIColor.darkGray, for: .normal)
        loaderView.backgroundColor = UIColor.white
        loaderView.isHidden = true
        isUploading = false
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == articleTextField {
            self.strArticalDec = textField.text!
        }
        if textField == locatioTextField {
            self.strLocation = textField.text!
        }
        if self.strDec != "" && self.strDec.isBlank == false && self.strArticalDec != "" && self.strArticalDec.isBlank == false && self.strStatioNName != "" && self.strStatioNName.isBlank == false {
            self.submitBtn.setEnable(enable: true)
        }
    }
    @objc func doneWithNumberPad() {
        descriptionView.resignFirstResponder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        if textView.text == "Description*" {
        textView.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.strDec = textView.text
        if textView.text.isEmpty {
            textView.text = "Description*".localized(using: "Localization")
            textView.textColor = UIColor.lightGray
            self.strDec = ""
        }
        if self.strDec != "" && self.strDec.isBlank == false && self.strArticalDec != "" && self.strArticalDec.isBlank == false && self.strStatioNName != "" && self.strStatioNName.isBlank == false {
            self.submitBtn.setEnable(enable: true)
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        self.strDec = textView.text
    }
    func prepareBookingViewModel() {
        allLostNames = ["LOST", "FOUND"]
        self.prepareLostDropdown()
        if self.statioumberBtn.currentTitle! != "" {
            self.preparePrimaryTicket(shouldFetchStations: false)
        } else {
        bookinngViewModel.didStationsReceived = {
            self.allStnNames = []
                for stn in LocalDataManager.dataMgr().stations {
                    self.allStnNames.append(stn)
                }
                self.prepareFromDropdown()
        }
        }
    }
    func preparePrimaryTicket(shouldFetchStations: Bool) {
        allStnNames.removeAll()
        self.allStnNames.removeAll()
        if !LocalDataManager.dataMgr().stations.isEmpty {
            for (index, stn) in LocalDataManager.dataMgr().stations.enumerated() {
                allStnNames.append(stn)
//                if index == 0 {
//                    self.strStatioNName = stn.name
//                    self.statioumberBtn.setTitle(stn.name, for: .normal)
//                }
            }
            prepareFromDropdown()
        }
        if shouldFetchStations {
            bookinngViewModel.fetchStations()
        }
    }
    func prepareLostDropdown() {
        lostDropdown.dataSource = allLostNames
        lostDropdown.anchorView = optionBtn
        lostDropdown.direction = .bottom
        lostDropdown.backgroundColor = UIColor.white
        lostDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        lostDropdown.bottomOffset = CGPoint(x: 0, y: 0)
        
        lostDropdown.selectionAction = { index, item in
            print(index)
            self.strLost = item
            self.optionBtn.setTitle(item, for: .normal)
            if self.strDec != "" && self.strDec.isBlank == false && self.strArticalDec != "" && self.strArticalDec.isBlank == false && self.strStatioNName != "" && self.strStatioNName.isBlank == false {
                self.submitBtn.setEnable(enable: true)
                
            }
        }
    }
    func prepareFromDropdown() {
        fromStnDropdown.dataSource = allStnNames.map({$0.name})
        fromStnDropdown.anchorView = statioumberBtn
        fromStnDropdown.direction = .bottom
        fromStnDropdown.backgroundColor = UIColor.white
        fromStnDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        fromStnDropdown.bottomOffset = CGPoint(x: 0, y: 0)
        
        fromStnDropdown.selectionAction = { index, item in
            print(index)
            self.strStatioNName = item
            self.statioumberBtn.setTitle(item, for: .normal)
            if self.strDec != "" && self.strDec.isBlank == false && self.strArticalDec != "" && self.strArticalDec.isBlank == false && self.strStatioNName != "" && self.strStatioNName.isBlank == false {
                self.submitBtn.setEnable(enable: true)
            }
        }
    }
    @IBAction func OptionClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            MLog.log(string: "Lost Dropdown", lostDropdown.show())
        }
        if sender.tag == 2 {
            MLog.log(string: "station names Dropdown", fromStnDropdown.show())
        }
       /* let alert = UIAlertController(title: "Lost & Found".localized(using: "Localization"), message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Lost".localized(using: "Localization"), style: .default, handler: {_ in
                print("User click Lost button")
            if sender.tag == 2 {
                self.statioumberBtn.setTitle("Lost".localized(using: "Localization"), for: UIControl.State.normal)
            }
            if sender.tag == 1 {
            self.optionBtn.setTitle("Lost".localized(using: "Localization"), for: UIControl.State.normal)
            }
            }))
            alert.addAction(UIAlertAction(title: "Found".localized(using: "Localization"), style: .default, handler: {_ in
                print("User click Found button")
                if sender.tag == 2 {
                    self.statioumberBtn.setTitle("Found".localized(using: "Localization"), for: UIControl.State.normal)
                }
                if sender.tag == 1 {
                self.optionBtn.setTitle("Found".localized(using: "Localization"), for: UIControl.State.normal)
                }
            }))
            alert.addAction(UIAlertAction(title: "cancel".localized(using: "Localization"), style: .cancel, handler: {_ in
                print("User click cancel button")
            }))
            self.present(alert, animated: true, completion: {
                print("completion block")
            }) */
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

    @objc func SubmitTapped() {
        if self.strLost == "" || self.strLost.isBlank == true {
            self.showError(errStr: "Lost/Found is empty!")
            return
            
        } else if self.strStatioNName == "" || self.strStatioNName.isBlank == true {
            self.showError(errStr: "StationName is empty!")
            return
            
        } else if self.strArticalDec == "" || self.strArticalDec.isBlank == true {
            self.showError(errStr: "Article description is empty!")
            return
        } else if self.strDec == "" || self.strDec.isBlank == true {
            self.showError(errStr: "Description is empty!")
            return
            
        }
        
        MLog.log(string: optionBtn.titleLabel?.text)
        
        var Description = descriptionView.text
        if Description == "Describe*".localized(using: "Localization") {
            Description = ""
        }
        self.strDec = descriptionView.text
        loaderView.isHidden = false
        indicator.startAnimating()
        loadingLbl.font = UIFont(name: "Roboto-Regular", size: 15)
        loadingLbl.text = "Uploading.."
        isUploading = true
        
        // "articalDescription": self.strArticalDec
        var idUser = ""
        let defaults: UserDefaults = UserDefaults.standard
        do {
         idUser = try (StorageUtils.decryptData(data: defaults.data(forKey: metroUserIDKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "0")
        }
        catch let error {
            MLog.log(string: "Defaults Parsing", error.localizedDescription)
        }
        let params = [ "idUser": "\(idUser)",
                       "stationName": self.strStatioNName.removeWhiteSpaces(),
                       "location": self.strLocation.removeWhiteSpaces(),
                       "description": self.strDec.removeWhiteSpaces(),
                       "sourceType": self.strLost.removeWhiteSpaces(),
                       "articleDescription": self.strArticalDec.removeWhiteSpaces(),
                       "ticketSerialNumber": ""
                                ]
        if selectedImage == nil {
            MLog.log(string: "Image not available!")
            viewModel.ProcessImageUpload(parameters: params, Image: UIImage(), From: UrlsManager.API_LOSTNDFOUND_MULTIPART)
        } else {
            viewModel.ProcessImageUpload(parameters: params, Image: selectedImage!, From: UrlsManager.API_LOSTNDFOUND_MULTIPART)
        }
        
    }

}
extension LostAndFoundViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
//        Image Upload
        self.selectedImage = selectedImage
        MLog.log(string: "Send Image To Server")
        var Type = "Lost"
        if optionBtn.titleLabel?.text == "Found" {
            Type = "Found"
        }
        MLog.log(string: Type)
                
      //   self.ShowLoadingLbl()
       
         //viewModel.ProcessImageUpload(KYC_Type: Type, Image_Name: "User_\(Type).png", Image: selectedImage)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
enum LostFoundTabSelection {
        case report
        case list
}
extension LostAndFoundViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


