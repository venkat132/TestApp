//
//  MLog.swift
//  All Food Recipes
//
//  Created by Mego Developer on 16/05/18.
//  Copyright © 2018 Mego Developer. All rights reserved.
//

import Foundation

class MLog {

    static func log(string: Any?...) {
        if Globals.LOG {
            print("MeGo Log : ", string)
        }
    }
}
