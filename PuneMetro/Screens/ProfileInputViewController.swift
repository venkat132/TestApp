//
//  ProfileInputViewController.swift
//  PuneMetro
//
//  Created by Admin on 18/05/21.
//

import Foundation
import UIKit
import DropDown
import Localize_Swift
import SimpleCheckbox
import ActiveLabel
class ProfileInputViewController: UIViewController, ViewControllerLifeCycle, UITextFieldDelegate {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var bottomBg: UIView!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var loader: UIView!
    
    @IBOutlet weak var kycLabel: UILabel!
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderStack: UIStackView!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var transgenderView: UIView!
    @IBOutlet weak var transgenderLabel: UILabel!
    @IBOutlet weak var DOBLabel: UILabel!
    @IBOutlet weak var DOBStack: UIStackView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dobContainer: UIView!
    @IBOutlet weak var dobValueField: UITextField!
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageStack: UIStackView!
    @IBOutlet weak var marathiView: UIView!
    @IBOutlet weak var marathiLabel: UILabel!
    @IBOutlet weak var hindiView: UIView!
    @IBOutlet weak var hindiLabel: UILabel!
    @IBOutlet weak var englishView: UIView!
    @IBOutlet weak var englishLabel: UILabel!
    
    @IBOutlet weak var checkBoxTitle: ActiveLabel!
    @IBOutlet weak var checkBox: Checkbox!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var submitButton: FilledButton!
    
    let datePicker = UIDatePicker()
    
    var dobDateDropdown = DropDown()
    var dobMonthDropdown = DropDown()
    var dobYearDropdown = DropDown()
    
    var selectedGender: Gender?
    var selectedLanguage: Language?
    var isRegistration: Bool = false
    
