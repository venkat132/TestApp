//
//  BookTicketTabs.swift
//  PuneMetro
//
//  Created by Admin on 20/05/21.
//

import Foundation
import UIKit
class JPPart2: BaseView {
    
    @IBOutlet weak var seperator2: UIView!
    @IBOutlet weak var PathImage: UIImageView!
    @IBOutlet weak var FromLabel: UILabel!
    @IBOutlet weak var FromValueLabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var ToLabel: UILabel!
    @IBOutlet weak var ToValueLabel: UILabel!

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
        // self.initialSetup()
        addSubview(view)
        
    }

    internal override func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
  
    func initialSetup(DataObj: Body) {
        seperator2.createDottedLine(width: 2, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        
        self.FromLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        FromLabel.text = "From".localized(using: "Localization")
        FromLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        self.FromValueLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        self.FromValueLabel.textColor = .black
        
        DistanceLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        DistanceLabel.text = "Travel in Pune Metro".localized(using: "Localization")
        DistanceLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        ToLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        ToLabel.text = "To".localized(using: "Localization")
        ToLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        ToValueLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        ToValueLabel.textColor = .black
        
        switch tag {
        case 1:
            self.FromValueLabel.text = DataObj.station1?.name
            self.ToValueLabel.text = DataObj.station2?.name
            
        case 3:
            self.FromValueLabel.text = DataObj.station3?.name
            self.ToValueLabel.text = DataObj.station4?.name
        default:
            MLog.log(string: "Invalid Selection")
        }
    }
    func printSecondsToHoursMinutesSeconds (seconds: Int) -> (String) {
        let (h, m, s) = self.secondsToHoursMinutesSeconds(seconds: seconds)
        MLog.log(string: ("\(h) Hours, \(m) Minutes, \(s) Seconds"))
        if h != 0 {
            return "\(h) Hours"
        } else {
            return "\(m) Minutes"
        }
    }
    func secondsToHoursMinutesSeconds (seconds: Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func CalculateDistance (Meters: Int) -> (String) {
      return "\(Meters/1000) kms"
    }
    
}
