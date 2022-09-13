//
//  LostAndFoundViewController.swift
//  PuneMetro
//
//  Created by Admin on 14/12/21.
//

import UIKit
import DropDown

class GrievancesViewController: UIViewController, ViewControllerLifeCycle, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var tabsStack: UIStackView!
    @IBOutlet weak var activeTab: UIView!
    @IBOutlet weak var activeTabLabel: UILabel!
    @IBOutlet weak var activeTabBottomLine: UIView!
    
    @IBOutlet weak var pastTab: UIView!
    @IBOutlet weak var pastTabLabel: UILabel!
    @IBOutlet weak var pastTabBottomLine: UIView!

    @IBOutlet weak var stationNumberView: UIView!
    @IBOutlet weak var stationNumberBtn: UIButton!
    @IBOutlet weak var statiounNmberArrowImage: UIImageView!

    @IBOutlet weak var ticketIdOrPaymentRefIdText: UITextField!
    
    @IBOutlet weak var descriptionView: UITextView!
    
    @IBOutlet weak var submitBtn: FilledButton!
    
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var attachmetText: UIButton!
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLbl: UILabel!
    
    var selection: GrievancesTabSelection = .create
    var imagePicker: UIImagePickerController!
    
    var isUploading: Bool = false
    
    var viewModel = LostAndFoundModel()
    var bookinngViewModel = BookingModel()
    var allStnNames: [Station] = []
    var fromStnDropdown = DropDown()
    var selectedImage: UIImage!
    var strLost = ""
    var strStatioNName = ""
    var strArticalDec = ""
    var strTicketID = ""
    var strDec = ""
    override func viewDidLoad() {
        prepareUI()
        prepareViewModel()
        prepareBookingViewModel()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func prepareViewModel() {
        var idUser = ""
        let defaults: UserDefaults = UserDefaults.standard
        do {
         idUser = try (StorageUtils.decryptData(data: defaults.data(forKey: metroUserIDKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "0")
        }
        catch let error {
            MLog.log(string: "Defaults Parsing", error.localizedDescription)
        }
        viewModel.fetchTicketGrievances(id: idUser)
        viewModel.didGetTicketGrievances = {
            DispatchQueue.main.async {
                if !(self.viewModel.ticketGrievance.isEmpty) {
                    self.tableview.reloadData()
                }
            }
        }
        viewModel.goToHome = {
            self.loaderView.isHidden = true
            self.indicator.stopAnimating()
            let alert = UIAlertController(title: "Grievances".localized(using: "Localization"), message: "Reported Successfully", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func prepareUI() {
        metroNavBar.setup(titleStr: "Ticket Grievances".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})

        activeTabLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        activeTabLabel.text = "Create".localized(using: "Localization")
        activeTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSelectionTab)))
        pastTabLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        pastTabLabel.text = "Status".localized(using: "Localization")
        pastTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSelectionTab)))
        
        activeTab.layer.cornerRadius = 10
        activeTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        activeTab.layer.borderWidth = 0
        activeTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        
        pastTab.layer.cornerRadius = 10
        pastTab.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        pastTab.layer.borderWidth = 0
        pastTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
      