    var viewModel = UserProfileInputModel()
    var campaignOpted: String = ""
    // Keyboard Setup
    var originHeight: CGFloat?
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
            if self.view.firstResponder is UITextField {
                MLog.log(string: "UITextField Focused:", self.view.firstResponder)
                                self.scrollView.scrollToView(view: self.view.firstResponder!, animated: true)
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
                                self.scrollView.scrollToView(view: self.view.firstResponder!, animated: true)
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
            MLog.log(string: "Origin on Keyboard Disappear", self.view.frame)
        }
    }
    override func viewDidLoad() {
        prepareUI()
        prepareViewModel()
        super.viewDidLoad()
    }
    
    func prepareUI() {
        self.hideKeyboardWhenTappedAround()
        UIApplication.shared.statusBarUIView!.backgroundColor = CustomColors.TOP_BAR_GRADIENT_TOP
        metroNavBar.setup(titleStr: "Register".localized(using: "Localization"), leftImage: nil, leftTap: {}, rightImage: nil, rightTap: {})
        kycLabel.font = UIFont(name: "Roboto-Regular", size: 28)
        kycLabel.text = "KYC".localized(using: "Localization")
        loader.backgroundColor = CustomColors.LOADER_BG
        copyrightLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        copyrightLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        let currentYear = LocalDataManager.dataMgr().getCurrentYear()
        copyrightLabel.text = "© Pune Metro".localized(using: "Localization") + currentYear
        infoIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAlert)))
        styleInputs()
        
        styleSelectionBoxes()
        selectedLanguage = LocalDataManager.dataMgr().userLanguage
        setLanguageSelection()
        submitButton.setColor(color: CustomColors.COLOR_DARK_BLUE)
        submitButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        submitButton.setAttributedTitle(title: NSAttributedString(string: "NEXT".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        submitButton.onTap = submitTap
        submitButton.setEnable(enable: false)
        DOBStack.isHidden = true
        dobValueField.font = UIFont(name: "Roboto-Regular", size: 15)
        dobValueField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
//        showDatePicker()
//        prepareDOBDropdowns()
        checkBoxTitle.font = UIFont(name: "Roboto-Regular", size: 12)
        checkBoxTitle.text = "Allow app to share newsletters and promotions.".localized(using: "Localization")
        checkBox.layer.cornerRadius = 3
        checkBox.checkmarkStyle = .tick
        checkBox.checkboxFillColor = UIColor.clear
        checkBox.checkmarkColor = CustomColors.COLOR_ORANGE
        checkBox.checkedBorderColor = CustomColors.COLOR_ORANGE
        checkBox.uncheckedBorderColor = UIColor.gray
        checkBox.addTarget(self, action: #selector(checkToggle), for: .valueChanged)
        checkBoxTitle.textColor = UIColor.gray
        checkBoxTitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(infoTap)))
    }
    @objc func checkToggle(sender: Checkbox) {
        campaignOpted = sender.isChecked == true ? "1" : "0"
    }
    @objc func infoTap(_ sender: UITapGestureRecognizer) {
        checkBox.isChecked = !checkBox.isChecked
        checkToggle(sender: checkBox)
    }
    func prepareViewModel() {
        viewModel.didInputChanged = { enable in
            self.submitButton.setEnable(enable: enable)
        }
        
        viewModel.showError = { err in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.view.endEditing(true)
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showError(errStr: err)
            })
            MLog.log(string: "Error:", err)
        }
        viewModel.evaluateInput()
    }
    
    func styleSelectionBoxes() {
        genderLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        genderLabel.text = "Gender".localized(using: "Localization")
        genderStack.layer.cornerRadius = 5
        genderStack.layer.borderWidth = 0.5
        genderStack.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        maleLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        maleLabel.text = "Male".localized(using: "Localization")
        femaleLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        femaleLabel.text = "Female".localized(using: "Localization")
        femaleView.layer.borderWidth = 0.5
        femaleView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        transgenderLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        transgenderLabel.text = "Transgender".localized(using: "Localization")
        
        maleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGenderSelect)))
        femaleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGenderSelect)))
        transgenderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGenderSelect)))
        
        DOBLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        DOBLabel.text = "Date of Birth".localized(using: "Localization")
        DOBStack.layer.cornerRadius = 5
        DOBStack.layer.borderWidth = 0.5
        DOBStack.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        dateLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        monthLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        monthView.layer.borderWidth = 0.5
        monthView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        yearLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        dateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dobTapped)))
        monthView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dobTapped)))
        yearView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dobTapped)))
        
        languageLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        languageLabel.text = "Select Language".localized(using: "Localization")
        languageStack.layer.cornerRadius = 5
        languageStack.layer.borderWidth = 0.5
        languageStack.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        marathiLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        hindiLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        hindiView.layer.borderWidth = 0.5
        hindiView.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        englishLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        
        marathiView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLanguageSelect)))
        hindiView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLanguageSelect)))
        englishView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLanguageSelect)))
    }
    
    func styleInputs() {
        nameInput.layer.cornerRadius = 5
        nameInput.layer.borderWidth = 0.5
        nameInput.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        nameInput.attributedPlaceholder = NSAttributedString(string: "Name".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: CustomColors.COLOR_MEDIUM_GRAY, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15)!])
        nameInput.addTarget(self, action: #selector(onNameInput), for: .editingChanged)
        nameInput.delegate = self
        
        emailInput.layer.cornerRadius = 5
        emailInput.layer.borderWidth = 0.5
        emailInput.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        emailInput.attributedPlaceholder = NSAttributedString(string: "Email".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: CustomColors.COLOR_MEDIUM_GRAY, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15)!])
        emailInput.addTarget(self, action: #selector(onEmailInput), for: .editingChanged)
        emailInput.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.evaluateInput()
    }
    
    func prepareDOBDropdowns() {
        var datesArr: [String] = []
        for i in 1...31 {
            datesArr.append("\(i)")
        }
        
        let monthsArr: [String] = Globals.MONTHS
        
        var yearsArr: [String] = []
        
        for i in 18...100 {
            yearsArr.append("\(Calendar.current.component(.year, from: Date()) - i)")
        }
        
        dobDateDropdown.dataSource = datesArr
        dobDateDropdown.anchorView = dateView
        dobDateDropdown.direction = .bottom
        dobDateDropdown.backgroundColor = UIColor.white
        dobDateDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        dobDateDropdown.bottomOffset = CGPoint(x: 0, y: 0)
        dobDateDropdown.selectionAction = { _, item in
            self.dateLabel.text = item
            self.viewModel.dobDate = item
        }
        
        dobMonthDropdown.dataSource = monthsArr
        dobMonthDropdown.anchorView = monthView
        dobMonthDropdown.direction = .bottom
        dobMonthDropdown.backgroundColor = UIColor.white
        dobMonthDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        dobMonthDropdown.bottomOffset = CGPoint(x: 0, y: 0)
        dobMonthDropdown.selectionAction = { _, item in
            self.monthLabel.text = item
            self.viewModel.dobMonth = item
        }
        
        dobYearDropdown.dataSource = yearsArr
        dobYearDropdown.anchorView = yearView
        dobYearDropdown.direction = .bottom
        dobYearDropdown.backgroundColor = UIColor.white
        dobYearDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        dobYearDropdown.bottomOffset = CGPoint(x: 0, y: 0)
        dobYearDropdown.selectionAction = { _, item in
            self.yearLabel.text = item
            self.viewModel.dobYear = item
        }
    }
    
    func showDatePicker() {
        // Formate Date
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.tintColor = .black
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        // ToolBar
//        let toolbar = UIToolbar();
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
//
//        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
//
//        dobValueField.inputAccessoryView = toolbar
        datePicker.addTarget(self, action: #selector(datePicked), for: .editingDidEnd)
        dobValueField.inputView = datePicker
        
    }
    
    @objc func tapDone() {
        if let datePicker = self.dobValueField.inputView as? UIDatePicker { // 2-1
            dobValueField.text = DateUtils.returnString(datePicker.date)
            self.viewModel.dobDate = "\(datePicker.date.get(.day))"
            self.viewModel.dobMonth = "\(Globals.MONTHS[datePicker.date.get(.month) - 1])"
            self.viewModel.dobYear = "\(datePicker.date.get(.year))"
        }
        self.dobValueField.resignFirstResponder() // 2
    }
    
    @objc func datePicked(_ sender: UIDatePicker) {
        dobValueField.text = DateUtils.returnString(sender.date)
        self.viewModel.dobDate = "\(sender.date.get(.day))"
        self.viewModel.dobMonth = "\(Globals.MONTHS[sender.date.get(.month) - 1])"
        self.viewModel.dobYear = "\(sender.date.get(.year))"
        self.view.endEditing(true)
    }
    
    @objc func donedatePicker() {
        dobValueField.text = DateUtils.returnString(datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    func submitTap() {
        MLog.log(string: "Submit Tapped")
        let user = User()
        user.name = viewModel.name!
        user.email = viewModel.email!
        user.gender = viewModel.gender!
        user.dob = DateUtils.returnDate("\(viewModel.dobDate)-\(viewModel.dobMonth)-\(viewModel.dobYear)")!
        user.mobile = LocalDataManager.dataMgr().user.mobile
        user.campaignOpted = campaignOpted
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileConfirmViewController = storyboard.instantiateViewController(withIdentifier: "ProfileConfirmViewController") as! ProfileConfirmViewController
            profileConfirmViewController.user = user
            profileConfirmViewController.modalPresentationStyle = .fullScreen
            self.present(profileConfirmViewController, animated: true, completion: {})
        }
    }
    
    @objc func onNameInput(_ sender: UITextField) {
        MLog.log(string: "Name Input", sender.text)
        viewModel.name = sender.text
    }
    
    @objc func onEmailInput(_ sender: UITextField) {
        MLog.log(string: "Email Input", sender.text)
        viewModel.email = sender.text
    }
    
    @objc func onGenderSelect(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case maleView:
            selectedGender = .Male
        case femaleView:
            selectedGender = .Female
        case transgenderView:
            selectedGender = .Transgender
        default:
            MLog.log(string: "Invalid Selection")
        }
        viewModel.gender = selectedGender
        setGenderSelection()
    }
    
    func setGenderSelection() {
        if selectedGender == nil {
            return
        }
        switch selectedGender! {
        case .Male:
            maleView.backgroundColor = CustomColors.COLOR_ORANGE
            maleLabel.textColor = .white
            femaleView.backgroundColor = .white
            femaleLabel.textColor = CustomColors.COLOR_DARK_GRAY
            transgenderView.backgroundColor = .white
            transgenderLabel.textColor = CustomColors.COLOR_DARK_GRAY
        case .Female:
            maleView.backgroundColor = .white
            maleLabel.textColor = CustomColors.COLOR_DARK_GRAY
            femaleView.backgroundColor = CustomColors.COLOR_ORANGE
            femaleLabel.textColor = .white
            transgenderView.backgroundColor = .white
            transgenderLabel.textColor = CustomColors.COLOR_DARK_GRAY
        case .Transgender:
            maleView.backgroundColor = .white
            maleLabel.textColor = CustomColors.COLOR_DARK_GRAY
            femaleView.backgroundColor = .white
            femaleLabel.textColor = CustomColors.COLOR_DARK_GRAY
            transgenderView.backgroundColor = CustomColors.COLOR_ORANGE
            transgenderLabel.textColor = .white
        }
    }
    
    @objc func onLanguageSelect(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case marathiView:
            selectedLanguage = .marathi
        case hindiView:
            selectedLanguage = .hindi
        case englishView:
            selectedLanguage = .english
        default:
            MLog.log(string: "Invalid Selection")
        }
        LocalDataManager.dataMgr().userLanguage = selectedLanguage!
        LocalDataManager.dataMgr().saveToDefaults()
        Localize.setCurrentLanguage(LocalDataManager.dataMgr().userLanguage.localeVal())
//        setLanguageSelection()
        self.viewDidLoad()
    }
    
    func setLanguageSelection() {
        if selectedLanguage == nil {
            return
        }
        switch selectedLanguage! {
        case .marathi:
            marathiView.backgroundColor = CustomColors.COLOR_ORANGE
            marathiLabel.textColor = .white
            hindiView.backgroundColor = .white
            hindiLabel.textColor = CustomColors.COLOR_DARK_GRAY
            englishView.backgroundColor = .white
            englishLabel.textColor = CustomColors.COLOR_DARK_GRAY
        case .hindi:
            marathiView.backgroundColor = .white
            marathiLabel.textColor = CustomColors.COLOR_DARK_GRAY
            hindiView.backgroundColor = CustomColors.COLOR_ORANGE
            hindiLabel.textColor = .white
            englishView.backgroundColor = .white
            englishLabel.textColor = CustomColors.COLOR_DARK_GRAY
        case .english:
            marathiView.backgroundColor = .white
            marathiLabel.textColor = CustomColors.COLOR_DARK_GRAY
            hindiView.backgroundColor = .white
            hindiLabel.textColor = CustomColors.COLOR_DARK_GRAY
            englishView.backgroundColor = CustomColors.COLOR_ORANGE
            englishLabel.textColor = .white
        }
    }
    
    @objc func dobTapped(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case dateView:
            self.dobDateDropdown.show()
        case monthView:
            self.dobMonthDropdown.show()
        case yearView:
            self.dobYearDropdown.show()
        default:
            MLog.log(string: "Invalid Date Tap")
        }
    }
    @objc func showAlert(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            //PMT-1331 starts
            myAlert.message = "disclaimer-message".localized(using: "Localization")
            //PMT-1331 ends
            myAlert.showButton2 = false
            myAlert.showButton1 = true
            myAlert.button1Title = "CLOSE".localized(using: "Localization")
            myAlert.button1OnTap = myAlert.closeTap
            self.present(myAlert, animated: true, completion: nil)
        })
    }
}
