//
//  LostAndFoudDetailsViewController.swift
//  PuneMetro
//
//  Created by Venkat Rao Sandhi on 06/06/22.
//

import UIKit

class LostAndFoudDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var pastTabLabel: UILabel!
    @IBOutlet weak var pastTabBottomLine: UIView!
    
    var ticketGrievance: AllCompliant!
    override func viewDidLoad() {
        prepareUI()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func prepareUI() {
        metroNavBar.setup(titleStr: "Ticket Grievances".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {self.navigationController?.popViewController(animated: true)}, rightImage: nil, rightTap: {})

        tableview.isHidden = false
        
    }

}

extension LostAndFoudDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketGrievannceDetailsCell", for: indexPath) as! TicketGrievannceDetailsCell
        cell.backView.backgroundColor = CustomColors.COLOR_WHITE6
        let service = ticketGrievance

        cell.ticketIdLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        cell.ticketIdLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.ticketIdLabel.text = service?.ticketSerialNumber
        
        cell.remarkLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        cell.remarkLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.remarkLabel.text = service?.remarks == "" ? "null" : service?.remarks
        
        cell.issueDescriptioLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        cell.issueDescriptioLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.issueDescriptioLabel.text = service?.description
        
        cell.statusLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        cell.statusLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.statusLabel.text = service?.status == "" ? "null" : service?.status
        cell.complainId.font = UIFont(name: "Roboto-Medium", size: 16)
        cell.complainId.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.complainId.text = service?.ticketID == "" ? "null" : service?.ticketID
        
        cell.strTicketId.font = UIFont(name: "Roboto-Regular", size: 16)
        cell.strTicketId.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.strRemarks.font = UIFont(name: "Roboto-Regular", size: 16)
        cell.strRemarks.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.strIssueDesc.font = UIFont(name: "Roboto-Regular", size: 16)
        cell.strIssueDesc.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.strStatus.font = UIFont(name: "Roboto-Regular", size: 16)
        cell.strStatus.textColor = CustomColors.COLOR_MEDIUM_GRAY
        cell.strComplinId.font = UIFont(name: "Roboto-Regular", size: 16)
        cell.strComplinId.textColor = CustomColors.COLOR_MEDIUM_GRAY
        
        return cell
    }
}

class TicketGrievannceDetailsCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var ticketIdLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var issueDescriptioLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var strTicketId: UILabel!
    @IBOutlet weak var strRemarks: UILabel!
    @IBOutlet weak var strIssueDesc: UILabel!
    @IBOutlet weak var strStatus: UILabel!
    @IBOutlet weak var strComplinId: UILabel!
    @IBOutlet weak var complainId: UILabel!
    
}
