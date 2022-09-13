//
//  StationsListViewController.swift
//  PuneMetro
//
//  Created by Admin on 13/05/21.
//

import Foundation
import UIKit

class StationsListViewController: UIViewController, ViewControllerLifeCycle, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aquaTab: UIView!
    @IBOutlet weak var aquaLabel: UILabel!
    @IBOutlet weak var aquaBottomLine: UIView!
    @IBOutlet weak var purpleTab: UIView!
    @IBOutlet weak var purpleLabel: UILabel!
    @IBOutlet weak var purpleBottomLine: UIView!
    @IBOutlet weak var stationsTable: UITableView!
    
    let reusableIdentifierStationCell = "StationsTableCell"
    
    var selectedLine: StationLine = .aqua
    
    override func viewWillAppear(_ animated: Bool) {
        if self.navigationController is HomeNavigationController {
            let nav = self.navigationController as! HomeNavigationController
            nav.titleText!.text = "Stations"
        }
    }
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    func prepareViewModel() {
        
    }
    
    func prepareUI() {
        if let tabBarController = tabBarController {
            stationsTable.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        metroNavBar.setup(titleStr: "Stations List".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})
        
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.textColor = .black
        titleLabel.text = "Stations".localized(using: "Localization")
        
        aquaLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        aquaLabel.text = "Aqua Line".localized(using: "Localization")
        aquaTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSelectionTab)))
        purpleLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        purpleLabel.text = "Purple Line".localized(using: "Localization")
        purpleTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSelectionTab)))
        
        stationsTable.delegate = self
        stationsTable.dataSource = self
        
        aquaTab.layer.cornerRadius = 25
        aquaTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        aquaTab.layer.borderWidth = 0.5
        aquaTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        
        purpleTab.layer.cornerRadius = 25
        purpleTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        purpleTab.layer.borderWidth = 0.5
        purpleTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        
        setSelection()
        //        setSelection()
    }
    
    func setSelection() {
        switch selectedLine {
        case .aqua:
            aquaTab.backgroundColor = CustomColors.COLOR_AQUA_LINE
            aquaTab.layer.borderColor = CustomColors.COLOR_AQUA_LINE.cgColor
            aquaLabel.textColor = .white
            aquaBottomLine.backgroundColor = CustomColors.COLOR_AQUA_LINE
            
            purpleTab.backgroundColor = .white
            purpleTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            purpleLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            purpleBottomLine.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
            
        case .purple:
            aquaTab.backgroundColor = .white
            aquaTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            aquaLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            aquaBottomLine.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
            
            purpleTab.backgroundColor = CustomColors.COLOR_PURPLE_LINE
            purpleTab.layer.borderColor = CustomColors.COLOR_PURPLE_LINE.cgColor
            purpleLabel.textColor = .white
            purpleBottomLine.backgroundColor = CustomColors.COLOR_PURPLE_LINE
        case .red:
            aquaTab.backgroundColor = .white
            aquaLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            aquaBottomLine.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
            
            purpleTab.backgroundColor = CustomColors.COLOR_PURPLE_LINE
            purpleLabel.textColor = .white
            purpleBottomLine.backgroundColor = CustomColors.COLOR_PURPLE_LINE
        }
        stationsTable.reloadData()
    }
    
    @objc func setSelectionTab(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case aquaTab:
            selectedLine = .aqua
        case purpleTab:
            selectedLine = .purple
        default:
            MLog.log(string: "Invalid Selection")
        }
        setSelection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedLine {
        case .aqua:
            return LocalDataManager.dataMgr().aquaStations.count
        case .purple:
            return LocalDataManager.dataMgr().purpleStations.count
        case .red:
            return LocalDataManager.dataMgr().purpleStations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifierStationCell, for: indexPath) as! StationsTableCell
        var station = Station()
        switch selectedLine {
        case .aqua:
            station = LocalDataManager.dataMgr().aquaStations[indexPath.row]
            if indexPath.row == 0 {
                cell.lineImage.image = UIImage(named: "aqua-line-start")!
            } else {
                if LocalDataManager.dataMgr().aquaStations[indexPath.row].isJunction {
                    cell.lineImage.image = UIImage(named: "aqua-line-junction")!
                } else {
                    cell.lineImage.image = UIImage(named: "aqua-line-station")!
                }
                
            }
        case .purple:
            station = LocalDataManager.dataMgr().purpleStations[indexPath.row]
            if indexPath.row == 0 {
                cell.lineImage.image = UIImage(named: "purple-line-start")!
            } else {
                if LocalDataManager.dataMgr().purpleStations[indexPath.row].isJunction {
                    cell.lineImage.image = UIImage(named: "purple-line-junction")!
                } else {
                    cell.lineImage.image = UIImage(named: "purple-line-station")!
                }
                
            }
        case .red:
            station = LocalDataManager.dataMgr().purpleStations[indexPath.row]
            if indexPath.row == 0 {
                cell.lineImage.image = UIImage(named: "purple-line-start")!
            } else {
                if LocalDataManager.dataMgr().purpleStations[indexPath.row].isJunction {
                    cell.lineImage.image = UIImage(named: "purple-line-junction")!
                } else {
                    cell.lineImage.image = UIImage(named: "purple-line-station")!
                }
                
            }
        }
        cell.nameLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        cell.nameLabel.text = station.name.localized(using: "Localization")
        cell.nameLabel.textColor =  station.isActive == "active" ? UIColor.black.withAlphaComponent(1) : UIColor.black.withAlphaComponent(0.3)
        for view in cell.propertiesStack.subviews {
            view.removeFromSuperview()
        }
        MLog.log(string: "Properties:", cell.propertiesStack.frame.width)
        for (i, prop) in station.properties.enumerated() {
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: i * 30, y: 0), size: CGSize(width: cell.propertiesStack.frame.height, height: cell.propertiesStack.frame.height)))
            imageView.frame.size = CGSize(width: 30, height: 30)
            imageView.image = station.getStationPropertyImageNew(prop: prop)?.withAlignmentRectInsets(UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20))
            imageView.alpha = station.isActive == "active" ? 1 : 0.2
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            cell.propertiesStack.addSubview(imageView)
        }
        cell.propertiesStack.frame.size.width = CGFloat(40 * station.properties.count)
        cell.propertiesScroll.contentSize = cell.propertiesStack.frame.size
        
        MLog.log(string: "Facilities:", cell.propertiesStack.frame.width, cell.propertiesScroll.contentSize.width)
        
        cell.layoutSubviews()
        if station.isActive == "active" {
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stationTapped)))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func stationTapped(_ sender: UITapGestureRecognizer) {
        let indexPath = self.stationsTable.indexPath(for: sender.view as! StationsTableCell)
        var station = Station()
        
        switch selectedLine {
        case .aqua:
            station = LocalDataManager.dataMgr().aquaStations[indexPath!.row]
        case .purple:
            station = LocalDataManager.dataMgr().purpleStations[indexPath!.row]
        case .red:
            station = LocalDataManager.dataMgr().purpleStations[indexPath!.row]
        }
        if station.isActive == "active" {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let stationDetailsViewController = storyboard.instantiateViewController(withIdentifier: "StationDetailsViewController") as! StationDetailsViewController
                stationDetailsViewController.modalPresentationStyle = .fullScreen
                stationDetailsViewController.station = station
                self.navigationController?.pushViewController(stationDetailsViewController, animated: true)
            }
        }
    }
}

class StationsTableCell: UITableViewCell {
    
    @IBOutlet weak var lineImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var propertiesStack: UIStackView!
    @IBOutlet weak var propertiesScroll: UIScrollView!
    
}
