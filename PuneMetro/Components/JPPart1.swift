//
//  BookTicketTabs.swift
//  PuneMetro
//
//  Created by Admin on 20/05/21.
//

import Foundation
import UIKit

class JPPart1: BaseView {
    
    @IBOutlet weak var seperator2: UIView!
    @IBOutlet weak var PathImage: UIImageView!
    @IBOutlet weak var FromLabel: UILabel!
    @IBOutlet weak var FromValueLabel: UILabel!
    @IBOutlet weak var OptionsStack: UIStackView!
    @IBOutlet weak var WalkTab: UIView!
    @IBOutlet weak var WalkImg: UIImageView!
    @IBOutlet weak var DriveTab: UIView!
    @IBOutlet weak var DriveImg: UIImageView!
    @IBOutlet weak var BusTab: UIView!
    @IBOutlet weak var BusImg: UIImageView!
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var ToLabel: UILabel!
    @IBOutlet weak var ToValueLabel: UILabel!
    var JourneyPart1Option: JPPart1Type = .Walk
    var JourneyParts: JPPart = .Part1
    var journeyPlannerModel = JourneyPlannerModel()
    var Part1TotalDistance = 0
    var Part3TotalDistance = 0
    var Part5TotalDistance = 0
    var Part1Totalduration = 0
    var Part3Totalduration = 0
    var Part5Totalduration = 0
    var SelectedOptionTypeInt = 0
    var SelectedPartInt = 0
    
    var Part1OptionSelection = 0
    var Part3OptionSelection = 0
    var Part5OptionSelection = 0
    
    @IBInspectable var TotalDistance: String = ""
    @IBInspectable var TotalDuration: String = ""
        
