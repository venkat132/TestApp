//
//  TicketsListViewController.swift
//  PuneMetro
//
//  Created by Admin on 11/05/21.
//

import Foundation
import UIKit

class TicketsListViewController: UIViewController, ViewControllerLifeCycle, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var metroNavBar: MetroNavBar!
    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var tabsStack: UIStackView!
    @IBOutlet weak var activeTab: UIView!
    @IBOutlet weak var activeTabLabel: UILabel!
    @IBOutlet weak var activeTabBottomLine: UIView!
    
    @IBOutlet weak var pastTab: UIView!
    @IBOutlet weak var pastTabLabel: UILabel!
    @IBOutlet weak var pastTabBottomLine: UIView!
    @IBOutlet weak var filtersStack: UIStackView!
    @IBOutlet weak var pgAllView: UIView!
    @IBOutlet weak var pgAllLabel: UILabel!
    @IBOutlet weak var pgCardView: UIView!
    @IBOutlet weak var pgCardLabel: UILabel!
    @IBOutlet weak var pgPayuView: UIView!
    @IBOutlet weak var pgPayuLabel: UILabel!
    @IBOutlet weak var pgPointsView: UIView!
    @IBOutlet weak var pgPointsLabel: UILabel!
    @IBOutlet weak var date1View: UIView!
    @IBOutlet weak var date1Label: UILabel!
    @IBOutlet weak var date2View: UIView!
    @IBOutlet weak var date2Label: UILabel!
    @IBOutlet weak var date3View: UIView!
    @IBOutlet weak var date3Label: UILabel!
    @IBOutlet weak var date4View: UIView!
    @IBOutlet weak var date4Label: UILabel!
    
    @IBOutlet weak var ticketsTable: UITableView!
    
    
    let reuseCellIdentifier = "TicketsTableCell"
    let reuseCellIdentifierNew = "TicketsTableCellNew"
    var selection: TicketTabSelection = .active
    
    var viewBookedTicket: Bool = false
    var qrUpdateTimer: Timer?
    var ticketRefreshTimer: Timer?
    var viewModel = TicketsListModel()
    func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    override func viewDidLoad() {
        prepareUI()
        prepareViewModel()
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
       // NotificationCenter.default.addObserver(self, selector: #selector(hideScreenShot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        if let homeTab = self.tabBarController as? HomeTabBarController {
        self.viewBookedTicket = homeTab.bookedTicket
        homeTab.bookedTicket = false
        self.tabBarController?.tabBar.isHidden = false
    }
        viewModel.loadActiveTickets(viewBookedTicket: true)
        viewModel.getActiveTickets()
        if viewModel.pastTickets.isEmpty && !viewBookedTicket {
            viewModel.getPastTickets(offset: 0)
        }
        MLog.log(string: "View Ticket Flag:", viewBookedTicket)
        LocalDataManager.dataMgr().brightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1
        prepareUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if qrUpdateTimer != nil {
            qrUpdateTimer?.invalidate()
            qrUpdateTimer = nil
        }
        if ticketRefreshTimer != nil {
            ticketRefreshTimer?.invalidate()
            ticketRefreshTimer = nil
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
      //  NotificationCenter.default.removeObserver(self)
        UIScreen.main.brightness = LocalDataManager.dataMgr().brightness
    }
    @objc private func hideScreenShot() {
        UIApplication.shared.ignoreSnapshotOnNextApplicationLaunch()
    }
    func prepareViewModel() {
        viewModel.didActiveTicketsReceived = {
            if !self.viewModel.activeTickets.isEmpty {
                self.selection = .active
                self.setSelection()
            }
        }
        
        viewModel.didPastTicketsReceived = {
            if self.viewModel.activeTickets.isEmpty {
                self.selection = .past
            }
            self.setSelection()
        }
        viewModel.showAlert = { msg in
            self.showMessage(message: msg)
            self.viewModel.getActiveTickets()
            self.viewModel.getPastTickets(offset: 0)
        }
        viewModel.didFiltersChanged = {
            self.setSelection()
        }
        viewModel.didDownloadTicket = { Filename in
            self.ViewDownloadedTicket(filename: Filename)
        }
        
    }
    
    func prepareUI() {
        metroNavBar.setup(titleStr: viewBookedTicket ? "Tickets".localized(using: "Localization") : "View Ticket".localized(using: "Localization"), leftImage: UIImage(named: "back"), leftTap: {
            if !self.viewBookedTicket {
                self.tabBarController?.selectedIndex = 0
            } else {
                self.tabBarController?.selectedIndex = 1
            }
        }, rightImage: viewBookedTicket ? nil : UIImage(named: "profile-1"), rightTap: {
            MLog.log(string: "Profile Tapped")
            self.goToProfile()
        })

        tabsStack.isHidden = self.viewBookedTicket
        progressImage.isHidden = !self.viewBookedTicket
        
        activeTabLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        activeTabLabel.text = "Active Trips".localized(using: "Localization")
        activeTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSelectionTab)))
        pastTabLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        pastTabLabel.text = "Past Trips".localized(using: "Localization")
        pastTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSelectionTab)))
        
        activeTab.layer.cornerRadius = 10
        activeTab.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        activeTab.layer.borderWidth = 0
        activeTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        
        pastTab.layer.cornerRadius = 10
        pastTab.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        pastTab.layer.borderWidth = 0
        pastTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        
        ticketsTable.delegate = self
        ticketsTable.dataSource = self
        if let tabBarController = tabBarController {
            ticketsTable.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0)
        }
        setSelection()
        setDateRanges()
        
    }
    
    func setSelection() {
        switch selection {
        case .active:
            activeTab.backgroundColor = CustomColors.COLOR_ORANGE
            activeTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            activeTabLabel.textColor = .white
            activeTabBottomLine.backgroundColor = CustomColors.COLOR_ORANGE
            
            pastTab.backgroundColor = .white
            pastTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            pastTabLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            pastTabBottomLine.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
            
            filtersStack.isHidden = true
        case .past:
            activeTab.backgroundColor = .white
            activeTab.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            activeTabLabel.textColor = CustomColors.COLOR_MEDIUM_GRAY
            activeTabBottomLine.backgroundColor = CustomColors.COLOR_MEDIUM_GRAY
            
            pastTab.backgroundColor = CustomColors.COLOR_ORANGE
            pastTab.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            pastTabLabel.textColor = .white
            pastTabBottomLine.backgroundColor = CustomColors.COLOR_ORANGE
            
            filtersStack.isHidden = false
        }
        if selection == .active || self.viewBookedTicket {
            if qrUpdateTimer != nil {
                qrUpdateTimer?.invalidate()
            }
            qrUpdateTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Globals.QR_UPDATE_INTERVAL), repeats: true, block: { _ in
                for ticket in self.viewModel.activeTickets {
                    for qr in ticket.qrs {
                        qr.qrStringUpdated = QRUtils.updateQRCode(qrStr: qr.qrString)
                    }
                }
                self.ticketsTable.reloadData()
            })
            if ticketRefreshTimer != nil {
                ticketRefreshTimer?.invalidate()
            }
            ticketRefreshTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Globals.TICKET_REFRESH_INTERVAL), repeats: true, block: { _ in
                self.viewModel.getActiveTickets()
            })
        } else {
            if qrUpdateTimer != nil {
                qrUpdateTimer?.invalidate()
                qrUpdateTimer = nil
            }
            if ticketRefreshTimer != nil {
                ticketRefreshTimer?.invalidate()
                ticketRefreshTimer = nil
            }
        }
        if selection == .active && ticketsTable.numberOfRows(inSection: 0) <= viewModel.activeTickets.count {
            UIView.performWithoutAnimation({
                let loc = ticketsTable.contentOffset
                ticketsTable.reloadData()
                ticketsTable.contentOffset = loc
            })
        } else {
            ticketsTable.reloadData()
        }
    }
    
    func setDateRanges() {
        viewModel.dateRanges.removeAll()
        for i in 0...3 {
            let startDate = Calendar.current.date(byAdding: .day, value: -i * 7, to: Date())!
            let endDate = Calendar.current.date(byAdding: .day, value: -(i * 7) - 6, to: Date())!
            let labelStr = "\(DateUtils.returnStringShort(startDate)!)-\(DateUtils.returnStringShort(endDate)!)"
            let filterObj = DateFilter()
            filterObj.startDate = startDate
            filterObj.endDate = endDate
            filterObj.title = labelStr
            viewModel.dateRanges.append(filterObj)
        }
        prepareFilters()
    }
    
    func prepareFilters() {
        pgAllView.backgroundColor = .white
        pgAllView.layer.borderWidth = 0.5
        pgAllView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        pgAllLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        pgAllLabel.text = PgFilter.all.rawValue.localized(using: "Localized")
        pgAllLabel.textColor = CustomColors.COLOR_DARK_GRAY
        pgAllView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pgFilterTap)))
        
        pgCardView.backgroundColor = .white
        pgCardView.layer.borderWidth = 0.5
        pgCardView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        pgCardLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        pgCardLabel.text = PgFilter.card.rawValue.localized(using: "Localized")
        pgCardLabel.textColor = CustomColors.COLOR_DARK_GRAY
        pgCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pgFilterTap)))
        
        pgPayuView.backgroundColor = .white
        pgPayuView.layer.borderWidth = 0.5
        pgPayuView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        pgPayuLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        pgPayuLabel.text = PgFilter.payU.rawValue.localized(using: "Localized")
        pgPayuLabel.textColor = CustomColors.COLOR_DARK_GRAY
        pgPayuView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pgFilterTap)))
        
        pgPointsView.backgroundColor = .white
        pgPointsView.layer.borderWidth = 0.5
        pgPointsView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        pgPointsLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        pgPointsLabel.text = PgFilter.points.rawValue.localized(using: "Localized")
        pgPointsLabel.textColor = CustomColors.COLOR_DARK_GRAY
        pgPointsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pgFilterTap)))
        
        date1View.backgroundColor = .white
        date1View.layer.borderWidth = 0.5
        date1View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        date1Label.font = UIFont(name: "Roboto-Medium", size: 11)
        date1Label.adjustsFontSizeToFitWidth = true
        date1Label.textAlignment = NSTextAlignment.center
        date1Label.text = viewModel.dateRanges[0].title
        date1Label.textColor = CustomColors.COLOR_DARK_GRAY
        date1View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateFilterTap)))
        
        date2View.backgroundColor = .white
        date2View.layer.borderWidth = 0.5
        date2View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        date2Label.font = UIFont(name: "Roboto-Medium", size: 11)
        date2Label.adjustsFontSizeToFitWidth = true
        date2Label.textAlignment = NSTextAlignment.center
        date2Label.text = viewModel.dateRanges[1].title
        date2Label.textColor = CustomColors.COLOR_DARK_GRAY
        date2View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateFilterTap)))
        
        date3View.backgroundColor = .white
        date3View.layer.borderWidth = 0.5
        date3View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        date3Label.font = UIFont(name: "Roboto-Medium", size: 11)
        date3Label.adjustsFontSizeToFitWidth = true
        date3Label.textAlignment = NSTextAlignment.center
        date3Label.text = viewModel.dateRanges[2].title
        date3Label.textColor = CustomColors.COLOR_DARK_GRAY
        date3View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateFilterTap)))
        
        date4View.backgroundColor = .white
        date4View.layer.borderWidth = 0.5
        date4View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
        date4Label.font = UIFont(name: "Roboto-Medium", size: 11)
        date4Label.adjustsFontSizeToFitWidth = true
        date4Label.textAlignment = NSTextAlignment.center
        date4Label.text = viewModel.dateRanges[3].title
        date4Label.textColor = CustomColors.COLOR_DARK_GRAY
        date4View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateFilterTap)))
        
        setPgFilterSelection()
        setDateFilterSelection()
    }
    @objc func pgFilterTap(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case pgAllView: viewModel.selectedPgFilter = .all
        case pgCardView: viewModel.selectedPgFilter = .card
        case pgPayuView: viewModel.selectedPgFilter = .payU
        case pgPointsView: viewModel.selectedPgFilter = .points
        default: MLog.log(string: "Invalid PG Filter")
        }
        setPgFilterSelection()
    }
    func setPgFilterSelection() {
        switch viewModel.selectedPgFilter {
        case .all:
            pgAllView.backgroundColor = CustomColors.COLOR_ORANGE
            pgAllView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            pgAllLabel.textColor = .white
            
            pgCardView.backgroundColor = .white
            pgCardView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgCardLabel.textColor = CustomColors.COLOR_DARK_GRAY
            
            pgPayuView.backgroundColor = .white
            pgPayuView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgPayuLabel.textColor = CustomColors.COLOR_DARK_GRAY
            
            pgPointsView.backgroundColor = .white
            pgPointsView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgPointsLabel.textColor = CustomColors.COLOR_DARK_GRAY
        case .card:
            pgCardView.backgroundColor = CustomColors.COLOR_ORANGE
            pgCardView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            pgCardLabel.textColor = .white
            
            pgAllView.backgroundColor = .white
            pgAllView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgAllLabel.textColor = CustomColors.COLOR_DARK_GRAY
            
            pgPayuView.backgroundColor = .white
            pgPayuView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgPayuLabel.textColor = CustomColors.COLOR_DARK_GRAY
            
            pgPointsView.backgroundColor = .white
            pgPointsView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgPointsLabel.textColor = CustomColors.COLOR_DARK_GRAY
        case .payU:
            pgPayuView.backgroundColor = CustomColors.COLOR_ORANGE
            pgPayuView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            pgPayuLabel.textColor = .white
            
            pgCardView.backgroundColor = .white
            pgCardView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgCardLabel.textColor = CustomColors.COLOR_DARK_GRAY
            
            pgAllView.backgroundColor = .white
            pgAllView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgAllLabel.textColor = CustomColors.COLOR_DARK_GRAY
            
            pgPointsView.backgroundColor = .white
            pgPointsView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgPointsLabel.textColor = CustomColors.COLOR_DARK_GRAY
        case .points:
            pgPointsView.backgroundColor = CustomColors.COLOR_ORANGE
            pgPointsView.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            pgPointsLabel.textColor = .white
            
            pgCardView.backgroundColor = .white
            pgCardView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgCardLabel.textColor = CustomColors.COLOR_DARK_GRAY
            
            pgPayuView.backgroundColor = .white
            pgPayuView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgPayuLabel.textColor = CustomColors.COLOR_DARK_GRAY
            
            pgAllView.backgroundColor = .white
            pgAllView.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            pgAllLabel.textColor = CustomColors.COLOR_DARK_GRAY
        }
    }
    
    @objc func dateFilterTap(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case date1View: viewModel.selectedDateRangeFilter = .date1
        case date2View: viewModel.selectedDateRangeFilter = .date2
        case date3View: viewModel.selectedDateRangeFilter = .date3
        case date4View: viewModel.selectedDateRangeFilter = .date4
        default: MLog.log(string: "Invalid Date Filter")
        }
        setDateFilterSelection()
    }
    func setDateFilterSelection() {
        switch viewModel.selectedDateRangeFilter {
        case .date1:
            date1View.backgroundColor = CustomColors.COLOR_ORANGE
            date1View.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            date1Label.textColor = .white
            
            date2View.backgroundColor = .white
            date2View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date2Label.textColor = CustomColors.COLOR_DARK_GRAY
            
            date3View.backgroundColor = .white
            date3View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date3Label.textColor = CustomColors.COLOR_DARK_GRAY
            
            date4View.backgroundColor = .white
            date4View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date4Label.textColor = CustomColors.COLOR_DARK_GRAY
        case .date2:
            date2View.backgroundColor = CustomColors.COLOR_ORANGE
            date2View.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            date2Label.textColor = .white
            
            date1View.backgroundColor = .white
            date1View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date1Label.textColor = CustomColors.COLOR_DARK_GRAY
            
            date3View.backgroundColor = .white
            date3View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date3Label.textColor = CustomColors.COLOR_DARK_GRAY
            
            date4View.backgroundColor = .white
            date4View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date4Label.textColor = CustomColors.COLOR_DARK_GRAY
        case .date3:
            date3View.backgroundColor = CustomColors.COLOR_ORANGE
            date3View.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            date3Label.textColor = .white
            
            date2View.backgroundColor = .white
            date2View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date2Label.textColor = CustomColors.COLOR_DARK_GRAY
            
            date1View.backgroundColor = .white
            date1View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date1Label.textColor = CustomColors.COLOR_DARK_GRAY
            
            date4View.backgroundColor = .white
            date4View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date4Label.textColor = CustomColors.COLOR_DARK_GRAY
        case .date4:
            date4View.backgroundColor = CustomColors.COLOR_ORANGE
            date4View.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            date4Label.textColor = .white
            
            date2View.backgroundColor = .white
            date2View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date2Label.textColor = CustomColors.COLOR_DARK_GRAY
            
            date3View.backgroundColor = .white
            date3View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date3Label.textColor = CustomColors.COLOR_DARK_GRAY
            
            date1View.backgroundColor = .white
            date1View.layer.borderColor = CustomColors.COLOR_DARK_GRAY.cgColor
            date1Label.textColor = CustomColors.COLOR_DARK_GRAY
        }
    }
    
    @objc func setSelectionTab(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case activeTab:
            selection = .active
        case pastTab:
            selection = .past
        default:
            MLog.log(string: "Invalid Selection")
        }
        setSelection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selection {
        case .active:
            return viewModel.activeTickets.count
        case .past:
            return viewModel.filteredPastTickets.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifierNew, for: indexPath) as! TicketsTableCellNew
        var ticket = Ticket()
        switch selection {
        case .active:
            ticket = viewModel.activeTickets[indexPath.row]
        case .past:
            ticket = viewModel.filteredPastTickets[indexPath.row]
        }
        cell.setupTicket(ticket: ticket, qrThumbTapped: { i in
            self.qrToggleByIndex(cell: cell, index: i)
        }, qrArrowTapped: { i in
            self.qrChangeIndex(cell: cell, index: i)
        }, cancelTransactionTap: {
            self.cancelTransaction(cell: cell)
        }, cancelTicketTap: {
            self.cancelTicket(cell: cell)
        }, downloadTicketTap: {
            self.DownloadTicket(cell: cell)
        })
        cell.bookAgain.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookAgainTap)))
        cell.qrToggle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(qrToggleTap)))
