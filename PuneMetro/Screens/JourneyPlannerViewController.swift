//
//  JourneyPlannerViewController.swift
//  PuneMetro
//
//  Created by Admin on 12/10/21.
//

import Foundation
import UIKit
import DropDown

class JourneyPlannerViewController: UIViewController, ViewControllerLifeCycle, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var JourneyPlannerView: JourneyPlanner!
    @IBOutlet weak var PastJourneyTableview: UITableView!
    @IBOutlet weak var tableheight: NSLayoutConstraint!
    let count = 122
    
    var fromStnDropdown = DropDown()
    var toStnDropdown = DropDown()
    var viewModel = FeederServicesModel()
    var journeyPlannerModel = JourneyPlannerModel()
    
    var fromStnNames: [String] = []
    var toStnNames: [String] = []
    var fromLatLong: String = ""
    var toLatLong: String = ""
    var uuidStr: String = ""
    // var SuggestPlaces = [[AnyHashable: Any]]()
    
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    
    func prepareUI() {
        metroNavBar.setup(titleStr: "Journey Planner".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.text = "Where are you going?".localized(using: "Localization")
        titleLabel.textColor = .black
        if let tabBarController = tabBarController {
            scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        
        JourneyPlannerView.setup()
        prepareJourneyPlannerView()
                
    }
    func prepareViewModel() {
        
//        viewModel.goToHome = {
//            self.goToHome()
//        }
        viewModel.onCategoryChange = {
            MLog.log(string: "Services Found:", self.viewModel.filteredFeederServices.count)
            self.tableheight.constant = CGFloat(self.viewModel.filteredFeederServices.count * self.count)
            self.PastJourneyTableview.reloadData()
        }
        viewModel.loadServices()
        
        journeyPlannerModel.didReveivePlace = {PlaceSuggestions in
            MLog.log(string: "Place Found:", PlaceSuggestions)
//            MLog.log(string: "Place Found:", self.journeyPlannerModel.SuggestPlaces)
            if self.JourneyPlannerView.fromTextfield.isFirstResponder {
                self.fromStnNames = []
                for place in PlaceSuggestions {
                    self.fromStnNames.append(place["description"] as! String)
                }
                self.prepareFromPlaceDropdown()
                self.fromStnDropdown.show()
            } else {
                self.toStnNames = []
                for place in PlaceSuggestions {
                    self.toStnNames.append(place["description"] as! String)
                }
                self.prepareToPlaceDropdown()
                self.toStnDropdown.show()
            }
            self.GetUUIDToken()
        }
        journeyPlannerModel.didReveivePlaceDetails = { Lat, Long, namePlace in
            MLog.log(string: "Place lat long:", namePlace, Lat, Long)
            if self.JourneyPlannerView.fromTextfield.isFirstResponder {
                self.fromLatLong = Lat + "," + Long + "," + namePlace
            } else {
                self.toLatLong = Lat + "," + Long + "," + namePlace
            }
            if !self.fromLatLong.isEmpty &&  !self.toLatLong.isEmpty {
                self.JourneyPlannerView.submitButton.setEnable(enable: true)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        GetUUIDToken()
    }
    func GetUUIDToken() {
        self.uuidStr = NSUUID().uuidString
        MLog.log(string: "uuid:", uuidStr)
    }
    func prepareFromPlaceDropdown() {
        fromStnDropdown.dataSource = self.fromStnNames
        fromStnDropdown.anchorView = JourneyPlannerView.fromTextfield
        fromStnDropdown.direction = .bottom
        fromStnDropdown.backgroundColor = UIColor.white
        fromStnDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        fromStnDropdown.bottomOffset = CGPoint(x: 0, y: 30)
        fromStnDropdown.selectionAction = { index, item in
            self.JourneyPlannerView.fromTextfield.text = item
            let Place = self.journeyPlannerModel.SuggestPlaces[index]
            MLog.log(string: "Place id:", Place["idPlace"])
            self.journeyPlannerModel.GetPlaceDetails(PlaceId: Place["idPlace"] as! String, UUID: self.uuidStr)
        }
        
    }
    func prepareToPlaceDropdown() {
        toStnDropdown.dataSource = self.toStnNames
        toStnDropdown.anchorView = JourneyPlannerView.destinationLabel
        toStnDropdown.direction = .top
        toStnDropdown.backgroundColor = UIColor.white
        toStnDropdown.textColor = CustomColors.COLOR_MEDIUM_GRAY
        toStnDropdown.bottomOffset = CGPoint(x: 0, y: 0)
        toStnDropdown.selectionAction = { index, item in
            self.JourneyPlannerView.toTextfield.text = item
            let Place = self.journeyPlannerModel.SuggestPlaces[index]
            MLog.log(string: "Place id:", Place["idPlace"])
            self.journeyPlannerModel.GetPlaceDetails(PlaceId: Place["idPlace"] as! String, UUID: self.uuidStr)
        }
        
    }
    func prepareJourneyPlannerView() {
        
        JourneyPlannerView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
        JourneyPlannerView.layer.borderWidth = 1
        
        JourneyPlannerView.originLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        JourneyPlannerView.originLabel.text = "From Station".localized(using: "Localization")
        JourneyPlannerView.originLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        // JourneyPlannerView.originValueLabel.addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(fromStnTap))))
        
        JourneyPlannerView.destinationLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        JourneyPlannerView.destinationLabel.text = "To Station".localized(using: "Localization")
        JourneyPlannerView.destinationLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        // JourneyPlannerView.destinationValueLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toStnTap)))
        
        JourneyPlannerView.submitButton.titleLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        JourneyPlannerView.submitButton.setAttributedTitle(title: NSAttributedString(string: "PLAN MY JOURNEY".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        JourneyPlannerView.submitButton.onTap = PlanJourneyTap
        JourneyPlannerView.submitButton.setEnable(enable: false)

        JourneyPlannerView.fromTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        JourneyPlannerView.fromTextfield.attributedPlaceholder = NSAttributedString(string: "Type 3 or more characters".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: CustomColors.COLOR_MEDIUM_GRAY, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 18)!])
        JourneyPlannerView.fromTextfield.font = UIFont(name: "Roboto-Regular", size: 18)
        JourneyPlannerView.fromTextfield.delegate = self
        
        JourneyPlannerView.toTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        JourneyPlannerView.toTextfield.attributedPlaceholder = NSAttributedString(string: "Type 3 or more characters".localized(using: "Localization"), attributes: [NSAttributedString.Key.foregroundColor: CustomColors.COLOR_MEDIUM_GRAY, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 18)!])
        JourneyPlannerView.toTextfield.font = UIFont(name: "Roboto-Regular", size: 18)
        JourneyPlannerView.toTextfield.delegate = self
    }
    @objc func PlanJourneyTap() {
        if self.fromLatLong.isEmpty &&  self.toLatLong.isEmpty {
            self.showError(errStr: "Select station".localized(using: "Localization"))
            return
        }
        MLog.log(string: "From To Latlong:", self.fromLatLong, self.toLatLong)
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let journeyResultVC = storyboard.instantiateViewController(withIdentifier: "JourneyResultViewController") as! JourneyResultViewController
            journeyResultVC.modalPresentationStyle = .fullScreen
            journeyResultVC.fromPlaceLatLong = self.fromLatLong
            journeyResultVC.toPlaceLatLong = self.toLatLong
            self.navigationController?.pushViewController(journeyResultVC, animated: true)
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let currentString: NSString = (textField.text ?? "") as NSString
        if currentString.length > 3 {
            MLog.log(string: currentString)
            if textField == JourneyPlannerView.fromTextfield {
                journeyPlannerModel.GetPlaceSuggestions(SearchStr: currentString as String, UUID: self.uuidStr)
            }
            if textField == JourneyPlannerView.toTextfield {
                journeyPlannerModel.GetPlaceSuggestions(SearchStr: currentString as String, UUID: self.uuidStr)
            }
        } else {
            self.fromStnDropdown.hide()
            self.toStnDropdown.hide()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredFeederServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JourneyPlannerTableCell", for: indexPath) as! JourneyPlannerTableCell
//        let service = viewModel.filteredFeederServices[indexPath.row]

        cell.DateLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        cell.DateLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        cell.FromLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        cell.FromLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        cell.FromValueLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        cell.FromValueLabel.textColor = .black
        
        cell.ToLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        cell.ToLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        cell.ToValueLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        cell.ToValueLabel.textColor = .black

        // cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onServiceTap)))
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let Headerlabel = UILabel()
            Headerlabel.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-20)
            Headerlabel.text = "My Past Journey Plans".localized(using: "Localization")
            Headerlabel.font = UIFont(name: "Roboto-Medium", size: 18)
            Headerlabel.textColor = .black
            headerView.addSubview(Headerlabel)
            
            return headerView
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class JourneyPlannerTableCell: UITableViewCell {
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var FromLabel: UILabel!
    @IBOutlet weak var ToLabel: UILabel!
    @IBOutlet weak var FromValueLabel: UILabel!
    @IBOutlet weak var ToValueLabel: UILabel!
    @IBOutlet weak var FromToImage: UIImageView!
    
}
