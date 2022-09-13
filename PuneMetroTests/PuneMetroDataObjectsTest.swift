//
//  PuneMetroDataObjectsTest.swift
//  PuneMetroTests
//
//  Created by Admin on 18/06/21.
//

import XCTest
@testable import PuneMetro
class PuneMetroDataObjectsTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUser() throws {
        let user = User()
        let userResponse = "{\"idUser\": 0,\"token\": \"asdasads12asda21123\",\"mobile\": \"+918888888888\",\"name\": \"abc\",\"updatedProfile\": true,\"verifiedMobile\": true,\"verifiedEmail\": true,\"verifiedDob\": true,\"verifiedName\": true,\"pinSetup\": true,\"pin\": \"1234\",\"activeTickets\": \"[]\"}"
        do {
            let userObj = try JSONSerialization.jsonObject(with: userResponse.data(using: .utf8)!, options: []) as! [AnyHashable: Any]
            user.initWithDictionary(userInfoJSON: userObj)
            XCTAssert(user.idUser == 0, "id Checked")
            XCTAssert(user.token == "asdasads12asda21123", "id Checked")
        } catch let e {
            XCTAssert(false, e.localizedDescription)
        }
        
        let userNilResponse = "{\"idUser\": 0,\"token\": \"asdasads12asda21123\",\"mobile\": \"+918888888888\",\"verifiedMobile\": true,\"verifiedEmail\": true,\"verifiedDob\": true,\"verifiedName\": true,\"pinSetup\": false,\"pin\": null,\"activeTickets\": \"[]\"}"
        do {
            let userObj = try JSONSerialization.jsonObject(with: userNilResponse.data(using: .utf8)!, options: []) as! [AnyHashable: Any]
            
            user.initWithDictionary(userInfoJSON: userObj)
            XCTAssert(user.idUser == 0, "id Checked nil")
            XCTAssert(user.token == "asdasads12asda21123", "token Checked nil")
        } catch let e {
            XCTAssert(false, e.localizedDescription)
        }
        
        user.gender = .Male
        XCTAssert(user.gender?.toIntVal() == 0, "Gender 0 checked")
        user.gender = .Female
        XCTAssert(user.gender?.toIntVal() == 1, "Gender 1 checked")
        user.gender = .Transgender
        XCTAssert(user.gender?.toIntVal() == 2, "Gender 2 checked")
        
