//
//  GenericServiceDelegate.swift
//  kPoint
//
//  Created by Mego Developer on 29/05/20.
//  Copyright © 2020 Mego Developer. All rights reserved.
//

import Foundation
@objc protocol GenericServiceDelegate: NSObjectProtocol {
    @objc func onDataReceived(data: Data, service: GenericService, params: String)
    @objc func onDataError(error: Error, service: GenericService, params: String)

}
