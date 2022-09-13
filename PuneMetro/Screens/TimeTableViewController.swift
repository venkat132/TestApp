//
//  TimeTableViewController.swift
//  PuneMetro
//
//  Created by Venkat Rao Sandhi on 02/05/22.
//

import UIKit
import Kingfisher

class TimeTableViewController: UIViewController, UIScrollViewDelegate {
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
    
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var NumberOfImagesTitleLabel: UILabel!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet weak var rightArrowButton: UIButton!
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    let splashViewModel = SplashModel()
    var aryTimeTable = [TimeTable]()
    var counter = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        self.splashViewModel.setLoading = { loading in }
        self.splashViewModel.getTimeTable() { timeTable in
            self.aryTimeTable = timeTable
            self.prepareCategories()
        }
    }
    func prepareUI() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.isNavigationBarHidden = true
        metroNavBar.setup(titleStr: "Time Table".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {
            self.navigationController?.popViewController(animated: true)
        }, rightImage: nil, rightTap: {})
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        titleLabel.textColor = UIColor.black
        titleLabel.text = "One Pune".localized(using: "Localization")
        scrollView=UIScrollView()
        scrollView.frame = CGRect(x: 0, y: -10, width: previewView.frame.size.width, height: previewView.frame.size.height)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.zoomScale = 1.0
        scrollView.bounces=false
        scrollView.delegate=self
        previewView.addSubview(scrollView)
        imageView=UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        imageView.contentMode = .scaleAspectFit
        //scrollView.contentSize = .init(width: 2000, height: 2000)
        scrollView.addSubview(imageView)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalInset = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalInset = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    func prepareCategories() {
        NumberOfImagesTitleLabel.font = UIFont(name: "Roboto-Medium", size: 22)
        NumberOfImagesTitleLabel.text = aryTimeTable.isEmpty ? "" : "1/\(aryTimeTable.count)"
        allView.backgroundColor = .white
        allView.layer.borderWidth = 0.5
        allView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        allLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        allLabel.text = aryTimeTable.isEmpty ? "" : aryTimeTable[0].tableHeader
        allLabel.textColor = CustomColors.COLOR_DARK_GRAY
        allView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        allView.tag = 1
        allView.backgroundColor = .white
        allView.layer.borderColor = UIColor.white.cgColor
        allLabel.textColor = CustomColors.COLOR_DARK_GRAY
        leftArrowButton.isHidden = true
        if aryTimeTable.isEmpty {
            rightArrowButton.isHidden = true
        }
        
        railView.backgroundColor = .white
        railView.layer.borderWidth = 0.5
        railView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        railLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        railLabel.text = aryTimeTable.count>1 ? aryTimeTable[1].tableHeader : "2"
        railLabel.textColor = CustomColors.COLOR_DARK_GRAY
        railView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        railView.tag = 2
        
        busView.isHidden = true
        busView.backgroundColor = .white
        busView.layer.borderWidth = 0.5
        busView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        busLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        busLabel.text = aryTimeTable.count>2 ? aryTimeTable[2].tableHeader : "3"
        busLabel.textColor = CustomColors.COLOR_DARK_GRAY
        //  busView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        cabView.isHidden = true
        cabView.backgroundColor = .white
        cabView.layer.borderWidth = 0.5
        cabView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        cabLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        cabLabel.text = aryTimeTable.count>3 ? aryTimeTable[3].tableHeader : "4"
        cabLabel.textColor = CustomColors.COLOR_DARK_GRAY
        //  cabView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        rickshawView.isHidden = true
        rickshawView.backgroundColor = .white
        rickshawView.layer.borderWidth = 0.5
        rickshawView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        rickshawLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        rickshawLabel.text = aryTimeTable.count>4 ? aryTimeTable[3].tableHeader : "4"
        rickshawLabel.textColor = CustomColors.COLOR_DARK_GRAY
        //  rickshawView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        bikeView.backgroundColor = .white
        bikeView.layer.borderWidth = 0.5
        bikeView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        bikeLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        bikeLabel.text = aryTimeTable.count>2 ? aryTimeTable[2].tableHeader : "3"
        bikeLabel.textColor = CustomColors.COLOR_DARK_GRAY
        bikeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        bikeView.tag = 3
        
        cycleView.backgroundColor = .white
        cycleView.layer.borderWidth = 0.5
        cycleView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        cycleLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        cycleLabel.text = aryTimeTable.count>3 ? aryTimeTable[3].tableHeader : "4"
        cycleLabel.textColor = CustomColors.COLOR_DARK_GRAY
        cycleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        cycleView.tag = 4
        
        otherView.isHidden = true
        otherView.backgroundColor = .white
        otherView.layer.borderWidth = 0.5
        otherView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        otherLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        otherLabel.text = FeederServiceCategory.other.rawValue.localized(using: "Localized")
        otherLabel.textColor = CustomColors.COLOR_DARK_GRAY
        //   otherView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryTap)))
        
        guard let URL = URL(string:  self.aryTimeTable[0].tableImageLink) else { return}
        self.imageView.kf.setImage(with: URL)
    }
    @objc func onCategoryTap(_ sender: UITapGestureRecognizer) {
       let tag = sender.view?.tag
     allView.backgroundColor = (tag == 1) ? CustomColors.COLOR_ORANGE : .white
     allView.layer.borderColor = (tag == 1) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
     allLabel.textColor = (tag == 1) ? .white : CustomColors.COLOR_DARK_GRAY
     
     railView.backgroundColor = (tag == 2) ? CustomColors.COLOR_ORANGE : .white
     railView.layer.borderColor = (tag == 2) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
     railLabel.textColor = (tag == 2) ? .white : CustomColors.COLOR_DARK_GRAY
     
     bikeView.backgroundColor = (tag == 3) ? CustomColors.COLOR_ORANGE : .white
     bikeView.layer.borderColor = (tag == 3) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
     bikeLabel.textColor = (tag == 3) ? .white : CustomColors.COLOR_DARK_GRAY
     
     cycleView.backgroundColor = (tag == 4) ? CustomColors.COLOR_ORANGE : .white
     cycleView.layer.borderColor = (tag == 4) ? CustomColors.COLOR_ORANGE.cgColor : CustomColors.COLOR_DARK_GRAY.cgColor
     cycleLabel.textColor = (tag == 4) ? .white : CustomColors.COLOR_DARK_GRAY
        guard let URL = URL(string:  self.aryTimeTable[(tag ?? 1)-1].tableImageLink) else { return}
        self.imageView.kf.setImage(with: URL)
     }
    
    @IBAction func rightArrowButtonTapped(_ sender: UIButton) {
        self.leftArrowButton.isHidden = false
        counter += 1
        guard let URL = URL(string:  self.aryTimeTable[counter-1].tableImageLink) else { return}
        self.imageView.kf.setImage(with: URL)
        NumberOfImagesTitleLabel.text = aryTimeTable.isEmpty ? "" : "\(counter)/\(aryTimeTable.count)"
        allLabel.text = aryTimeTable[counter-1].tableHeader
        if aryTimeTable.count == counter {
            self.rightArrowButton.isHidden = true
        }
    }
    @IBAction func leftArrowButtonTapped(_ sender: UIButton) {
        self.rightArrowButton.isHidden = false
        counter -= 1
        guard let URL = URL(string:  self.aryTimeTable[counter-1].tableImageLink) else { return}
        self.imageView.kf.setImage(with: URL)
        NumberOfImagesTitleLabel.text = aryTimeTable.isEmpty ? "" : "\(counter)/\(aryTimeTable.count)"
        allLabel.text = aryTimeTable[counter-1].tableHeader
        if counter == 1 {
            self.leftArrowButton.isHidden = true
        }
    }
}
