//
//  PlacesListViewController.swift
//  PuneMetro
//
//  Created by Admin on 12/05/21.
//

import Foundation
import UIKit
class PlacesListViewController: UIViewController, ViewControllerLifeCycle, UITableViewDelegate, UITableViewDataSource, DesignableTextFieldDelegate {
    
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var nextTripContainer: UIView!
    @IBOutlet weak var nextTripLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchField: DesignableTextField!
    @IBOutlet weak var placesTableView: UITableView!
    
    let reusableIdentifier = "PlacesTableCell"
    var viewModel = PlacesListModel()
    
    var originHeight: CGFloat?
    
    // Keyboard Setup
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        if self.navigationController is HomeNavigationController {
            let nav = self.navigationController as! HomeNavigationController
            nav.titleText!.text = "Explore Pune!"
        }
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
//                self.scrollView.scrollToView(view: self.view.firstResponder!, animated: true)
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
//                self.scrollView.scrollToView(view: self.view.firstResponder!, animated: true)
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
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func prepareViewModel() {
        viewModel.didChangeData = {
            MLog.log(string: "Loading Data:", self.viewModel.places.count)
            self.placesTableView.reloadData()
        }
        viewModel.searchString = ""
    }
    
    func prepareUI() {
        self.hideKeyboardWhenTappedAround()
//        self.navigationItem.hidesBackButton = false
        if let tabBarController = tabBarController {
            placesTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        metroNavBar.setup(titleStr: "Explore Pune".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        nextTripLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        nextTripLabel.textColor = UIColor.black
        nextTripLabel.text = "Where is your next trip?".localized(using: "Localization")
        placesTableView.delegate = self
        placesTableView.dataSource = self
        
        searchField.tintColor = CustomColors.COLOR_DARK_GRAY
        searchField.color = CustomColors.COLOR_DARK_GRAY
        searchField.textColor = CustomColors.COLOR_DARK_GRAY
        searchField.placeholder = "Search".localized(using: "Localization")
        searchField.leadingImage = UIImage(named: "asset-search")?.withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
        searchField.font = UIFont(name: "Roboto-Regular", size: 15)
        searchField.addTarget(self, action: #selector(searchTyped), for: .editingChanged)
        searchField.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! PlacesTableCell
        let place = viewModel.places[indexPath.row]
        
        cell.placeName.font = UIFont(name: "Roboto-Medium", size: 18)
        cell.placeName.text = place.title.localized(using: "Localization")
        
        cell.placeImage.image = UIImage(named: place.imageUrl)
        
        if cell.backgroundLayer == nil {
            cell.backgroundLayer = ImageOverlay().gl
            cell.backgroundLayer!.frame = view.frame
            cell.overlay.layer.insertSublayer(cell.backgroundLayer!, at: 0)
            cell.overlay.clipsToBounds = true
        }
        cell.backgroundColor = .clear
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(placeTapped)))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width * 180 / 300
    }
    
    @objc func searchTyped(_ sender: DesignableTextField) {
        MLog.log(string: "Search Typed", sender.text)
        viewModel.searchString = sender.text ?? ""
    }
    func textFieldIconClicked(btn: UIButton) {
        viewModel.searchString = searchField.text ?? ""
    }
    
    @objc func placeTapped(_ sender: UITapGestureRecognizer) {
        let indexPath = self.placesTableView.indexPath(for: sender.view as! PlacesTableCell)
        let place = viewModel.places[indexPath!.row]
        
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let placeDetailsViewController = storyboard.instantiateViewController(withIdentifier: "PlaceDetailsViewController") as! PlaceDetailsViewController
            placeDetailsViewController.modalPresentationStyle = .fullScreen
            placeDetailsViewController.place = place
            self.navigationController?.pushViewController(placeDetailsViewController, animated: true)
        }
    }
    
}

class PlacesTableCell: UITableViewCell {
    
    @IBOutlet weak var cardView: ShadowView!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var placeName: UILabel!
    var backgroundLayer: CALayer?
    
}