//        if selection == .past && indexPath.row == (viewModel.pastTickets.count - 1) {
//            viewModel.getPastTickets(offset: viewModel.pastTickets.count)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selection {
        case .active:
//            return !self.viewModel.activeTickets[indexPath.row].qrExpanded ? ((tableView.frame.width / 2) + 30) : ((tableView.frame.width * 3 / 2))
            return !self.viewModel.activeTickets[indexPath.row].qrExpanded ? ((tableView.frame.width * 199 / 370) + 30) : ((tableView.frame.width * 580 / 370) + 100)
        case .past:
            return !self.viewModel.filteredPastTickets[indexPath.row].qrExpanded ? ((tableView.frame.width * 199 / 370) + 30) : ((tableView.frame.width * 580 / 370) + 100)
        }
    }
    
    @objc func qrToggleTap(_ sender: UITapGestureRecognizer) {
        MLog.log(string: "qr toggle super super", sender.view?.superview?.superview)
        let cell = sender.view?.superview?.superview as! TicketsTableCellNew
        let indexPath = self.ticketsTable.indexPath(for: cell)
        switch selection {
        case .active:
            self.viewModel.activeTickets[indexPath!.row].qrExpanded = !self.viewModel.activeTickets[indexPath!.row].qrExpanded
            if self.viewModel.activeTickets[indexPath!.row].qrExpanded {
                UIScreen.main.brightness = 1
            }
            cell.setupTicket(ticket: self.viewModel.activeTickets[indexPath!.row], qrThumbTapped: { i in
                self.qrToggleByIndex(cell: cell, index: i)
            }, qrArrowTapped: { i in
                self.qrChangeIndex(cell: cell, index: i)
            }, cancelTransactionTap: {
                self.cancelTransaction(cell: cell)
            }, cancelTicketTap: {
                self.cancelTicket(cell: cell)
            }, downloadTicketTap: {
                self.DownloadTicket(cell: cell)
            })
        case .past:
            self.viewModel.filteredPastTickets[indexPath!.row].qrExpanded = !self.viewModel.filteredPastTickets[indexPath!.row].qrExpanded
            if self.viewModel.filteredPastTickets[indexPath!.row].qrExpanded {
                UIScreen.main.brightness = 1
            }
            cell.setupTicket(ticket: self.viewModel.filteredPastTickets[indexPath!.row], qrThumbTapped: { i in
                self.qrToggleByIndex(cell: cell, index: i)
            }, qrArrowTapped: { i in
                self.qrChangeIndex(cell: cell, index: i)
            }, cancelTransactionTap: {
                self.cancelTransaction(cell: cell)
            }, cancelTicketTap: {
                self.cancelTicket(cell: cell)
            }, downloadTicketTap: {
                self.DownloadTicket(cell: cell)
            })
        }
        self.ticketsTable.beginUpdates()
        self.ticketsTable.endUpdates()
    }
    
    func qrToggleByIndex(cell: TicketsTableCellNew, index: Int) {
        let indexPath = self.ticketsTable.indexPath(for: cell)
        switch selection {
        case .active:
            self.viewModel.activeTickets[indexPath!.row].qrExpanded = !self.viewModel.activeTickets[indexPath!.row].qrExpanded
            if self.viewModel.activeTickets[indexPath!.row].qrExpanded {
                UIScreen.main.brightness = 1
            }
            self.viewModel.activeTickets[indexPath!.row].qrIndex = index
            cell.setupTicket(ticket: self.viewModel.activeTickets[indexPath!.row], qrThumbTapped: { i in
                self.qrToggleByIndex(cell: cell, index: i)
            }, qrArrowTapped: { i in
                self.qrChangeIndex(cell: cell, index: i)
            }, cancelTransactionTap: {
                self.cancelTransaction(cell: cell)
            }, cancelTicketTap: {
                self.cancelTicket(cell: cell)
            }, downloadTicketTap: {
                self.DownloadTicket(cell: cell)
            })
        case .past:
            self.viewModel.filteredPastTickets[indexPath!.row].qrExpanded = !self.viewModel.filteredPastTickets[indexPath!.row].qrExpanded
            if self.viewModel.filteredPastTickets[indexPath!.row].qrExpanded {
                UIScreen.main.brightness = 1
            }
            self.viewModel.filteredPastTickets[indexPath!.row].qrIndex = index
            cell.setupTicket(ticket: self.viewModel.filteredPastTickets[indexPath!.row], qrThumbTapped: { i in
                self.qrToggleByIndex(cell: cell, index: i)
            }, qrArrowTapped: { i in
                self.qrChangeIndex(cell: cell, index: i)
            }, cancelTransactionTap: {
                self.cancelTransaction(cell: cell)
            }, cancelTicketTap: {
                self.cancelTicket(cell: cell)
            }, downloadTicketTap: {
                self.DownloadTicket(cell: cell)
            })
        }
        self.ticketsTable.beginUpdates()
        self.ticketsTable.endUpdates()
    }
    
    func qrChangeIndex(cell: TicketsTableCellNew, index: Int) {
        let indexPath = self.ticketsTable.indexPath(for: cell)
        switch selection {
        case .active:
            self.viewModel.activeTickets[indexPath!.row].qrExpanded = true
            self.viewModel.activeTickets[indexPath!.row].qrIndex = index
            cell.setupTicket(ticket: self.viewModel.activeTickets[indexPath!.row], qrThumbTapped: { i in
                self.qrToggleByIndex(cell: cell, index: i)
            }, qrArrowTapped: { i in
                self.qrChangeIndex(cell: cell, index: i)
            }, cancelTransactionTap: {
                self.cancelTransaction(cell: cell)
            }, cancelTicketTap: {
                self.cancelTicket(cell: cell)
            }, downloadTicketTap: {
                self.DownloadTicket(cell: cell)
            })
        case .past:
            self.viewModel.filteredPastTickets[indexPath!.row].qrExpanded = true
            self.viewModel.filteredPastTickets[indexPath!.row].qrIndex = index
            cell.setupTicket(ticket: self.viewModel.filteredPastTickets[indexPath!.row], qrThumbTapped: { i in
                self.qrToggleByIndex(cell: cell, index: i)
            }, qrArrowTapped: { i in
                self.qrChangeIndex(cell: cell, index: i)
            }, cancelTransactionTap: {
                self.cancelTransaction(cell: cell)
            }, cancelTicketTap: {
                self.cancelTicket(cell: cell)
            }, downloadTicketTap: {
                self.DownloadTicket(cell: cell)
            })
        }
        self.ticketsTable.beginUpdates()
        self.ticketsTable.endUpdates()
    }
    
    func DownloadTicket(cell: TicketsTableCellNew) {
        
        let indexPath = self.ticketsTable.indexPath(for: cell)
        switch selection {
        case .active:
            let ticket = self.viewModel.activeTickets[indexPath!.row]
            self.viewModel.downloadTicket(ticket: ticket, index: ticket.qrIndex)
            
        case .past: break
        }
        
    }
    func cancelTicket(cell: TicketsTableCellNew) {
        let indexPath = self.ticketsTable.indexPath(for: cell)
        switch selection {
        case .active:
            let ticket = self.viewModel.activeTickets[indexPath!.row]
            self.showAlert(onTap: {
                self.viewModel.cancelTicket(ticket: ticket, index: ticket.qrIndex)
            })
        case .past: break
        }
        self.ticketsTable.beginUpdates()
        self.ticketsTable.endUpdates()
    }
    
    func cancelTransaction(cell: TicketsTableCellNew) {
        let indexPath = self.ticketsTable.indexPath(for: cell)
        switch selection {
        case .active:
            let ticket = self.viewModel.activeTickets[indexPath!.row]
            self.showAlert(onTap: {
                self.viewModel.cancelTransaction(ticket: ticket)
            })
        case .past: break
        }
        self.ticketsTable.beginUpdates()
        self.ticketsTable.endUpdates()
    }
    
    @objc func bookAgainTap(_ sender: UITapGestureRecognizer) {
        MLog.log(string: "Book again super super", sender.view?.superview?.superview)
        let cell = sender.view?.superview?.superview as! TicketsTableCellNew
        let indexPath = self.ticketsTable.indexPath(for: cell)
        var ticket = Ticket()
        switch selection {
        case .active:
            ticket = self.viewModel.activeTickets[indexPath!.row]
        case .past:
            ticket = self.viewModel.filteredPastTickets[indexPath!.row]
        }
        if self.tabBarController is HomeTabBarController {
            let home = self.tabBarController as! HomeTabBarController
            home.bookAgainTicket = ticket
        }
        
        for vc in (self.tabBarController?.viewControllers)! where vc is BookingNavigationController {
            let bookingNavVc = vc as! BookingNavigationController
            bookingNavVc.popToRootViewController(animated: false)
        }
        self.tabBarController?.selectedIndex = 1
    }
    
    func logout() {
        let tabVc = self.tabBarController as! HomeTabBarController
        tabVc.logout()
    }
    func goToProfile() {
        let tabVc = self.tabBarController as! HomeTabBarController
        tabVc.goToProfile()
    }
    
    func showAlert(onTap: @escaping (() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            myAlert.message = "Are you sure?".localized(using: "Localization")
            myAlert.showButton2 = true
            myAlert.button2Title = "YES".localized(using: "Localization")
            myAlert.button2OnTap = {
                onTap()
                myAlert.closeTap()
            }
            myAlert.showButton1 = true
            myAlert.button1Title = "NO".localized(using: "Localization")
            myAlert.button1OnTap = myAlert.closeTap
            self.present(myAlert, animated: true, completion: nil)
        })
    }
    
    func showMessage(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            myAlert.message = message
            myAlert.showButton2 = false
            myAlert.showButton1 = true
            myAlert.button1Title = "CLOSE".localized(using: "Localization")
            myAlert.button1OnTap = myAlert.closeTap
            self.present(myAlert, animated: true, completion: nil)
        })
    }
    
    func ViewDownloadedTicket(filename: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            MLog.log(string: "Filename", filename)
            if let url = URL(string: UrlsManager.API + filename) {
                UIApplication.shared.open(url)
            }
          })
        }
    
}
enum TicketTabSelection {
    case active
    case past
}