//        stationNumberView.layer.cornerRadius = 5
//        stationNumberView.layer.borderWidth = 0.5
//        stationNumberView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        
        stationNumberBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        stationNumberBtn.setTitle("Select Station Name*".localized(using: "Localization"), for: UIControl.State.normal)
        stationNumberBtn.setTitleColor(UIColor.darkGray, for: .normal)
        stationNumberBtn.tag = 2
        stationNumberBtn.addTarget(self, action: #selector(stationNamebuttonTapped), for: .touchUpInside)
        
        descriptionView.font = UIFont(name: "Roboto-Regular", size: 15)
        descriptionView.text = "Description*".localized(using: "Localization")
        descriptionView.textColor = UIColor.darkGray
        descriptionView.delegate = self
        descriptionView.attributedText =  NSAttributedString(string: "Description*".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15)!])
        
        ticketIdOrPaymentRefIdText.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        ticketIdOrPaymentRefIdText.font = UIFont(name: "Roboto-Medium", size: 15)
        ticketIdOrPaymentRefIdText.attributedPlaceholder = NSAttributedString(string: "Ticket ID/Payment Ref ID*".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15)!])
        ticketIdOrPaymentRefIdText.typingAttributes![NSAttributedString.Key.foregroundColor] =
            UIColor.darkGray
        ticketIdOrPaymentRefIdText.delegate = self
       // locatioTextField.text = mobileNumber
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
       // descriptionView.clipsToBounds = true
        descriptionView.layer.shadowOpacity=0.4
        descriptionView.layer.shadowOffset = CGSize(width: 3, height: 3)
        descriptionView.layer.masksToBounds = true
        descriptionView.backgroundColor = CustomColors.COLOR_WHITE
        descriptionView.showsVerticalScrollIndicator = true
        submitBtn.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        submitBtn.setAttributedTitle(title: NSAttributedString(string: "SUBMIT".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        submitBtn.onTap = SubmitTapped
        submitBtn.setEnable(enable: true)
        attachmetText.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        attachmetText.setTitleColor(UIColor.darkGray, for: .normal)
        loaderView.backgroundColor = UIColor.white
        loaderView.isHidden = false
        isUploading = false
        isUploading = false
        setSelection()
        
    }
    @objc func stationNamebuttonTapped() {
        MLog.log(string: "station names Dropdown", fromStnDropdown.show())
    }
    func prepareBookingViewModel() {
            if self.stationNumberBtn.currentTitle! != "" {
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
//                    self.stationNumberBtn.setTitle(stn.name, for: .normal)
//                }
            }
            prepareFromDropdown()
        }
        if shouldFetchStations {
            bookinngViewModel.fetchStations()
        }
    }
    
    func prepareFromDropdown() {
        fromStnDropdown.dataSource = allStnNames.map({$0.name})
        fromStnDropdown.anchorView = stationNumberBtn
        fromStnDropdown.direction = .bottom
        fromStnDropdown.backgroundColor = UIColor.white
        fromStnDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        fromStnDropdown.bottomOffset = CGPoint(x: 0, y: 0)
        
        fromStnDropdown.selectionAction = { index, item in
            print(index)
            self.strStatioNName = item
            if self.strDec != "" && self.strDec.isBlank == false && self.strStatioNName != "" && self.strStatioNName.isBlank == false && self.strTicketID != "" && self.strTicketID.isBlank == false {
                self.submitBtn.setEnable(enable: true)
            }
            self.stationNumberBtn.setTitle(item, for: .normal)
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == ticketIdOrPaymentRefIdText {
            self.strTicketID = textField.text!
            if self.strDec != "" && self.strDec.isBlank == false && self.strStatioNName != "" && self.strStatioNName.isBlank == false && self.strTicketID != "" && self.strTicketID.isBlank == false {
                self.submitBtn.setEnable(enable: true)
            }
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
        if self.strDec != "" && self.strDec.isBlank == false && self.strStatioNName != "" && self.strStatioNName.isBlank == false && self.strTicketID != "" && self.strTicketID.isBlank == false {
            self.submitBtn.setEnable(enable: true)
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        self.strDec = textView.text
    }
    func setSelection() {
        switch selection {
        case .create:
            backView.isHidden = false
            tableview.isHidden = true
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
        case .status:
            backView.isHidden = true
            tableview.isHidden = false
            tableview.reloadData()
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
            selection = .create
        case pastTab:
            selection = .status
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
    
    @objc func SubmitTapped() {
        if self.strStatioNName == "" || self.strStatioNName.isBlank == true {
            self.showError(errStr: "StationName is empty!")
            return
            
        } else if self.strTicketID == "" || self.strTicketID.isBlank == true {
            self.showError(errStr: "Ticket ID/Payment ID is empty!")
            return
        } else if self.strDec == "" || self.strDec.isBlank == true {
            self.showError(errStr: "Description is empty!")
            return
        }
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
        var idUser = ""
        let defaults: UserDefaults = UserDefaults.standard
        do {
         idUser = try (StorageUtils.decryptData(data: defaults.data(forKey: metroUserIDKey)!, keyData: metroEncryptionKey.data(using: String.Encoding.utf8) ?? Data()) ?? "0") }
        catch let error {
            MLog.log(string: "Defaults Parsing", error.localizedDescription)
        }
        let params = [ "idUser": "\(idUser)",
                       "stationName": self.strStatioNName.removeWhiteSpaces(),
                       "location": "",
                       "description": self.strDec.removeWhiteSpaces(),
                       "sourceType": "COMPLAINT",
                       "articleDescription": "",
                       "ticketSerialNumber": self.strTicketID.removeWhiteSpaces()
                                ]
        if selectedImage == nil {
            MLog.log(string: "Image not available!")
            viewModel.ProcessImageUpload(parameters: params, Image: UIImage(), From: UrlsManager.API_LOSTNDFOUND_MULTIPART)
        } else {
            viewModel.ProcessImageUpload(parameters: params, Image: selectedImage!, From: UrlsManager.API_LOSTNDFOUND_MULTIPART)
        }
        
    }

}
extension GrievancesViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
//        Image Upload        
       // selectedPhoto.image = selectedImage
        
        // self.ShowLoadingLbl()
       
        // viewModel.ProcessImageUpload(KYC_Type: KycType, Image_Name: "User_\(KycType).png", Image: selectedImage)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
enum GrievancesTabSelection {
        case create
        case status
}
extension GrievancesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.ticketGrievance.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketGrievannceCell", for: indexPath) as! TicketGrievannceCell
        cell.backView.backgroundColor = .white
        let service = viewModel.ticketGrievance[indexPath.row]

        cell.ticketIdLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        cell.ticketIdLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.ticketIdLabel.text = service.ticketID
        
        cell.remarkLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        cell.remarkLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.remarkLabel.text = service.stationName
        
        cell.issueDescriptioLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        cell.issueDescriptioLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.issueDescriptioLabel.text = service.description
        
        cell.ticketRefId.font = UIFont(name: "Roboto-Medium", size: 16)
        cell.ticketRefId.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.ticketRefId.text = service.ticketSerialNumber
        
       
        cell.strTicketId.font = UIFont(name: "Roboto-Regular", size: 16)
        cell.strTicketId.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.strRemarks.font = UIFont(name: "Roboto-Regular", size: 16)
        cell.strRemarks.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.strIssueDesc.font = UIFont(name: "Roboto-Regular", size: 16)
        cell.strIssueDesc.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.strTicketRefId.font = UIFont(name: "Roboto-Regular", size: 16)
        cell.strTicketRefId.textColor = CustomColors.COLOR_MEDIUM_GRAY
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LostAndFoundVC = storyboard.instantiateViewController(withIdentifier: "LostAndFoudDetailsViewController") as! LostAndFoudDetailsViewController
        LostAndFoundVC.ticketGrievance = viewModel.ticketGrievance[indexPath.row]
        LostAndFoundVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(LostAndFoundVC, animated: true)
    }
}

class TicketGrievannceCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var ticketIdLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var issueDescriptioLabel: UILabel!
    
    @IBOutlet weak var strTicketId: UILabel!
    @IBOutlet weak var strRemarks: UILabel!
    @IBOutlet weak var strIssueDesc: UILabel!
    
    @IBOutlet weak var ticketRefId: UILabel!
    @IBOutlet weak var strTicketRefId: UILabel!
}
extension GrievancesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
