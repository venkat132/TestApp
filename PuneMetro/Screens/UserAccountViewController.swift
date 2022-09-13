//
//  UserAccountViewController.swift
//  PuneMetro
//
//  Created by Admin on 06/07/21.
//

import Foundation
import UIKit

class UserAccountViewController: UIViewController, ViewControllerLifeCycle {
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var formContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var mobileInput: UITextField!
    @IBOutlet weak var mobileValueLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderStackShadow: UIView!
    @IBOutlet weak var genderStack: UIStackView!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var transgenderView: UIView!
    @IBOutlet weak var transgenderLabel: UILabel!
    @IBOutlet weak var genderValueLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var dobContainer: UIView!
    @IBOutlet weak var dobInput: UITextField!
    @IBOutlet weak var dobValueLabel: UILabel!
    @IBOutlet weak var submitButton: FilledButton!
    @IBOutlet weak var UploadKYCButton: FilledButton!
    
    @IBOutlet weak var verifyEmailButton: UnderlineButton!
    @IBOutlet weak var verifiedImage: UIImageView!
    var viewModel = UserAccountModel()
    var selectedGender: Gender?
    // Keyboard Setup
    var originHeight: CGFloat?
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        self.tabBarController?.tabBar.isHidden = false
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
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
        self.hideKeyboardWhenTappedAround()
        if let tabBarController = tabBarController {
            scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        metroNavBar.setup(titleStr: "Account".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {
            MLog.log(string: "Back Tapped")
            self.navigationController?.popViewController(animated: true)
        }, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.textColor = .black
        titleLabel.text = LocalDataManager.dataMgr().user.name
        
        nameLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        nameLabel.text = "Name".localized(using: "Localization")
        emailLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        emailLabel.text = "Email".localized(using: "Localization")
        mobileLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        mobileLabel.text = "Mobile".localized(using: "Localization")
        genderLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        genderLabel.text = "Gender".localized(using: "Localization")
        dobLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        dobLabel.text = "Date of Birth".localized(using: "Localization")
        
        nameValueLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        emailValueLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        mobileValueLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        genderValueLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        dobValueLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        
        styleInputs()
        styleSelectionBoxes()
        
        submitButton.setColor(color: CustomColors.COLOR_DARK_BLUE)
        submitButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        submitButton.setAttributedTitle(title: NSAttributedString(string: "EDIT", attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        submitButton.onTap = submitTap
        submitButton.setEnable(enable: true)
        
        UploadKYCButton.setColor(color: CustomColors.COLOR_DARK_BLUE)
        UploadKYCButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        UploadKYCButton.setAttributedTitle(title: NSAttributedString(string: "UPLOAD KYC DOCUMENTS", attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        UploadKYCButton.onTap = UploadKYCTap
        UploadKYCButton.setEnable(enable: true)
        UploadKYCButton.isHidden = true
        
        if LocalDataManager.dataMgr().user.verifiedEmail {
            UploadKYCButton.isHidden = false
            submitButton.isHidden = true
        }
        
        if (LocalDataManager.dataMgr().user.KYCStatus == 1) || (LocalDataManager.dataMgr().user.KYCStatus == 2) {
            submitButton.isHidden = true
        }
        // hide edit for this release
        submitButton.isHidden = true
        // UploadKYCButton.isHidden = true
    }
    func prepareViewModel() {
        viewModel.didReceiveProfile = {
            self.setProfileValues()
        }
        viewModel.didChangeEdit = {
            self.setEdit()
        }
        viewModel.didInputChanged = {enable in
            self.submitButton.setEnable(enable: self.viewModel.isEdit ? enable : true)
        }
        viewModel.showError = {msg in
            self.showError(errStr: msg)
        }
        viewModel.goBack = {
            self.goBack()
        }
        viewModel.user = LocalDataManager.dataMgr().user
        viewModel.isEdit = false
        viewModel.getProfile()
    }
    func setProfileValues() {
        titleLabel.text = viewModel.user.name
        nameValueLabel.text = viewModel.user.name
        emailValueLabel.text = viewModel.user.email
        mobileValueLabel.text = viewModel.user.mobile
        genderValueLabel.text = viewModel.user.gender?.rawValue
        dobValueLabel.text = DateUtils.returnString(viewModel.user.dob)
        
        selectedGender = viewModel.user.gender
        nameInput.text = viewModel.user.name
        emailInput.text = viewModel.user.email
        mobileInput.text = viewModel.user.mobile
        dobInput.text = DateUtils.returnString(viewModel.user.dob)
        dobInput.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        setGenderSelection()
    }
    func setEdit() {
        metroNavBar.setup(titleStr: viewModel.isEdit ? "Edit Account".localized(using: "Localization") : "Account".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {
            MLog.log(string: "Back Tapped")
            self.navigationController?.popViewController(animated: true)
        }, rightImage: nil, rightTap: {})
        nameValueLabel.isHidden = viewModel.isEdit
        emailValueLabel.isHidden = viewModel.isEdit
        //verifyEmailButton.isHidden = viewModel.isEdit || LocalDataManager.dataMgr().user.verifiedEmail
        verifyEmailButton.isHidden = true //PMT-1312
        verifiedImage.isHidden = viewModel.isEdit || !LocalDataManager.dataMgr().user.verifiedEmail
        mobileValueLabel.isHidden = viewModel.isEdit
        genderValueLabel.isHidden = viewModel.isEdit
        dobValueLabel.isHidden = viewModel.isEdit
        
        nameInput.isHidden = !viewModel.isEdit
        emailInput.isHidden = !viewModel.isEdit
        mobileInput.isHidden = !viewModel.isEdit
        genderStack.isHidden = !viewModel.isEdit
        genderStackShadow.isHidden = !viewModel.isEdit
        dobContainer.isHidden = !viewModel.isEdit
        
        submitButton.setAttributedTitle(title: NSAttributedString(string: viewModel.isEdit ? "SAVE CHANGES".localized(using: "Localization") : "EDIT".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        verifyEmailButton.setAttributedTitle(title: NSAttributedString(string: "Verify".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 10)!, NSAttributedString.Key.foregroundColor: CustomColors.COLOR_DARK_GRAY]))
        // verifyEmailButton.setEnable(enable: true) //PMT-1312
        verifyEmailButton.setEnable(enable: false) //PMT-1312
        verifyEmailButton.onTap = verifyEmailTap
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
    }
    
    func styleInputs() {
        nameInput.layer.cornerRadius = 5
        nameInput.layer.borderWidth = 0.5
        nameInput.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        nameInput.attributedPlaceholder = NSAttributedString(string: "Name".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: CustomColors.COLOR_MEDIUM_GRAY, NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!])
        nameInput.addTarget(self, action: #selector(onNameInput), for: .editingChanged)
        nameInput.font = UIFont(name: "Roboto-Regular", size: 15)
        
        emailInput.layer.cornerRadius = 5
        emailInput.layer.borderWidth = 0.5
        emailInput.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        emailInput.attributedPlaceholder = NSAttributedString(string: "Email".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: CustomColors.COLOR_MEDIUM_GRAY, NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!])
        emailInput.addTarget(self, action: #selector(onEmailInput), for: .editingChanged)
        emailInput.font = UIFont(name: "Roboto-Regular", size: 15)
        
        mobileInput.layer.cornerRadius = 5
        mobileInput.layer.borderWidth = 0.5
        mobileInput.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        mobileInput.attributedPlaceholder = NSAttributedString(string: "Mobile".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: CustomColors.COLOR_MEDIUM_GRAY, NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!])
        mobileInput.addTarget(self, action: #selector(onMobileInput), for: .editingChanged)
        mobileInput.font = UIFont(name: "Roboto-Regular", size: 15)
        
        dobInput.font = UIFont(name: "Roboto-Regular", size: 15)
        dobInput.setInputViewDatePicker(target: self, selector: #selector(tapDone))
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
        viewModel.user.gender = selectedGender
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
    
    @objc func onNameInput(_ sender: UITextField) {
        MLog.log(string: "Name Input", sender.text)
        viewModel.user.name = sender.text!
    }
    
    @objc func onEmailInput(_ sender: UITextField) {
        MLog.log(string: "Email Input", sender.text)
        viewModel.user.email = sender.text!
    }
    @objc func onMobileInput(_ sender: UITextField) {
        MLog.log(string: "Mobile Input", sender.text)
        viewModel.user.mobile = sender.text!
    }
    @objc func tapDone() {
        if let datePicker = self.dobInput.inputView as? UIDatePicker { // 2-1
            dobInput.text = DateUtils.returnString(datePicker.date)
            self.viewModel.dobDate = "\(datePicker.date.get(.day))"
            self.viewModel.dobMonth = "\(Globals.MONTHS[datePicker.date.get(.month) - 1])"
            self.viewModel.dobYear = "\(datePicker.date.get(.year))"
        }
        self.dobInput.resignFirstResponder() // 2
    }
    
    func submitTap() {
        if viewModel.isEdit {
            viewModel.updateProfile()
        } else {
            viewModel.isEdit = true
        }
    }
    func UploadKYCTap() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let kYCViewController = storyboard.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
            kYCViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.navigationController?.pushViewController(kYCViewController, animated: true)
        })
    }
    
    func verifyEmailTap() {
        MLog.log(string: "Verify Email Tapped")
        viewModel.sendVerifyEmail()
    }
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