        let userProfileResponse = "{\"idUser\":0,\"name\":\"abc\",\"dobDate\":1,\"dobMonth\":1,\"dobYear\":2021,\"email\":\"abc@pqr.com\",\"gender\":0}"
        do {
            let userProfileObj = try JSONSerialization.jsonObject(with: userProfileResponse.data(using: .utf8)!, options: []) as! [AnyHashable: Any]
            
            user.initWithProfileDictionary(profileJSON: userProfileObj)
            XCTAssert(user.idUser == 0, "id Checked")
            XCTAssert(user.name == "abc", "name Checked")
            XCTAssert(user.email == "abc@pqr.com", "email Checked")
            XCTAssert(user.dob == Date(timeIntervalSince1970: 1609439400), "DOB Checked")
        } catch let e {
            XCTAssert(false, e.localizedDescription)
        }
        
    }
    
    func testStation() throws {
        let stationResponse = "{\"station_id\":1,\"station_name\":\"PCMC\",\"short_name\":\"PCM\",\"station_description\":\"trial description\",\"station_image\":\"station detail\",\"station_properties\":[\"terminal\",\"disabled\",\"escalator\",\"lift\",\"shops\",\"washroom\",\"parking\",\"drinkingWater\"],\"line_id\":1}"
        let station = Station()
        do {
            let stationObj = try JSONSerialization.jsonObject(with: stationResponse.data(using: .utf8)!, options: []) as! [AnyHashable: Any]
            station.initWithDictionary(stnInfoJSON: stationObj)
            XCTAssert(station.idStation == 1, "Station id matched")
            XCTAssert(station.toJson() == stationResponse, "Json string matched")
            LocalDataManager.dataMgr().stations.append(station)
        } catch let e {
            XCTAssert(false, e.localizedDescription)
        }
        
        let stationNilResponse1 = "{\"station_id\":2,\"station_name\":\"PCMC\",\"station_description\":\"trial description\",\"station_image\":\"station detail\",\"station_properties\":[\"terminal\",\"disabled\",\"escalator\",\"lift\",\"shops\",\"washroom\",\"parking\",\"drinkingWater\"],\"line_id\":1}"
        let station2 = Station()
        do {
            let stationObj = try JSONSerialization.jsonObject(with: stationNilResponse1.data(using: .utf8)!, options: []) as! [AnyHashable: Any]
            station2.initWithDictionary(stnInfoJSON: stationObj)
            XCTAssert(station2.idStation == 2, "Station id matched")
            LocalDataManager.dataMgr().stations.append(station2)
        } catch let e {
            XCTAssert(false, e.localizedDescription)
        }
    }
    
    func testTicket() throws {
        let ticketResponse = "{\"id\": \"12\",\"idUser\": 13,\"idSrcStation\": \"1\",\"idDstStation\": \"2\",\"srcStation\": \"warje\",\"dstStation\": \"karve road\",\"groupSize\": 1,\"productId\": 1,\"bookingLatitude\": \"4444\",\"bookingLongitude\": \"4444\",\"amount\": \"20\",\"paymentStatus\": 0,\"idTransaction\":\"abc\",\"serial\": 1234,\"idServiceProvider\": 0,\"idServiceType\": 0, \"qrs\":[{\"id\":\"4\",\"idSrcStation\":\"1\",\"idDstStation\":\"2\",\"srcStation\":\"PCMC\",\"dstStation\":\"Sant Tukaram Nagar\",\"idTransaction\":2,\"ticketStatus\":1,\"qr\":\"asdllkanvkanvalsnva\",\"idTicket\":\"ce7fb883-679f-43bb-85d7-f0991a8b165b\",\"serial\":\"210618M1624015119175\",\"productId\":\"1\",\"groupSize\":3,\"createTimestamp\": 1624015104,\"paymentTimestamp\": 1624015119,\"issueTimestamp\": 1624015119,\"validityTimestamp\": 1624045719,\"createdAt\":\"2021-06-18T11:18:39.000Z\",\"updatedAt\":\"2021-06-18T11:18:39.000Z\"}]}"
        let ticket = Ticket()
        do {
            let ticketObj = try JSONSerialization.jsonObject(with: ticketResponse.data(using: .utf8)!, options: []) as! [AnyHashable: Any]
            MLog.log(string: ticket.id)
            ticket.initWithDictionary(ticketObj: ticketObj)
            XCTAssert(ticket.id == 12, "id Matched")
            XCTAssert(QRUtils.generateQRCode(from: ticket.qrs[0].qrString) != nil, "QR image created")
        } catch let e {
            XCTAssert(false, e.localizedDescription)
        }
    }
    
    func testPlaces() throws {
        let placesObject = "{\"name\": \"moraya-gosavi-temple-name\",\"details\": \"moraya-gosavi-temple-details\",\"image\": \"morya_gosavi_ganpati_temple\",\"nearStn\": \"PCM\",\"distance\": 4}"
        
        do {
            let placesObj = try JSONSerialization.jsonObject(with: placesObject.data(using: .utf8)!, options: []) as! [AnyHashable: Any]
            let places = TourPlace.init(jsonObj: placesObj)
            XCTAssert(places.title == "moraya-gosavi-temple-name", "Name Matched")
            XCTAssertFalse(places.title == "moraya-gosavi-temple", "Name Not Matched")
        } catch let e {
            XCTAssert(false, e.localizedDescription)
        }
    }
    
    func testFeederServices() throws {
        let placesObject = "{\"title\":\"Rickshaw\",\"details\":\"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\",\"logoImage\":\"rickshaw-logo\",\"category\":\"Rickshaw\"}"
        
        do {
            let serviceObj = try JSONSerialization.jsonObject(with: placesObject.data(using: .utf8)!, options: []) as! [AnyHashable: Any]
            let feederService = FeederService(serviceObj: serviceObj)
            XCTAssert(feederService.title == "Rickshaw", "Name Matched")
            XCTAssertFalse(feederService.title == "RickshawW", "Name Not Matched")
        } catch let e {
            XCTAssert(false, e.localizedDescription)
        }
    }
}
