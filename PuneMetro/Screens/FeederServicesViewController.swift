//
//  FeederServicesViewController.swift
//  PuneMetro
//
//  Created by Admin on 15/07/21.
//

import Foundation
import UIKit

class FeederServicesViewController: UIViewController, ViewControllerLifeCycle, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterStack: UIStackView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var railView: UIView!
    @IBOutlet weak var railLabel: UILabel!
    @IBOutlet weak var busView: UIView!
    @IBOutlet weak var busLabel: UILabel!
    @IBOutlet weak var cabView: UIView!
    @IBOutlet weak var cabLabel: UILabel!
    @IBOutlet weak var rickshawView: UIView!
    @IBOutlet weak var rickshawLabel: UILabel!
    @IBOutlet weak var bikeView: UIView!
    @IBOutlet weak var bikeLabel: UILabel!
    @IBOutlet weak var cycleView: UIView!
    @IBOutlet weak var cycleLabel: UILabel!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var otherLabel: UILabel!
    
    @IBOutlet weak var servicesTable: UITableView!
    
    var viewModel = FeederServicesModel()
    override func viewDidLoad() {
        self.prepareUI()
        self.prepareViewModel()
    }
    func prepareUI() {
        if let tabBarController = tabBarController {
            servicesTable.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        metroNavBar.setup(titleStr: "Feeder Services".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {
            self.navigationController?.popViewController(animated: true)
        }, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.textColor = UIColor.black
        titleLabel.text = "One Pune".localized(using: "Localization")
        
        servicesTable.delegate = self
        servicesTable.dataSource = self
        
        prepareCategories()
    }
    func prepareViewModel() {
        viewModel.onCategoryChange = {
            MLog.log(string: "Services Found:", self.viewModel.filteredFeederServices.count)
            self.servicesTable.reloadData()
        }
        viewModel.loadServices()
    }
    func prepareCategories() {
        allView.backgroundColor = .white
        allView.layer.borderWidth = 0.5
        allView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        allLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        allLabel.text = FeederServiceCategory.all.rawValue.localized(using: "Localized")
        allLabel.textColor = CustomColors.COLOR_DARK_GRAY
        allView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        railView.backgroundColor = .white
        railView.layer.borderWidth = 0.5
        railView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        railLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        railLabel.text = FeederServiceCategory.rail.rawValue.localized(using: "Localized")
        railLabel.textColor = CustomColors.COLOR_DARK_GRAY
        railView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        busView.backgroundColor = .white
        busView.layer.borderWidth = 0.5
        busView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        busLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        busLabel.text = FeederServiceCategory.bus.rawValue.localized(using: "Localized")
        busLabel.textColor = CustomColors.COLOR_DARK_GRAY
        busView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        cabView.backgroundColor = .white
        cabView.layer.borderWidth = 0.5
        cabView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        cabLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        cabLabel.text = FeederServiceCategory.cab.rawValue.localized(using: "Localized")
        cabLabel.textColor = CustomColors.COLOR_DARK_GRAY
        cabView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        rickshawView.isHidden = true
        rickshawView.backgroundColor = .white
        rickshawView.layer.borderWidth = 0.5
        rickshawView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        rickshawLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        rickshawLabel.text = FeederServiceCategory.rickshaw.rawValue.localized(using: "Localized")
        rickshawLabel.textColor = CustomColors.COLOR_DARK_GRAY
        rickshawView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        bikeView.backgroundColor = .white
        bikeView.layer.borderWidth = 0.5
        bikeView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        bikeLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        bikeLabel.text = FeederServiceCategory.bike.rawValue.localized(using: "Localized")
        bikeLabel.textColor = CustomColors.COLOR_DARK_GRAY
        bikeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        cycleView.backgroundColor = .white
        cycleView.layer.borderWidth = 0.5
        cycleView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        cycleLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        cycleLabel.text = FeederServiceCategory.cycle.rawValue.localized(using: "Localized")
        cycleLabel.textColor = CustomColors.COLOR_DARK_GRAY
        cycleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        otherView.backgroundColor = .white
        otherView.layer.borderWidth = 0.5
        otherView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        otherLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        otherLabel.text = FeederServiceCategory.other.rawValue.localized(using: "Localized")
        otherLabel.textColor = CustomColors.COLOR_DARK_GRAY
        otherView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        setCategorySelection()
    }
    
    func setCategorySelection() {
        allView.backgroundColor = (viewModel.selectedCategory == .all) ? CustomColors.COLOR_ORANGE : .white
        allView.layer.borderColor = (viewModel.selectedCategory == .all) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        allLabel.textColor = (viewModel.selectedCategory == .all) ? .white : CustomColors.COLOR_DARK_GRAY
        
        railView.backgroundColor = (viewModel.selectedCategory == .rail) ? CustomColors.COLOR_ORANGE : .white
        railView.layer.borderColor = (viewModel.selectedCategory == .rail) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        railLabel.textColor = (viewModel.selectedCategory == .rail) ? .white : CustomColors.COLOR_DARK_GRAY
        
        busView.backgroundColor = (viewModel.selectedCategory == .bus) ? CustomColors.COLOR_ORANGE : .white
        busView.layer.borderColor = (viewModel.selectedCategory == .bus) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        busLabel.textColor = (viewModel.selectedCategory == .bus) ? .white : CustomColors.COLOR_DARK_GRAY
        
        cabView.backgroundColor = (viewModel.selectedCategory == .cab) ? CustomColors.COLOR_ORANGE : .white
        cabView.layer.borderColor = (viewModel.selectedCategory == .cab) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        cabLabel.textColor = (viewModel.selectedCategory == .cab) ? .white : CustomColors.COLOR_DARK_GRAY
        
        rickshawView.backgroundColor = (viewModel.selectedCategory == .rickshaw) ? CustomColors.COLOR_ORANGE : .white
        rickshawView.layer.borderColor = (viewModel.selectedCategory == .rickshaw) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        rickshawLabel.textColor = (viewModel.selectedCategory == .rickshaw) ? .white : CustomColors.COLOR_DARK_GRAY
        
        bikeView.backgroundColor = (viewModel.selectedCategory == .bike) ? CustomColors.COLOR_ORANGE : .white
        bikeView.layer.borderColor = (viewModel.selectedCategory == .bike) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        bikeLabel.textColor = (viewModel.selectedCategory == .bike) ? .white : CustomColors.COLOR_DARK_GRAY
        
        cycleView.backgroundColor = (viewModel.selectedCategory == .cycle) ? CustomColors.COLOR_ORANGE : .white
        cycleView.layer.borderColor = (viewModel.selectedCategory == .cycle) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        cycleLabel.textColor = (viewModel.selectedCategory == .cycle) ? .white : CustomColors.COLOR_DARK_GRAY
        
        otherView.backgroundColor = (viewModel.selectedCategory == .other) ? CustomColors.COLOR_ORANGE : .white
        otherView.layer.borderColor = (viewModel.selectedCategory == .other) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
        otherLabel.textColor = (viewModel.selectedCategory == .other) ? .white : CustomColors.COLOR_DARK_GRAY
    }
    
    @objc func onCategoryTap(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case allView: viewModel.selectedCategory = .all
        case railView: viewModel.selectedCategory = .rail
        case busView: viewModel.selectedCategory = .bus
        case cabView: viewModel.selectedCategory = .cab
        case rickshawView: viewModel.selectedCategory = .rickshaw
        case bikeView: viewModel.selectedCategory = .bike
        case cycleView: viewModel.selectedCategory = .cycle
        case otherView: viewModel.selectedCategory = .other
        default: MLog.log(string: "Invalid FeederService Category")
        }
        setCategorySelection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.width / 3) + 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredFeederServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesTableCell", for: indexPath) as! ServicesTableCell
        let service = viewModel.filteredFeederServices[indexPath.row]
        cell.logoImage.image = UIImage(named: service.logoImage)
        cell.iconImage.image = UIImage(named: service.category!.iconImageName())
        cell.titleLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        cell.titleLabel.text = service.title
        titleLabel.textColor = .black
        cell.detailsLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        cell.detailsLabel.text = service.details.localized(using: "Localization")
        cell.detailsLabel.textColor = CustomColors.COLOR_DARK_GRAY
        cell.detailsLabel.sizeToFit()
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onServiceTap)))
        return cell
    }
    
    @objc func onServiceTap(_ sender: UITapGestureRecognizer) {
        if sender.view is ServicesTableCell {
            let indexPath = servicesTable.indexPath(for: sender.view as! ServicesTableCell)
            let service = viewModel.filteredFeederServices[indexPath!.row]
            if service.url != "" {
                if let serviceUrl = URL(string: service.url) {
                    let application: UIApplication = UIApplication.shared
                    if (application.canOpenURL(serviceUrl)) {
                        application.open(serviceUrl, options: [:], completionHandler: nil)
                    }
                } else {
                    MLog.log(string: "Cannot Open:", service.url)
                }
            }
        }
    }
}

class ServicesTableCell: UITableViewCell {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
}
