//
//  JourneyDescriptionViewController.swift
//  PuneMetro
//
//  Created by Admin on 25/10/21.
//

import UIKit

class JourneyDescriptionViewController: UIViewController, ViewControllerLifeCycle {
    
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var CloseBtn: UIButton!
    @IBOutlet weak var DescriptionTV: UITextView!
    
    var TitleStr: String = ""
    var DescriptionStr: [String] = [""]
    
    override func viewDidLoad() {
        prepareUI()
        super.viewDidLoad()
    }
    func prepareUI() {
        self.TitleLbl.font = UIFont(name: "Roboto-Medium", size: 20)
        self.TitleLbl.text = TitleStr
        self.TitleLbl.textColor = .black
        guard  !DescriptionStr.isEmpty else {
              return
            }
        var DescStr = ""
        for i in 0..<self.DescriptionStr.count {
            if i != 0 {
             DescStr += "<br><br>"
            }
            DescStr += self.DescriptionStr[i]
        }
        self.DescriptionTV.attributedText = DescStr.replacingOccurrences(of: "<div", with: "<br> <div").convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Roboto-Regular", size: 16), csscolor: "black", lineheight: 5, csstextalign: "left")
        self.DescriptionTV.textColor = CustomColors.COLOR_DARK_GRAY
    }
    @IBAction func CloseBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func prepareViewModel() {
    }
    
}