class TicketsTableCellNew: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ticketIndexLabel: UILabel!
    @IBOutlet weak var ticketQrStatusLabel: UILabel!
    @IBOutlet weak var ticketFullLogo: UIImageView!
    @IBOutlet weak var ticketExpiryLabel: UILabel!
    @IBOutlet weak var listTicketExpiryLabel: UILabel!
    @IBOutlet weak var ticketExpiryValueLabel: UILabel!
    @IBOutlet weak var ticketExpiryProgressView: UIView!
    @IBOutlet weak var ticketExpiryProgressWidth: NSLayoutConstraint!
    @IBOutlet weak var ticketBgFull: UIImageView!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var qrPrev: UIImageView!
    @IBOutlet weak var qrNext: UIImageView!
    @IBOutlet weak var ticketTitle: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var changeStationLabel: UILabel!
    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var ticketIdLabel: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var fareLabel: UILabel!
    @IBOutlet weak var paymentMethodlabel: UILabel!
    @IBOutlet weak var originValueLabel: UILabel!
    @IBOutlet weak var destinationValueLabel: UILabel!
    @IBOutlet weak var changeStationValueLabel: UILabel!
    @IBOutlet weak var ticketValueLabel: UILabel!
    @IBOutlet weak var transactionIdValueLabel: UILabel!
    @IBOutlet weak var ticketIdValueLabel: UILabel!
    
    @IBOutlet weak var paymentMethodValueLabel: UILabel!
    @IBOutlet weak var bookAgain: UIImageView!
    @IBOutlet weak var bookingTimeValueLabel: UILabel!
    @IBOutlet weak var bookingTimeLabel: UILabel!
    @IBOutlet weak var validUntilValueLabel: UILabel!
    @IBOutlet weak var validUntilLabel: UILabel!
    @IBOutlet weak var fareValueLabel: UILabel!
    @IBOutlet weak var entryExpiryLabel: UILabel!
    @IBOutlet weak var exitExpiryLabel: UILabel!
    
    @IBOutlet weak var qrToggle: UIImageView!
    @IBOutlet weak var ticketBgList: UIImageView!
    
    @IBOutlet weak var listOriginLabel: UILabel!
    @IBOutlet weak var listDestinationLabel: UILabel!
    @IBOutlet weak var listTicketLabel: UILabel!
    @IBOutlet weak var listFareLabel: UILabel!
    @IBOutlet weak var listOriginValueLabel: UILabel!
    @IBOutlet weak var listDestinationValueLabel: UILabel!
    @IBOutlet weak var listTicketValueLabel: UILabel!
    @IBOutlet weak var listFareValueLabel: UILabel!
    @IBOutlet weak var qrStack: UIStackView!
    @IBOutlet weak var groupTicketImage: UIImageView!
    @IBOutlet weak var cancelAllButton: ColouredButton!
    @IBOutlet weak var cancelTicketButton: ColouredButton!
    @IBOutlet weak var downloadTicketButton: ColouredButton!
    @IBOutlet weak var ticketPlatformImageFull: UIImageView!
    
    @IBOutlet weak var qrZoomButton: UIButton!
    @IBOutlet weak var qrZoomImageButton: UIButton!
    var qrThumbTapped: ((Int) -> Void)?
    var qrArrowTapped: ((Int) -> Void)?
    
    var cancelImgView: UIImageView!
    var qrZoomView: UIView!
    var qrZoomImageView = UIImageView()
    func setupTicket(ticket: Ticket, qrThumbTapped: @escaping ((Int) -> Void), qrArrowTapped: @escaping ((Int) -> Void), cancelTransactionTap: @escaping (() -> Void), cancelTicketTap: @escaping (() -> Void), downloadTicketTap: @escaping (() -> Void)) {
        self.qrThumbTapped = qrThumbTapped
        self.qrArrowTapped = qrArrowTapped
        
        ticketExpiryLabel.isHidden = !ticket.qrExpanded
        ticketExpiryLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        listTicketExpiryLabel.isHidden = ticket.qrExpanded
        listTicketExpiryLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        ticketExpiryValueLabel.isHidden = false
        ticketExpiryValueLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        ticketExpiryProgressView.isHidden = false
        
        formatExpiry(ticket: ticket)
        
        timeLabel.text = DateUtils.returnString(ticket.issueTime)
        timeLabel.isHidden = ticket.qrExpanded
        timeLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        
        cancelAllButton.backgroundColor = CustomColors.COLOR_PROGRESS_RED
        cancelAllButton.setAttributedTitle(title: NSAttributedString(string: (ticket.status != .fullyCancelled ? "Cancel" : "Cancelled").localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
//        cancelAllButton.isHidden = !ticket.isActive || !ticket.qrExpanded
//        cancelAllButton.onTap = cancelTransactionTap
//        cancelAllButton.setEnable(enable: ticket.status != .fullyCancelled)
        cancelTicketButton.backgroundColor = CustomColors.COLOR_PROGRESS_RED
        if ticket.qrs.count > ticket.qrIndex {
            cancelTicketButton.setAttributedTitle(title: NSAttributedString(string: (ticket.qrs[ticket.qrIndex].status != .cancelled ? "Cancel" : "Cancelled").localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
            cancelTicketButton.isHidden = !ticket.isActive || !ticket.qrExpanded
            cancelTicketButton.onTap = cancelTicketTap
            cancelTicketButton.setEnable(enable: ticket.qrs[ticket.qrIndex].status != .cancelled)
            downloadTicketButton.setEnable(enable: ticket.qrs[ticket.qrIndex].status != .cancelled)
        }
        formatFullView(ticket: ticket)
        
        downloadTicketButton.backgroundColor = CustomColors.COLOR_PROGRESS_BLUE
        downloadTicketButton.setAttributedTitle(title: NSAttributedString(string: "Download".localized(using: "Localization"), attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white]))
        downloadTicketButton.isHidden = !ticket.isActive || !ticket.qrExpanded
        downloadTicketButton.onTap = downloadTicketTap
       
        
        // PMT-1289 Start
        // For hidding camcel and download option
        cancelTicketButton.isHidden = true
        downloadTicketButton.isHidden = true
        //PMT-1289 End
        
        ticketPlatformImageFull.isHidden = !ticket.isActive
        ticketPlatformImageFull.image = self.getPID(fromST: ticket.trip.fromStn.shortName, toST: ticket.trip.toStn.shortName)
       // ticketPlatformImageFull.image = ticket.trip.platform?.getImage()
        
        // List View
        listOriginLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        listOriginLabel.text = "From".localized(using: "Localization")
        listOriginLabel.isHidden = ticket.qrExpanded
        listDestinationLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        listDestinationLabel.text = "To".localized(using: "Localization")
        listDestinationLabel.isHidden = ticket.qrExpanded
        listTicketLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        listTicketLabel.text = "Ticket".localized(using: "Localization")
        listTicketLabel.isHidden = ticket.qrExpanded
        listFareLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        listFareLabel.text = "Fare".localized(using: "Localization")
        listFareLabel.isHidden = ticket.qrExpanded
        
        listOriginValueLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        listOriginValueLabel.text = ticket.trip.fromStn.name
        listOriginValueLabel.isHidden = ticket.qrExpanded
        listDestinationValueLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        listDestinationValueLabel.text = ticket.trip.toStn.name
        listDestinationValueLabel.isHidden = ticket.qrExpanded
        listTicketValueLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        listTicketValueLabel.text = ticket.trip.tripType.rawValue
        listTicketValueLabel.isHidden = ticket.qrExpanded
        listFareValueLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        listFareValueLabel.text = "₹ \(String(format: "%.2f", ticket.trip.fare))"
        listFareValueLabel.isHidden = ticket.qrExpanded
        
        qrImage.isHidden = !ticket.qrExpanded
        qrZoomImageButton.isHidden = !ticket.qrExpanded
        qrZoomImageButton.addTarget(self, action: #selector(qrZoomViewTapped), for: .touchUpInside)
        if ticket.qrExpanded {
            if ticket.qrs.count > ticket.qrIndex {
            qrImage.image = QRUtils.generateQRCode(from: ticket.qrs[ticket.qrIndex].qrStringUpdated)
            qrToggle.image = UIImage(named: "arrow-up")
            // Add Canceled ticket red icon
             if ticket.qrs[ticket.qrIndex].status == .cancelled {
                if (cancelImgView != nil) {
                    cancelImgView.removeFromSuperview()
                }
                cancelImgView = UIImageView(image: UIImage(named: "Cancel-red"))
//                cancelImgView.frame = CGRect(x: 0, y: 0, width: qrImage.frame.height, height: qrImage.frame.height)
                cancelImgView.frame.size.width = qrImage.frame.height
                cancelImgView.frame.size.height = qrImage.frame.height
                cancelImgView.center = CGPoint(x: qrImage.frame.size.width/2,
                                         y: qrImage.frame.size.height/2)
                cancelImgView.contentMode = .scaleAspectFit
                qrImage.addSubview(cancelImgView)
             } else {
                if (cancelImgView != nil) {
                    cancelImgView.removeFromSuperview()
                }
             }
            }
 
        } else {
            qrToggle.image = UIImage(named: "arrow-down")
        }
        
        qrToggle.isHidden = !ticket.qrExpanded
        qrStack.isHidden = ticket.qrExpanded
        groupTicketImage.isHidden = ticket.qrExpanded || ticket.trip.tripType != .group
        qrStack.backgroundColor = .clear
        for subview in qrStack.subviews {
            subview.removeFromSuperview()
        }
        if !ticket.qrExpanded {
            for index in ticket.qrs.indices {
                let qrImageView = UIImageView(image: UIImage(named: "qr-icon-new-1"))
//                let frameX = CGFloat(index * qrStack.frame.height)
                qrImageView.frame = CGRect(x: 0, y: 0, width: qrStack.frame.height, height: qrStack.frame.height)
                qrImageView.contentMode = .scaleAspectFit
//                qrImageView.backgroundColor = .green
                qrImageView.tag = index
                qrImageView.isUserInteractionEnabled = true
                qrImageView.addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(qrImageTapped))))
                qrStack.addArrangedSubview(qrImageView)
            }
            
            do {
                let gif = try UIImage(gifName: "group-ticket.gif")
                groupTicketImage.setGifImage(gif, manager: .defaultManager, loopCount: -1)
            } catch let e {
                MLog.log(string: "Gif Group Error:", e.localizedDescription)
            }
        }
    }
    
    func formatExpiry(ticket: Ticket) {
        let calendar = Calendar.current
        let minutes = calendar.dateComponents([.minute], from: ticket.issueTime, to: Date()).minute!
        ticketExpiryLabel.isHidden = !ticket.qrExpanded
        listTicketExpiryLabel.isHidden = ticket.qrExpanded
//        ticketExpiryValueLabel.isHidden = false
//        ticketExpiryProgressView.isHidden = false
        ticketExpiryValueLabel.isHidden = true
        ticketExpiryProgressView.isHidden = true
        if Globals.TICKET_ENTRY_EXPIRY_MINUTES - minutes < 0 {
            if Globals.TICKET_EXIT_EXPIRY_MINUTES - minutes < 0 {
                ticketExpiryLabel.isHidden = true
                listTicketExpiryLabel.isHidden = true
                ticketExpiryValueLabel.isHidden = true
                ticketExpiryProgressView.isHidden = true
            } else {
                ticketExpiryValueLabel.text = "\(Globals.TICKET_EXIT_EXPIRY_MINUTES - minutes) mins"
                
                let progressWidth = (ticketBgFull.frame.width - 20) * CGFloat(Float(minutes) / Float(Globals.TICKET_EXIT_EXPIRY_MINUTES))
                ticketExpiryProgressWidth.constant = progressWidth
//                ticketExpiryLabel.text = "Exit on this ticket expires in".localized(using: "Localization")
//                listTicketExpiryLabel.text = "Exit on this ticket expires in".localized(using: "Localization")
                ticketExpiryLabel.text = ""
                listTicketExpiryLabel.text = ""
                if Float(minutes) < Float(Globals.TICKET_EXIT_EXPIRY_MINUTES) * 0.4 {
                    ticketExpiryProgressView.backgroundColor = CustomColors.COLOR_PROGRESS_GREEN
                } else if Float(minutes) < Float(Globals.TICKET_EXIT_EXPIRY_MINUTES) * 0.8 {
                    ticketExpiryProgressView.backgroundColor = CustomColors.COLOR_PROGRESS_YELLOW
                } else {
                    ticketExpiryProgressView.backgroundColor = CustomColors.COLOR_PROGRESS_RED
                }
            }
        } else {
            ticketExpiryValueLabel.text = "\(Globals.TICKET_ENTRY_EXPIRY_MINUTES - minutes) mins"
            
            let progressWidth = (ticketBgFull.frame.width - 20) * CGFloat(Float(minutes) / Float(Globals.TICKET_ENTRY_EXPIRY_MINUTES))
            ticketExpiryProgressWidth.constant = progressWidth
//            ticketExpiryLabel.text = "Entry on this ticket expires in".localized(using: "Localization")
//            listTicketExpiryLabel.text = "Entry on this ticket expires in".localized(using: "Localization")
            ticketExpiryLabel.text = ""
            listTicketExpiryLabel.text = ""
            if Float(minutes) < Float(Globals.TICKET_ENTRY_EXPIRY_MINUTES) * 0.4 {
                ticketExpiryProgressView.backgroundColor = CustomColors.COLOR_PROGRESS_GREEN
            } else if Float(minutes) < Float(Globals.TICKET_ENTRY_EXPIRY_MINUTES) * 0.8 {
                ticketExpiryProgressView.backgroundColor = CustomColors.COLOR_PROGRESS_YELLOW
            } else {
                ticketExpiryProgressView.backgroundColor = CustomColors.COLOR_PROGRESS_RED
            }
        }
    }
    
    func formatFullView(ticket: Ticket) {
        
        qrPrev.isHidden = !ticket.qrExpanded || ticket.qrIndex == 0
        qrPrev.tag = ticket.qrIndex - 1
        qrPrev.addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(qrPrevTapped))))
        qrNext.isHidden = !ticket.qrExpanded || ticket.qrIndex == (ticket.qrs.count - 1)
        qrNext.tag = ticket.qrIndex + 1
        qrNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(qrNextTapped)))
        
        ticketIndexLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        ticketIndexLabel.text = "\(ticket.qrIndex + 1)/\(ticket.qrs.count)"
        ticketIndexLabel.isHidden = !ticket.qrExpanded
        ticketQrStatusLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        ticketQrStatusLabel.textAlignment = NSTextAlignment.center
        ticketQrStatusLabel.numberOfLines = 2
        // ticketQrStatusLabel.text = "Platform No\n\(ticket.qrs[ticket.qrIndex].realtimeStatus ?? "null")"
        if ticket.qrs.count > ticket.qrIndex {
            ticketQrStatusLabel.text = (ticket.isActive) ? "Platform No\n\(ticket.qrs[ticket.qrIndex].realtimeStatus ?? "null")" : "\(ticket.qrs[ticket.qrIndex].realtimeStatus ?? "null")"
        }
        ticketQrStatusLabel.isHidden = !ticket.qrExpanded
        ticketFullLogo.isHidden = !ticket.qrExpanded
        
        ticketBgFull.isHidden = !ticket.qrExpanded
        ticketBgList.isHidden = ticket.qrExpanded
        bookAgain.isHidden = ticket.isActive || ticket.qrExpanded
        
        ticketTitle.font = UIFont(name: "Roboto-Regular", size: 16)
        ticketTitle.isHidden = ticket.isActive || !ticket.qrExpanded
        ticketTitle.text = "\("Ticket".localized(using: "Localization")) \(ticket.qrIndex + 1)"
        
        originLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        originLabel.text = "From Station".localized(using: "Localization")
        originLabel.isHidden = !ticket.qrExpanded
        destinationLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        destinationLabel.text = "To Station".localized(using: "Localization")
        destinationLabel.isHidden = !ticket.qrExpanded
        changeStationLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        changeStationLabel.text = "Change Station".localized(using: "Localization")
        changeStationLabel.frame.size.height = 0
        changeStationLabel.isHidden = true // !ticket.qrExpanded
        ticketLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        ticketLabel.text = "Journey Type".localized(using: "Localization")
        ticketLabel.isHidden = !ticket.qrExpanded
        transactionIdLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        transactionIdLabel.text = "Txn Ref No".localized(using: "Localization")
        transactionIdLabel.isHidden = !ticket.qrExpanded
        ticketIdLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        ticketIdLabel.text = "Ticket Serial No".localized(using: "Localization")
        ticketIdLabel.isHidden = !ticket.qrExpanded
        fareLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        fareLabel.text = "Fare".localized(using: "Localization")
        fareLabel.isHidden = !ticket.qrExpanded
        bookingTimeLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        bookingTimeLabel.text = "Booking Time".localized(using: "Localization")
        bookingTimeLabel.isHidden = !ticket.qrExpanded
        paymentMethodlabel.font = UIFont(name: "Roboto-Regular", size: 12)
        paymentMethodlabel.text = "Payment Method".localized(using: "Localization")
        paymentMethodlabel.isHidden = !ticket.qrExpanded
        
        validUntilLabel.isHidden = true
        validUntilValueLabel.isHidden = true
        
        originValueLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        originValueLabel.text = ticket.trip.fromStn.name
        originValueLabel.isHidden = !ticket.qrExpanded
        destinationValueLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        destinationValueLabel.text = ticket.trip.toStn.name
        destinationValueLabel.isHidden = !ticket.qrExpanded
        changeStationValueLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        changeStationValueLabel.text = (ticket.trip.toStn.line == ticket.trip.fromStn.line) ? "-" : "Civil Court"
        changeStationValueLabel.isHidden = true // !ticket.qrExpanded
        changeStationValueLabel.frame.size.height = 0
        ticketValueLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        ticketValueLabel.text = ticket.trip.tripType.rawValue
        ticketValueLabel.isHidden = !ticket.qrExpanded
        transactionIdValueLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        transactionIdValueLabel.text = "\(ticket.extPaymentRef)"
        transactionIdValueLabel.isHidden = !ticket.qrExpanded
        ticketIdValueLabel.adjustsFontSizeToFitWidth = true
        ticketIdValueLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        if ticket.qrs.count > ticket.qrIndex {
        ticketIdValueLabel.text = "\(ticket.qrs[ticket.qrIndex].serial)"
        }
        ticketIdValueLabel.isHidden = !ticket.qrExpanded
        bookingTimeValueLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        bookingTimeValueLabel.text = DateUtils.returnStringDetail(ticket.issueTime)
        bookingTimeValueLabel.isHidden = !ticket.qrExpanded
        fareValueLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        let strFare = ticket.trip.fare / Double(ticket.qrs.count)
        fareValueLabel.text = "₹ \(String(format: "%.2f", strFare))"
        fareValueLabel.isHidden = !ticket.qrExpanded
        paymentMethodValueLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        paymentMethodValueLabel.isHidden = !ticket.qrExpanded
        
        entryExpiryLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        entryExpiryLabel.text = "Entry with this QR code is valid till [TIME]".localized(using: "Localization").replacingOccurrences(of: "[TIME]", with: DateUtils.returnStringDetail(ticket.validityTime)!)
        entryExpiryLabel.isHidden = true//!ticket.qrExpanded
        exitExpiryLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        exitExpiryLabel.text = "Exit with this QR code is valid till [TIME]".localized(using: "Localization").replacingOccurrences(of: "[TIME]", with: DateUtils.returnStringDetail(ticket.exitValidityTime)!)
        exitExpiryLabel.isHidden = true //!ticket.qrExpanded
       
        if ticket.qrExpanded {
            
        }
        qrZoomButton.isHidden = !ticket.qrExpanded
        qrZoomButton.addTarget(self, action: #selector(qrPreview), for: .touchUpInside)
        if ticket.qrs.count > ticket.qrIndex {
        qrZoomImageView.image = QRUtils.generateQRCode(from: ticket.qrs[ticket.qrIndex].qrStringUpdated)
        }
        qrImage.addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(qrZoom))))
    }
    
    @objc func qrImageTapped(_ sender: UITapGestureRecognizer) {
        MLog.log(string: "QR Tapped: ", sender.view?.tag)
        qrThumbTapped!(sender.view!.tag)
    }
    
    @objc func qrPrevTapped(_ sender: UITapGestureRecognizer) {
        MLog.log(string: "QR Prev Tapped: ", sender.view?.tag)
        qrArrowTapped!(sender.view!.tag)
    }
    
    @objc func qrNextTapped(_ sender: UITapGestureRecognizer) {
        MLog.log(string: "QR Next Tapped: ", sender.view?.tag)
        qrArrowTapped!(sender.view!.tag)
    }
    @objc func qrZoom(_ sender: UITapGestureRecognizer) {
        print("double Tapped")
    }
    @objc func qrZoomViewTapped() {
        print("double Tapped")
        showQrZoomView()
    }
   @objc func qrPreview() {
       showQrZoomView()
    }
    @objc func hidePreviewView() {
        qrZoomView.isHidden = true
    }
    func showQrZoomView() {
        //QRZoom view
        qrZoomView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.superview?.superview?.addSubview(qrZoomView)
        qrZoomView.backgroundColor = UIColor.white
        qrZoomView.isHidden = false
        let cancelButton = UIButton.init(frame: CGRect(x: qrZoomView.frame.size.width-60, y: 65, width: 35, height: 35))
        cancelButton.setImage(UIImage(named: "cancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(hidePreviewView), for: .touchUpInside)
        qrZoomView.addSubview(cancelButton)
        qrZoomImageView.frame = CGRect(x:  (qrZoomView.frame.size.width-260)/2, y: (qrZoomView.frame.size.height-260)/2, width: 260, height: 260)
        qrZoomView.addSubview(qrZoomImageView)
        qrZoomImageView.contentMode = .scaleAspectFill
    }
}

enum PgFilter: String {
    case all = "All"
    case card = "Card"
    case payU = "PayU"
    case points = "Points"
}

class DateFilter {
    var startDate: Date?
    var endDate: Date?
    var title: String = ""
}

enum DateRangeFilter: Int {
    case date1 = 0
    case date2 = 1
    case date3 = 2
    case date4 = 3
}

extension TicketsTableCellNew {
    func getPID(fromST: String, toST: String) -> UIImage {
        let pArray = [["stations": "PIM",
                       "PIM": "-",
                       "STG": 1,
                       "BHO": 1,
                       "KWA": 1,
                       "PGD": 1,
                       "VNZ": "",
                       "AND": "",
                       "ICY": "",
                       "NST": "",
                       "GWC": ""
                      ],
                      [
                        "stations": "STG",
                        "PIM": 2,
                        "STG": "-",
                        "BHO": 1,
                        "KWA": 1,
                        "PGD": 1,
                        "VNZ": "",
                        "AND": "",
                        "ICY": "",
                        "NST": "",
                        "GWC": ""
                      ],
                      [
                        "stations": "BHO",
                        "PIM": 2,
                        "STG": 2,
                        "BHO": "-",
                        "KWA": 1,
                        "PGD": 1,
                        "VNZ": "",
                        "AND": "",
                        "ICY": "",
                        "NST": "",
                        "GWC": ""
                      ],
                      [
                        "stations": "KWA",
                        "PIM": 2,
                        "STG": 2,
                        "BHO": 2,
                        "KWA": "-",
                        "PGD": 1,
                        "VNZ": "",
                        "AND": "",
                        "ICY": "",
                        "NST": "",
                        "GWC": ""
                      ],
                      [
                        "stations": "PGD",
                        "PIM": 2,
                        "STG": 2,
                        "BHO": 2,
                        "KWA": 2,
                        "PGD": "-",
                        "VNZ": "",
                        "AND": "",
                        "ICY": "",
                        "NST": "",
                        "GWC": ""
                      ],
                      [
                        "stations": "VNZ",
                        "PIM": "",
                        "STG": "",
                        "BHO": "",
                        "KWA": "",
                        "PGD": "",
                        "VNZ": "-",
                        "AND": 1,
                        "ICY": 1,
                        "NST": 1,
                        "GWC": 1
                      ],
                      [
                        "stations": "AND",
                        "PIM": "",
                        "STG": "",
                        "BHO": "",
                        "KWA": "",
                        "PGD": "",
                        "VNZ": 2,
                        "AND": "-",
                        "ICY": 1,
                        "NST": 1,
                        "GWC": 1
                      ],
                      [
                        "stations": "ICY",
                        "PIM": "",
                        "STG": "",
                        "BHO": "",
                        "KWA": "",
                        "PGD": "",
                        "VNZ": 2,
                        "AND": 2,
                        "ICY": "-",
                        "NST": 1,
                        "GWC": 1
                      ],
                      [
                        "stations": "NST",
                        "PIM": "",
                        "STG": "",
                        "BHO": "",
                        "KWA": "",
                        "PGD": "",
                        "VNZ": 2,
                        "AND": 2,
                        "ICY": 2,
                        "NST": "-",
                        "GWC": 1
                      ],
                      [
                        "stations": "GWC",
                        "PIM": "",
                        "STG": "",
                        "BHO": "",
                        "KWA": "",
                        "PGD": "",
                        "VNZ": 1,
                        "AND": 1,
                        "ICY": 1,
                        "NST": 1,
                        "GWC": "-"
                      ]
        ]
        var img = UIImage(named: "platform-1")
        for s in 0..<pArray.count {
            let dict = pArray[s] as! [String: Any]
            let fST = dict["stations"] as! String
            if fromST == fST {
                let pID = dict[toST] as? Int ?? 0
                img = (pID == 1 ? UIImage(named: "platform-1") : UIImage(named: "platform-2"))!
            }
        }
        return img!
    }
}
