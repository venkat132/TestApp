//
//  BookTicketView.swift
//  PuneMetro
//
//  Created by Admin on 20/05/21.
//

import Foundation
import UIKit
protocol BookTicketViewDelegate {
    func numberOfTickets(tickets: Int)
}
class BookTicketView: BaseView {
    
    @IBOutlet weak var journeyPathImage: UIImageView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var originValueLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var destinationValueLabel: UILabel!
    @IBOutlet weak var seperator2: UIView!
    @IBOutlet weak var noOfTicketsLabel: UILabel!
    @IBOutlet weak var groupStack: UIStackView!
    @IBOutlet weak var groupTicketImage: UIImageView!
    @IBOutlet weak var groupSizeDec: UILabel!
    @IBOutlet weak var groupSizeValue: UILabel!
    @IBOutlet weak var groupSizeInc: UILabel!
    @IBOutlet weak var paxStack: UIStackView!
    @IBOutlet weak var pax1: UILabel!
    @IBOutlet weak var pax2: UILabel!
    @IBOutlet weak var pax3: UILabel!
    @IBOutlet weak var pax4: UILabel!
    @IBOutlet weak var pax5: UILabel!
    @IBOutlet weak var pax6: UILabel!
    @IBOutlet weak var seperator3: UIView!
    @IBOutlet weak var totalFareLabel: UILabel!
    @IBOutlet weak var totalFareValueLabel: UILabel!
    @IBOutlet weak var submitButton: FilledButton!
    
