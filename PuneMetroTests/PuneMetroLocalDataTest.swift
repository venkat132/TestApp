//
//  PuneMetroLocalDataTest.swift
//  PuneMetroTests
//
//  Created by Admin on 18/06/21.
//

import XCTest
@testable import PuneMetro

class PuneMetroLocalDataTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLocalDataManager() throws {
        XCTAssert(LocalDataManager.dataMgr().loadFromDefaults(), "Initial True")
//        XCTAssert(LocalDataManager.dataMgr().user.token == "", "Initial blank token")
        LocalDataManager.dataMgr().user.idUser = 1
        LocalDataManager.dataMgr().user.name = "ABCD"
        LocalDataManager.dataMgr().user.pin = "1212"
        LocalDataManager.dataMgr().user.gender = Gender.Male
        LocalDataManager.dataMgr().user.email = "abcd@punemetro.in"
        LocalDataManager.dataMgr().user.verifiedEmail = true
        LocalDataManager.dataMgr().user.verifiedName = true
        LocalDataManager.dataMgr().user.profileUpdated = true
        LocalDataManager.dataMgr().user.mobile = "8080808080"
        
        LocalDataManager.dataMgr().saveToDefaults()
        
        XCTAssert(LocalDataManager.dataMgr().loadFromDefaults(), "Data Saved")
        XCTAssert(LocalDataManager.dataMgr().user.idUser == 1, "idUser Checked")
        XCTAssert(LocalDataManager.dataMgr().user.name == "ABCD", "name Checked")
        XCTAssert(LocalDataManager.dataMgr().user.pin == "1212", "pin Checked")
        XCTAssert(LocalDataManager.dataMgr().user.gender == Gender.Male, "gender Checked")
        XCTAssert(LocalDataManager.dataMgr().user.email == "abcd@punemetro.in", "email Checked")
        XCTAssert(LocalDataManager.dataMgr().user.mobile == "8080808080", "mobile Checked")
        XCTAssert(LocalDataManager.dataMgr().user.verifiedEmail, "verifiedEmail Checked")
        XCTAssert(LocalDataManager.dataMgr().user.verifiedName, "verifiedName Checked")
        XCTAssert(LocalDataManager.dataMgr().user.profileUpdated, "profileUpdated Checked")
        XCTAssert(LocalDataManager.dataMgr().wrongMPins == 0, "wrong mPINs Checked")
    }

}