    @IBOutlet weak var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
         nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        // self.initialSetup(FromStation: "", ToStation: "", Tag: 0)
        addSubview(view)
        
    }

    internal override func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
  
    func initialSetup(FromStation: String, ToStation: String, DataObj: JourneyPlannerDataObject, PartView: Part) {
        self.journeyPlannerModel.JPResultDataObj = DataObj
        seperator2.createDottedLine(width: 2, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)

        self.FromLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        FromLabel.text = "From".localized(using: "Localization")
        FromLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        self.FromValueLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        self.FromValueLabel.textColor = .black
        
        self.DistanceLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        self.DistanceLabel.textColor = .black
        
        self.ToLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        self.ToLabel.text = "To".localized(using: "Localization")
        self.ToLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        self.ToValueLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        self.ToValueLabel.textColor = .black
        
        self.FromValueLabel.text = FromStation
        self.ToValueLabel.text = ToStation
        self.DistanceLabel.text =  "\(CalculateDistance(Meters: (PartView.walk?.distance!)!)), \(printSecondsToHoursMinutesSeconds(seconds: (PartView.walk?.duration!)!))"
        
        self.WalkTab.tag = tag
        self.DriveTab.tag = tag
        self.BusTab.tag = tag
        self.WalkTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(JPPart1tabTapped)))
        self.DriveTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(JPPart1tabTapped)))
        self.BusTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(JPPart1tabTapped)))
        
        self.Part1TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part1?.walk?.distance)!
        self.Part3TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part3?.walk?.distance)!
        self.Part1Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part1?.walk?.duration)!
        self.Part3Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part3?.walk?.duration)!
        
        if DataObj.body?.numOfParts == 5 {
            self.Part5TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part5?.walk?.distance)!
            self.Part5Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part5?.walk?.duration)!
        }
        
        self.setSelection(Part1Selection: JourneyPart1Option, Parts: JourneyParts)
    }
    
    @objc func JPPart1tabTapped(_ sender: UITapGestureRecognizer) {
        
        switch sender.view {
        case self.WalkTab:
            JourneyPart1Option = .Walk
        case self.DriveTab:
            JourneyPart1Option = .Drive
        case self.BusTab:
            JourneyPart1Option = .Bus
        default:
            MLog.log(string: "Invalid Selection")
        }
        switch sender.view?.tag {
        case 0:
            JourneyParts = .Part1
            self.SelectedPartInt = 1
        case 2:
            JourneyParts = .Part3
            self.SelectedPartInt = 3
        case 4:
            JourneyParts = .Part5
            self.SelectedPartInt = 5
        default:
            MLog.log(string: "Invalid Selection")
        }
        
        self.setSelection(Part1Selection: JourneyPart1Option, Parts: JourneyParts)
        
    }

    func setSelection(Part1Selection: JPPart1Type, Parts: JPPart) {
        switch Part1Selection {
        case .Walk:
            WalkImg.image = UIImage(named: "walk - selected.png")
            DriveImg.image = UIImage(named: "drive - unselected.png")
            BusImg.image = UIImage(named: "bus - unselected.png")
            PathImage.image = UIImage(named: "walkPath.png")
            self.SelectedOptionTypeInt = 1
            switch Parts {
            case .Part1:
                self.DistanceLabel.text =  "\(CalculateDistance(Meters: (journeyPlannerModel.JPResultDataObj?.body!.part1?.walk?.distance)!)), \(printSecondsToHoursMinutesSeconds(seconds: (journeyPlannerModel.JPResultDataObj?.body!.part1?.walk?.duration)!))"
                self.Part1TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part1?.walk?.distance)!
                self.Part1Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part1?.walk?.duration)!
                self.Part1OptionSelection = 1
            case .Part3:
                self.DistanceLabel.text =  "\(CalculateDistance(Meters: (journeyPlannerModel.JPResultDataObj?.body!.part3?.walk?.distance)!)), \(printSecondsToHoursMinutesSeconds(seconds: (journeyPlannerModel.JPResultDataObj?.body!.part3?.walk?.duration)!))"
                self.Part3TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part3?.walk?.distance)!
                self.Part3Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part3?.walk?.duration)!
                self.Part3OptionSelection = 1
            case .Part5:
                self.DistanceLabel.text =  "\(CalculateDistance(Meters: (journeyPlannerModel.JPResultDataObj?.body!.part5?.walk?.distance)!)), \(printSecondsToHoursMinutesSeconds(seconds: (journeyPlannerModel.JPResultDataObj?.body!.part5?.walk?.duration)!))"
                self.Part5TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part5?.walk?.distance)!
                self.Part5Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part5?.walk?.duration)!
                self.Part5OptionSelection = 1
            }
            
        case .Drive:
            WalkImg.image = UIImage(named: "walk - unselected.png")
            DriveImg.image = UIImage(named: "drive - selected.png")
            BusImg.image = UIImage(named: "bus - unselected.png")
            PathImage.image = UIImage(named: "drivePath.png")
            self.SelectedOptionTypeInt = 2
            switch Parts {
            case .Part1:
                self.DistanceLabel.text =  "\(CalculateDistance(Meters: (journeyPlannerModel.JPResultDataObj?.body!.part1?.drive?.distance)!)), \(printSecondsToHoursMinutesSeconds(seconds: (journeyPlannerModel.JPResultDataObj?.body!.part1?.drive?.duration)!))"
                self.Part1TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part1?.drive?.distance)!
                self.Part1Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part1?.drive?.duration)!
                self.Part1OptionSelection = 2
            case .Part3:
                self.DistanceLabel.text =  "\(CalculateDistance(Meters: (journeyPlannerModel.JPResultDataObj?.body!.part3?.drive?.distance)!)), \(printSecondsToHoursMinutesSeconds(seconds: (journeyPlannerModel.JPResultDataObj?.body!.part3?.drive?.duration)!))"
                self.Part3TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part3?.drive?.distance)!
                self.Part3Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part3?.drive?.duration)!
                self.Part3OptionSelection = 2
            case .Part5:
                self.DistanceLabel.text =  "\(CalculateDistance(Meters: (journeyPlannerModel.JPResultDataObj?.body!.part5?.drive?.distance)!)), \(printSecondsToHoursMinutesSeconds(seconds: (journeyPlannerModel.JPResultDataObj?.body!.part5?.drive?.duration)!))"
                self.Part5TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part5?.drive?.distance)!
                self.Part5Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part5?.drive?.duration)!
                self.Part5OptionSelection = 2
            }
            
        case .Bus:
            WalkImg.image = UIImage(named: "walk - unselected.png")
            DriveImg.image = UIImage(named: "drive - unselected.png")
            BusImg.image = UIImage(named: "bus - selected.png")
            PathImage.image = UIImage(named: "busPath.png")
            self.SelectedOptionTypeInt = 3
            switch Parts {
            case .Part1:
                self.DistanceLabel.text =  "\(CalculateDistance(Meters: (journeyPlannerModel.JPResultDataObj?.body!.part1?.partPublic?.distance)!)), \(printSecondsToHoursMinutesSeconds(seconds: (journeyPlannerModel.JPResultDataObj?.body!.part1?.partPublic?.duration)!))"
                self.Part1TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part1?.partPublic?.distance)!
                self.Part1Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part1?.partPublic?.duration)!
                self.Part1OptionSelection = 3
            case .Part3:
                self.DistanceLabel.text =  "\(CalculateDistance(Meters: (journeyPlannerModel.JPResultDataObj?.body!.part3?.partPublic?.distance)!)), \(printSecondsToHoursMinutesSeconds(seconds: (journeyPlannerModel.JPResultDataObj?.body!.part3?.partPublic?.duration)!))"
                self.Part3TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part3?.partPublic?.distance)!
                self.Part3Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part3?.partPublic?.duration)!
                self.Part3OptionSelection = 3
            case .Part5:
                self.DistanceLabel.text =  "\(CalculateDistance(Meters: (journeyPlannerModel.JPResultDataObj?.body!.part5?.partPublic?.distance)!)), \(printSecondsToHoursMinutesSeconds(seconds: (journeyPlannerModel.JPResultDataObj?.body!.part5?.partPublic?.duration)!))"
                self.Part5TotalDistance = (journeyPlannerModel.JPResultDataObj?.body!.part5?.partPublic?.distance)!
                self.Part5Totalduration = (journeyPlannerModel.JPResultDataObj?.body!.part5?.partPublic?.duration)!
                self.Part5OptionSelection = 3
            }
        }
        
        self.TotalDuration = printSecondsToHoursMinutesSeconds(seconds: self.Part1Totalduration + self.Part3Totalduration + self.Part5Totalduration)
        self.TotalDistance = CalculateDistance(Meters: self.Part1TotalDistance + self.Part3TotalDistance + self.Part5TotalDistance)
        let DataDict = ["TotalDuration": self.TotalDuration, "TotalDistance": self.TotalDistance, "SelectedPart": self.SelectedPartInt, "SelectedOptionType": self.SelectedOptionTypeInt, "Part1OptionSelection": self.Part1OptionSelection, "Part3OptionSelection": self.Part3OptionSelection, "Part5OptionSelection": self.Part5OptionSelection] as [String: Any]
        NotificationCenter.default.post(name: Notification.Name("GetTotalTimeAndDuration"), object: nil, userInfo: DataDict)
    }
    
    func printSecondsToHoursMinutesSeconds (seconds: Int) -> (String) {
        let (h, m, s) = self.secondsToHoursMinutesSeconds(seconds: seconds)
        MLog.log(string: ("\(h) Hours, \(m) Minutes, \(s) Seconds"))
        var Time = ""
        if h != 0 {
            Time = "\(h) Hrs, "
        }
        if m != 0 {
            Time += "\(m) Min"
        } else {
            if h != 0 {
                Time = Time.replacingOccurrences(of: ",", with: "")
            }
        }
        return Time
    }
    func secondsToHoursMinutesSeconds (seconds: Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func CalculateDistance (Meters: Int) -> (String) {
      return "\(Meters/1000) kms"
    }
   
}
enum JPPart1Type: String {
    case Walk
    case Drive
    case Bus
}
enum JPPart: String {
    case Part1
    case Part3
    case Part5
}