    @IBOutlet weak var pax9Stack: UIStackView!
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var paxView: UIView!
    @IBOutlet weak var ticketCollectionView: UICollectionView!
    @IBOutlet weak var disscountLabel: UILabel!
    var selectedPostion: Int = 0
    var delegate: BookTicketViewDelegate?
    func setup(bookingType: BookingType, size: Int) {
        setUpSixPacView()
        if rightArrowButton.isHidden ==  true {
          //  setUpSSelectedixPacView(postion: selectedPostion-5)
            fiveButton.backgroundColor = UIColor.white
            fiveButton.layer.borderColor = UIColor.clear.cgColor
            fiveButton.setTitleColor(UIColor.white, for: .normal)
            fiveButton.layer.borderWidth = 0
            fiveButton.layer.cornerRadius = 0
        } else {
           // setUpSSelectedixPacView(postion: selectedPostion)
        }
        paxView.isHidden = true
        ticketCollectionView.register(cellType: BookTicketCell.self)
        ticketCollectionView.delegate = self
        ticketCollectionView.dataSource = self
        ticketCollectionView.reloadData()
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.clipsToBounds = true
        seperator2.createDottedLine(width: 2, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        seperator3.createDottedLine(width: 2, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        for sub in paxStack.subviews {
            sub.layer.borderWidth = 0.5
            sub.layer.cornerRadius = 10
            sub.clipsToBounds = true
        }
        switch bookingType {
        case .singleJourney:
            setPaxStack(paxNo: size)
            journeyPathImage.image = UIImage(named: "single-journey-path")
        case .returnJourney:
            setPaxStack(paxNo: size)
            journeyPathImage.image = UIImage(named: "return-journey-path")
        case .group:
            setGroupStack(groupSize: size)
            journeyPathImage.image = UIImage(named: "single-journey-path")
        case .multi: MLog.log(string: "Not supported")
        }
    }
    func setUpSixPacView() {
        oneButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        oneButton.backgroundColor = UIColor.white
        oneButton.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        oneButton.setTitleColor(UIColor.black, for: .normal)
        oneButton.layer.borderWidth = 1
        oneButton.layer.cornerRadius = 5
        
        twoButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        twoButton.backgroundColor = UIColor.white
        twoButton.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        twoButton.setTitleColor(UIColor.black, for: .normal)
        twoButton.layer.borderWidth = 1
        twoButton.layer.cornerRadius = 5
        
        threeButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        threeButton.backgroundColor = UIColor.white
        threeButton.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        threeButton.setTitleColor(UIColor.black, for: .normal)
        threeButton.layer.borderWidth = 1
        threeButton.layer.cornerRadius = 5
        
        fourButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        fourButton.backgroundColor = UIColor.white
        fourButton.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        fourButton.setTitleColor(UIColor.black, for: .normal)
        fourButton.layer.borderWidth = 1
        fourButton.layer.cornerRadius = 5
        
        fiveButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        fiveButton.backgroundColor = UIColor.white
        fiveButton.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        fiveButton.setTitleColor(UIColor.black, for: .normal)
        fiveButton.layer.borderWidth = 1
        fiveButton.layer.cornerRadius = 5
    }
    func setUpSSelectedixPacView(postion: Int) {
        switch postion {
        case 1:
            oneButton.backgroundColor = CustomColors.COLOR_ORANGE
            oneButton.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            oneButton.setTitleColor(UIColor.white, for: .normal)
        case 2:
            twoButton.backgroundColor = CustomColors.COLOR_ORANGE
            twoButton.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            twoButton.setTitleColor(UIColor.white, for: .normal)
        case 3:
            threeButton.backgroundColor = CustomColors.COLOR_ORANGE
            threeButton.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            threeButton.setTitleColor(UIColor.white, for: .normal)
        case 4:
            fourButton.backgroundColor = CustomColors.COLOR_ORANGE
            fourButton.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            fourButton.setTitleColor(UIColor.white, for: .normal)
        case 5:
            fiveButton.backgroundColor = CustomColors.COLOR_ORANGE
            fiveButton.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            fiveButton.setTitleColor(UIColor.white, for: .normal)
        default:
            break
        }
    }
    func setPaxStack(paxNo: Int) {
        paxStack.isHidden = true
        pax9Stack.isHidden = false
        groupStack.isHidden = true
        groupTicketImage.isHidden = true
        switch paxNo {
        case 1:
            for subview in paxStack.subviews as! [UILabel] {
                if subview == pax1 {
                    subview.textColor = UIColor.white
                    subview.backgroundColor = CustomColors.COLOR_ORANGE
                    subview.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
                } else {
                    subview.textColor = UIColor.black
                    subview.backgroundColor = UIColor.white
                    subview.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
                }
            }
        case 2:
            for subview in paxStack.subviews as! [UILabel] {
                if subview == pax2 {
                    subview.textColor = UIColor.white
                    subview.backgroundColor = CustomColors.COLOR_ORANGE
                    subview.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
                } else {
                    subview.textColor = UIColor.black
                    subview.backgroundColor = UIColor.white
                    subview.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
                }
            }
        case 3:
            for subview in paxStack.subviews as! [UILabel] {
                if subview == pax3 {
                    subview.textColor = UIColor.white
                    subview.backgroundColor = CustomColors.COLOR_ORANGE
                    subview.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
                } else {
                    subview.textColor = UIColor.black
                    subview.backgroundColor = UIColor.white
                    subview.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
                }
            }
        case 4:
            for subview in paxStack.subviews as! [UILabel] {
                if subview == pax4 {
                    subview.textColor = UIColor.white
                    subview.backgroundColor = CustomColors.COLOR_ORANGE
                    subview.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
                } else {
                    subview.textColor = UIColor.black
                    subview.backgroundColor = UIColor.white
                    subview.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
                }
            }
        case 5:
            for subview in paxStack.subviews as! [UILabel] {
                if subview == pax5 {
                    subview.textColor = UIColor.white
                    subview.backgroundColor = CustomColors.COLOR_ORANGE
                    subview.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
                } else {
                    subview.textColor = UIColor.black
                    subview.backgroundColor = UIColor.white
                    subview.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
                }
            }
        case 6:
            for subview in paxStack.subviews as! [UILabel] {
                if subview == pax6 {
                    subview.textColor = UIColor.white
                    subview.backgroundColor = CustomColors.COLOR_ORANGE
                    subview.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
                } else {
                    subview.textColor = UIColor.black
                    subview.backgroundColor = UIColor.white
                    subview.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
                }
            }
        default:
            MLog.log(string: "Invalid Pax Selection:", paxNo)
        }
    }
    @IBAction func leftArrowButton(_ sender: UIButton) {
        self.leftArrowButton.isHidden = true
        self.rightArrowButton.isHidden = false
        oneButton.setTitle("1", for: .normal)
        twoButton.setTitle("2", for: .normal)
        threeButton.setTitle("3", for: .normal)
        fourButton.setTitle("4", for: .normal)
       // fiveButton.isHidden = false
        setUpSixPacView()
        setUpSSelectedixPacView(postion: selectedPostion)
        fiveButton.backgroundColor = UIColor.white
        fiveButton.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        fiveButton.setTitleColor(UIColor.black, for: .normal)
        fiveButton.layer.borderWidth = 1
        fiveButton.layer.cornerRadius = 5
        
    }
    
    @IBAction func rightArrowButtonTapped(_ sender: UIButton) {
        self.leftArrowButton.isHidden = false
        self.rightArrowButton.isHidden = true
        oneButton.setTitle("6", for: .normal)
        twoButton.setTitle("7", for: .normal)
        threeButton.setTitle("8", for: .normal)
        fourButton.setTitle("9", for: .normal)
       // fiveButton.isHidden = true
        setUpSixPacView()
        if selectedPostion > 5 {
        setUpSSelectedixPacView(postion: selectedPostion-5)
        }
        fiveButton.backgroundColor = UIColor.white
        fiveButton.layer.borderColor = UIColor.clear.cgColor
        fiveButton.setTitleColor(UIColor.white, for: .normal)
        fiveButton.layer.borderWidth = 0
        fiveButton.layer.cornerRadius = 0
        
    }
    
    @IBAction func buttonsTapped(_ sender: UIButton) {
        if (rightArrowButton.isHidden == true) && (sender.tag == 5) {
            return
        }
        setUpSixPacView()
        selectedPostion = sender.tag
        sender.backgroundColor = CustomColors.COLOR_ORANGE
        sender.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
        sender.setTitleColor(UIColor.white, for: .normal)
        if rightArrowButton.isHidden == true {
            fiveButton.backgroundColor = UIColor.white
            fiveButton.layer.borderColor = UIColor.clear.cgColor
            fiveButton.setTitleColor(UIColor.white, for: .normal)
            fiveButton.layer.borderWidth = 0
            fiveButton.layer.cornerRadius = 0
            selectedPostion = sender.tag+5
            if sender.tag != 5 {
                delegate?.numberOfTickets(tickets: selectedPostion)
            }
        } else {
            delegate?.numberOfTickets(tickets: selectedPostion)
        }
        
    }
    func setGroupStack(groupSize: Int) {
        pax9Stack.isHidden = true
        paxView.isHidden = true
        groupStack.isHidden = false
        groupTicketImage.isHidden = false
        
        do {
            let gif = try UIImage(gifName: "group-ticket.gif")
            groupTicketImage.setGifImage(gif, manager: .defaultManager, loopCount: -1)
        } catch let e {
            MLog.log(string: "Gif Group Error:", e.localizedDescription)
        }
        
        groupSizeDec.font = UIFont(name: "Roboto-Regular", size: 25)
        groupSizeDec.textColor = (groupSize > Globals.MIN_GROUP_SIZE) ? .black : CustomColors.COLOR_LIGHT_GRAY
        groupSizeInc.font = UIFont(name: "Roboto-Regular", size: 25)
        groupSizeInc.textColor = (groupSize < Globals.MAX_GROUP_SIZE) ? .black : CustomColors.COLOR_LIGHT_GRAY
        groupSizeValue.font = UIFont(name: "Roboto-Regular", size: 18)
        
        groupStack.layer.borderWidth = 0.5
        groupStack.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        groupStack.layer.cornerRadius = 10
        groupStack.clipsToBounds = true
        
        groupSizeValue.layer.borderWidth = 0.5
        groupSizeValue.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
        groupSizeValue.text = "\(groupSize)"
    }
}
// MARK: - UICollectionViewDataSource
extension BookTicketView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: BookTicketCell.self,
                                                      for: indexPath)
        cell.ticketNumberLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        cell.ticketNumberLabel.text = "\(indexPath.row+1)"
        if self.selectedPostion == indexPath.row {
            cell.ticketNumberLabel.backgroundColor = CustomColors.COLOR_ORANGE
            cell.ticketNumberLabel.layer.borderColor = CustomColors.COLOR_ORANGE.cgColor
            cell.ticketNumberLabel.textColor = UIColor.white
            cell.ticketNumberLabel.layer.masksToBounds = true
        } else {
            cell.ticketNumberLabel.backgroundColor = UIColor.white
            cell.ticketNumberLabel.layer.borderColor = CustomColors.COLOR_MEDIUM_GRAY.cgColor
            cell.ticketNumberLabel.textColor = UIColor.black
        }
        cell.ticketNumberLabel.layer.borderWidth = 1
        cell.ticketNumberLabel.layer.cornerRadius = 5
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPostion = indexPath.row
        self.ticketCollectionView.reloadData()
    }
}

// MARK: - UIScrollViewDelegate
extension BookTicketView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offSet = scrollView.contentOffset.x
//        let width = scrollView.frame.width
//        pageControl.setPageOffset(CGFloat(offSet))
//        currentPageIndex = Int(CGFloat(offSet) / CGFloat(width))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.frame.size.width - 162 ) / 3
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension BookTicketView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 54, height: 54)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.frame.size.width - 162 ) / 4
    }
}
