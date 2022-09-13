//
//  StationProps.swift
//  PuneMetro
//
//  Created by Admin on 12/05/21.
//

import Foundation
import UIKit

class StationProps: BaseView {
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var nearestStnLabel: UILabel!
    @IBOutlet weak var nearestStnValLabel: UILabel!
    @IBOutlet weak var dottedLine: UIView!
    @IBOutlet weak var iv11: UIImageView!
    @IBOutlet weak var iv12: UIImageView!
    @IBOutlet weak var iv13: UIImageView!
    @IBOutlet weak var iv14: UIImageView!
    @IBOutlet weak var iv21: UIImageView!
    @IBOutlet weak var iv22: UIImageView!
    @IBOutlet weak var iv23: UIImageView!
    @IBOutlet weak var iv24: UIImageView!
    
    func initWithStation(stn: Station) {
        nearestStnLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        nearestStnValLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        nearestStnValLabel.text = stn.name
        dottedLine.createDottedLine(width: 1, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        
        if !stn.properties.isEmpty {
            iv11.image = stn.getStationPropertyImageNew(prop: stn.properties[0])!.withAlignmentRectInsets(UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15))
        }
        if stn.properties.count > 1 {
            iv12.image = stn.getStationPropertyImageNew(prop: stn.properties[1])!.withAlignmentRectInsets(UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15))
        }
        if stn.properties.count > 2 {
            iv13.image = stn.getStationPropertyImageNew(prop: stn.properties[2])!.withAlignmentRectInsets(UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15))
        }
        if stn.properties.count > 3 {
            iv14.image = stn.getStationPropertyImageNew(prop: stn.properties[3])!.withAlignmentRectInsets(UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15))
        }
        if stn.properties.count > 4 {
            iv21.image = stn.getStationPropertyImageNew(prop: stn.properties[4])!.withAlignmentRectInsets(UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15))
        }
        if stn.properties.count > 5 {
            iv22.image = stn.getStationPropertyImageNew(prop: stn.properties[5])!.withAlignmentRectInsets(UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15))
        }
        if stn.properties.count > 6 {
            iv23.image = stn.getStationPropertyImageNew(prop: stn.properties[6])!.withAlignmentRectInsets(UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15))
        }
        if stn.properties.count > 7 {
            iv24.image = stn.getStationPropertyImageNew(prop: stn.properties[7])!.withAlignmentRectInsets(UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15))
        }
        
        iv11.layer.addBorder(side: .right, thickness: 1, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        iv11.layer.addBorder(side: .bottom, thickness: 1, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        iv12.layer.addBorder(side: .right, thickness: 1, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        iv12.layer.addBorder(side: .bottom, thickness: 1, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        iv13.layer.addBorder(side: .right, thickness: 1, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        iv13.layer.addBorder(side: .bottom, thickness: 1, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        iv14.layer.addBorder(side: .bottom, thickness: 1, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        
        iv21.layer.addBorder(side: .right, thickness: 1, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        iv22.layer.addBorder(side: .right, thickness: 1, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        iv23.layer.addBorder(side: .right, thickness: 1, color: CustomColors.COLOR_MEDIUM_GRAY.cgColor)
        
    }
}
