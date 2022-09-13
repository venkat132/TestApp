//
//  PuneMetroViewModelsTest.swift
//  PuneMetroTests
//
//  Created by Admin on 05/05/21.
//

import XCTest
@testable import PuneMetro
class PuneMetroViewModelsTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSplashModel() throws {
        let model = SplashModel()
        model.validateBiometric = {
            XCTAssert(true, "Data Error condition")
        }
        model.setLoading = { _ in
            
        }
        model.goToSetMPin = {
            XCTAssert(true, "MPIN not set")
        }
        model.goToProfile = {
            XCTAssert(true, "Profile not set")
        }
        model.goToHome = {
            XCTAssert(true, "Successful login")
        }
        model.goToAuth = {
            XCTAssert(true, "enter mPIN")
        }
        model.goToLogin = {
            XCTAssert(true, "new Login")
        }
        model.deviceDidChecked = { used in
            XCTAssert(used, "Device Used before")
        }
        model.userService = UserService(delegate: model)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.userService!, params: UrlsManager.API_USER_CHECK_DEVICE)
        let checkResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {\"usedBefore\":true}}"
        model.onDataReceived(data: checkResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_CHECK_DEVICE)
        var tokenResponse = "{\"code\": 401,\"timestamp\": \"2021-04-21T16:26:50.937Z\",\"body\": {\"idUser\": 0,\"token\": \"asdasads12asda21123\",\"mobile\": \"+918888888888\",\"name\": \"abc\",\"updatedProfile\": false,\"verifiedMobile\": true,\"verifiedEmail\": true,\"verifiedDob\": true,\"verifiedName\": true,\"pinSetup\": false,\"pin\": \"1234\",\"activeTickets\": \"[]\"}}"
        model.onDataReceived(data: tokenResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_VERIFY_TOKEN)
        tokenResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T16:26:50.937Z\",\"body\": {\"idUser\": 0,\"token\": \"asdasads12asda21123\",\"mobile\": \"+918888888888\",\"name\": \"abc\",\"updatedProfile\": false,\"verifiedMobile\": true,\"verifiedEmail\": true,\"verifiedDob\": true,\"verifiedName\": true,\"pinSetup\": false,\"pin\": \"1234\",\"activeTickets\": \"[]\"}}"
        model.onDataReceived(data: tokenResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_VERIFY_TOKEN)
        tokenResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T16:26:50.937Z\",\"body\": {\"idUser\": 0,\"token\": \"asdasads12asda21123\",\"mobile\": \"+918888888888\",\"name\": \"abc\",\"updatedProfile\": false,\"verifiedMobile\": true,\"verifiedEmail\": true,\"verifiedDob\": true,\"verifiedName\": true,\"pinSetup\": true,\"pin\": \"1234\",\"activeTickets\": \"[]\"}}"
        model.onDataReceived(data: tokenResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_VERIFY_TOKEN)
        tokenResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T16:26:50.937Z\",\"body\": {\"idUser\": 0,\"token\": \"asdasads12asda21123\",\"mobile\": \"+918888888888\",\"name\": \"abc\",\"updatedProfile\": true,\"verifiedMobile\": true,\"verifiedEmail\": true,\"verifiedDob\": true,\"verifiedName\": true,\"pinSetup\": true,\"pin\": \"1234\",\"activeTickets\": \"[]\"}}"
        model.onDataReceived(data: tokenResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_VERIFY_TOKEN)
        
    }
    
    func testLoginModel() throws {
        let model = UserLoginViewModel()
        MLog.log(string: "Starting tests")
        var terms: Bool = false
        var info: Bool = false
        var enable: Bool = false
        model.dataDidChange = { t, i, e in
            MLog.log(string: t, i, e)
            terms = t
            info = i
            enable = e
        }
        model.deviceDidChecked = { checked in
            XCTAssert(checked, "Device Checked")
        }
        model.showError = { _ in
            XCTAssert(true, "Device check error")
        }
        
        model.goToPin = { idUser, timestamp in
            XCTAssert(idUser == "0", "idUser matched")
            XCTAssert(timestamp == 123456, "timestamp matched")
        }
        
        model.setLoading = { loading in
            XCTAssert(true, "set Loading \(loading)")
        }
        
        model.mobileNumber = "80"
        XCTAssert((!terms && !info && !enable), "Mobile Invalid, Nothing Selected")
        
        model.isTermsAccepted = false
        XCTAssert((!terms && !info && !enable), "Terms not Accepted")
        model.isTermsAccepted = nil
        XCTAssert((!terms && !info && !enable), "Terms not Accepted")
        model.isInfoAccepted = false
        XCTAssert((!terms && !info && !enable), "Info not Accepted")
        model.isInfoAccepted = nil
        XCTAssert((!terms && !info && !enable), "Info not Accepted")
        model.mobileNumber = "880666"
        XCTAssert((!terms && !terms && !enable), "Wrong Mobile Entered")
        model.mobileNumber = "8806668443"
        XCTAssert((!terms && !terms && enable), "Only Mobile Entered")
        
        model.isTermsAccepted = true
        XCTAssert((terms && !info && enable), "Mobile Entered, Terms Accepted")
        
        model.isInfoAccepted = true
        XCTAssert((terms && info && enable), "Mobile Entered, Terms Accepted, Info Accepted")
        
        model.mobileNumber = "8806668443"
        XCTAssert((terms && info && enable), "Mobile Entered, Terms Accepted, Info Accepted")
        XCTAssert((model.isMobileTextInputValid() == nil), "Valid Mobile Entered")
        
        let initiateLoginResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {\"idUser\": 0,\"mobile\": \"+918411995588\",\"timestampOtpResendEnable\": 123456}}"
        model.userService = UserService(delegate: model)
        model.onDataReceived(data: initiateLoginResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_INITIATE_LOGIN)
        let checkResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {\"usedBefore\":true}}"
        model.onDataReceived(data: checkResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_CHECK_DEVICE)
        
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.userService!, params: UrlsManager.API_USER_CHECK_DEVICE)
    }
    
    func testEnterOTPModel() throws {
        let model = UserEnterOTPModel()
        model.dataDidChange = { enable in
            if model.otp != "1234" {
                XCTAssert(!enable, "Valid OTP Not entered")
            } else {
                XCTAssert(enable, "Valid OTP entered")
            }
        }
        model.setLoading = { _ in
            
        }

        model.showErrorNoTimeout = { _ in
            
        }
        
        model.showError = { err in
            if err == "Wrong OTP entered" {
                XCTAssert(true, "Wrong OTP error")
            } else {
                XCTAssert(true, "Login blocked")
            }
        }
        model.goToMPin = {
            XCTAssert(true, "MPIN not set")
        }
        model.goToProfile = {
            XCTAssert(true, "Profile not set")
        }
        model.goToHome = {
            XCTAssert(true, "Successful login")
        }
        model.otp = "1"
        model.otp = "12"
        model.otp = "123"
        model.otp = "1234"
        
        model.userService = UserService(delegate: model)
        var tokenResponse = "{\"code\": 401,\"timestamp\": \"2021-04-21T16:26:50.937Z\",\"body\": {\"idUser\": 0,\"token\": \"asdasads12asda21123\",\"mobile\": \"+918888888888\",\"name\": \"abc\",\"updatedProfile\": false,\"verifiedMobile\": true,\"verifiedEmail\": true,\"verifiedDob\": true,\"verifiedName\": true,\"pinSetup\": false,\"pin\": \"1234\",\"activeTickets\": \"[]\"}}"
        model.onDataReceived(data: tokenResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_VALIDATE_LOGIN)
        tokenResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T16:26:50.937Z\",\"body\": {\"idUser\": 0,\"token\": \"asdasads12asda21123\",\"mobile\": \"+918888888888\",\"name\": \"abc\",\"updatedProfile\": false,\"verifiedMobile\": true,\"verifiedEmail\": true,\"verifiedDob\": true,\"verifiedName\": true,\"pinSetup\": false,\"pin\": \"1234\",\"activeTickets\": \"[]\"}}"
        model.onDataReceived(data: tokenResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_VALIDATE_LOGIN)
        tokenResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T16:26:50.937Z\",\"body\": {\"idUser\": 0,\"token\": \"asdasads12asda21123\",\"mobile\": \"+918888888888\",\"name\": \"abc\",\"updatedProfile\": false,\"verifiedMobile\": true,\"verifiedEmail\": true,\"verifiedDob\": true,\"verifiedName\": true,\"pinSetup\": true,\"pin\": \"1234\",\"activeTickets\": \"[]\"}}"
        model.onDataReceived(data: tokenResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_VALIDATE_LOGIN)
        tokenResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T16:26:50.937Z\",\"body\": {\"idUser\": 0,\"token\": \"asdasads12asda21123\",\"mobile\": \"+918888888888\",\"name\": \"abc\",\"updatedProfile\": true,\"verifiedMobile\": true,\"verifiedEmail\": true,\"verifiedDob\": true,\"verifiedName\": true,\"pinSetup\": true,\"pin\": \"1234\",\"activeTickets\": \"[]\"}}"
        model.onDataReceived(data: tokenResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_VALIDATE_LOGIN)
        tokenResponse = "{\"code\": 403,\"timestamp\": \"2021-04-21T16:26:50.937Z\",\"message\": \"message-1623994726\"}"
        model.onDataReceived(data: tokenResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_VALIDATE_LOGIN)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.userService!, params: UrlsManager.API_USER_VALIDATE_LOGIN)
    }
    
    func testSetMPinModel() throws {
        let model = UserSetMPinModel()
        model.dataDidChange = {enable in
            if model.isConf! {
                if model.otpConf == "1234" {
                    XCTAssert(enable, "Valid and matching mPIN")
                } else {
                    XCTAssert(!enable, "mPIN not matching")
                }
            } else {
                if model.otp != "1234" {
                    XCTAssert(!enable, "Valid mPIN Not entered")
                } else {
                    XCTAssert(enable, "Valid mPIN entered")
                }
            }
        }
        model.setLoading = { _ in
            
        }
        model.showError = { _ in
            XCTAssert(true, "Login blocked")
        }
        model.goToHome = {
            XCTAssert(true, "going to home")
        }
        
        model.goToProfile = {
            XCTAssert(true, "going to profile")
        }
        
        model.confChange = { isConf in
            XCTAssert(isConf == model.isConf, "Confirmation mPIN")
        }
        model.isConf = false
        model.otp = "1"
        model.otp = "12"
        model.otp = "123"
        model.otp = "1234"
        
        model.isConf = true
        model.otpConf = "1"
        model.otpConf = "12"
        model.otpConf = "123"
        model.otpConf = "1234"
        
        model.userService = UserService(delegate: model)
        let mPinResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {}}"
        LocalDataManager.dataMgr().user.profileUpdated = false
        model.onDataReceived(data: mPinResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_UPDATE_MPIN)
        LocalDataManager.dataMgr().user.profileUpdated = true
        model.onDataReceived(data: mPinResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_UPDATE_MPIN)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.userService!, params: UrlsManager.API_USER_UPDATE_MPIN)
    }
    
    func testAuthModel() throws {
        let model = UserAuthModel()
        model.didMPinChanged = { enable in
            if model.mPin != "1234" {
                XCTAssert(!enable, "Valid mPIN Not entered")
            } else {
                XCTAssert(enable, "Valid mPIN entered")
            }
        }
        model.showError = { _ in
            XCTAssert(true, "Login blocked")
        }
        model.wrongMpinEntered = {
            XCTAssert(true, "Wrong mPIN entered")
        }
        model.goToHome = {
            XCTAssert(true, "going to home")
        }
        model.goToPin = { idUser, mobile in
            XCTAssert(idUser == "0", "idUser matched")
            XCTAssert(mobile == "123456", "mobile matched")
        }
        model.mPin = "1"
        model.mPin = "12"
        model.mPin = "123"
        model.mPin = "1234"
        
        LocalDataManager.dataMgr().user.pin = "1212"
        model.checkOtp()
        LocalDataManager.dataMgr().user.pin = "1234"
        model.checkOtp()
        
        let requestMPINChange = "{\"code\": 200,\"timestamp\": \"2021-04-21T07\"mobile\": \"+918411995588\"}}"
        model.userService = UserService(delegate: model)
        model.onDataReceived(data: requestMPINChange.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_RESET_MPIN_REQUEST_OTP)
        
    }
    
    func testProfileInputModel() throws {
        let model = UserProfileInputModel()
        var i = 0
        model.didInputChanged = { enable in
            if i < 1 {
                XCTAssert(!enable, "insufficient Data entered")
            }
            
        }
        
        model.showError = { err in
            let msgName = model.isNameInputValid()
            let msgEmail = model.isEmailTextInputValid()
            if (model.name?.lengthOfBytes(using: .utf8))! > 3 && msgName != nil {
                XCTAssert(err == "Invalid Name", "Invalid Name Error")
            }
            if (model.email?.lengthOfBytes(using: .utf8))! > 3 && msgEmail != nil {
                XCTAssert(err == "Invalid Email", "Invalid Email Error")
            }
        }
        
        model.name = "A"
        model.name = "A*&^"
        model.name = "ABCD"
        model.email = "abc"
        model.email = "abcd@punemetro.in"
        model.gender = .Male
        model.dobDate = "31"
        model.dobMonth = "Jun"
        model.dobYear = "1990"
        i += 1
        model.dobDate = "31"
        model.dobMonth = "Jan"
        model.dobYear = "1990"
    }
    
    func testProfileConfirmModel() throws {
        let model = UserProfileConfirmModel()
        model.showError = { _ in
            XCTAssert(true, "Login blocked")
        }
        model.goToHome = {
            XCTAssert(true, "going to home")
        }
        
        model.userService = UserService(delegate: model)
        var updateProfileResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {}}"
        model.onDataReceived(data: updateProfileResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_UPDATE_PROFILE)
        updateProfileResponse = "{\"code\": 401,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {}}"
        model.onDataReceived(data: updateProfileResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_UPDATE_PROFILE)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.userService!, params: UrlsManager.API_USER_UPDATE_PROFILE)
        
    }
    
    func testHomeModel() throws {
        let model = HomeModel()
        model.didActiveTicketsReceived = {
            XCTAssert(!model.activeTickets.isEmpty, "active tickets received")
        }
        model.didStationsFetched = {
            XCTAssert(LocalDataManager.dataMgr().stations.count == 3, "Stations Received")
        }
        let stationsResponse = "{\"code\": 200,\"timestamp\": \"2021-05-06T03:42:48.723Z\",\"body\": {  \"stations\": { \"stationDetailsList\": [   {\"_active\":true,\"station_id\":1,\"station_name\":\"kothrud\",\"short_name\":\"kt\",\"line_id\":4,\"station_description\":\"\"},{\"_active\":true,\"station_id\":2,\"station_name\":\"warje\",\"short_name\":\"wj\",\"line_id\":5,\"station_description\":\"\"},{\"_active\":false,\"station_id\":3,\"station_name\":\"karve road\",\"short_name\":\"kvr\",\"line_id\":6,\"station_description\":\"\"}]}}}"
        model.afcsService = AFCSService(delegate: model)
        model.onDataReceived(data: stationsResponse.data(using: .utf8)!, service: model.afcsService!, params: UrlsManager.API_AFCS_GET_STATIONS)
        model.ticketingService = TicketingService(delegate: model)
        
        //
        let ticketsResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {\"tickets\": [{\"id\": \"12\",\"idUser\": 13,\"idSrcStation\": \"2\",\"idDstStation\": \"3\",\"srcStation\": \"warje\",\"dstStation\": \"karve road\",\"groupSize\": 1,\"productId\": 1,\"bookingLatitude\": \"4444\",\"bookingLongitude\": \"4444\",\"amount\": \"20\",\"paymentStatus\": 0,\"idTransaction\":\"abc\",\"serial\": 1234,\"idServiceProvider\": 0,\"idServiceType\": 0, \"qrs\":[{\"id\":\"4\",\"idSrcStation\":\"101\",\"idDstStation\":\"102\",\"srcStation\":\"PCMC\",\"dstStation\":\"Sant Tukaram Nagar\",\"idTransaction\":2,\"ticketStatus\":1,\"qr\":\"asdllkanvkanvalsnva\",\"idTicket\":\"ce7fb883-679f-43bb-85d7-f0991a8b165b\",\"serial\":\"210618M1624015119175\",\"productId\":\"1\",\"groupSize\":3,\"createdAt\":\"2021-06-18T11:18:39.000Z\",\"updatedAt\":\"2021-06-18T11:18:39.000Z\"}]}]}}"
        model.onDataReceived(data: ticketsResponse.data(using: .utf8)!, service: model.ticketingService!, params: UrlsManager.API_TICKETING_GET_ACTIVE_TRIPS)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.ticketingService!, params: UrlsManager.API_TICKETING_GET_ACTIVE_TRIPS)
        
    }
    
    func testBookingModel() throws {
        let model = BookingModel()
        
        model.setLoading = { _ in
            
        }
        
        model.didStationsReceived = {
            XCTAssert(LocalDataManager.dataMgr().stations.count == 3, "Stations Received")
        }
        model.didFareReceived = { fare in
            XCTAssert(fare == 12, "Fare received")
        }
        let stationsResponse = "{\"code\": 200,\"timestamp\": \"2021-05-06T03:42:48.723Z\",\"body\": {  \"stations\": { \"stationDetailsList\": [   {\"_active\":true,\"station_id\":1,\"station_name\":\"kothrud\",\"short_name\":\"kt\",\"line_id\":4,\"station_description\":\"\"},{\"_active\":true,\"station_id\":2,\"station_name\":\"warje\",\"short_name\":\"wj\",\"line_id\":5,\"station_description\":\"\"},{\"_active\":false,\"station_id\":3,\"station_name\":\"karve road\",\"short_name\":\"kvr\",\"line_id\":6,\"station_description\":\"\"}]}}}"
        model.afcsService = AFCSService(delegate: model)
        model.onDataReceived(data: stationsResponse.data(using: .utf8)!, service: model.afcsService!, params: UrlsManager.API_AFCS_GET_STATIONS)
        
        let fareResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {\"fare\": {\"responseBody\": {\"totalFare\": 12}}}}"
        model.onDataReceived(data: fareResponse.data(using: .utf8)!, service: model.afcsService!, params: UrlsManager.API_AFCS_GET_FARE)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.afcsService!, params: UrlsManager.API_AFCS_GET_FARE)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.afcsService!, params: UrlsManager.API_AFCS_GET_STATIONS)
        model.ticketingService = TicketingService(delegate: model)
        let pgKeyResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {\"key\":\"abc\", \"hash_payment_details\":\"axxxxxx\",\"hash_vas_for_mobile\":\"abchckdkdk\", \"token\":\"aagamcmcncbc\"}}"
        model.onDataReceived(data: pgKeyResponse.data(using: .utf8)!, service: model.ticketingService!, params: UrlsManager.API_TICKETING_GET_PAYMENT_GATEWAY_KEY)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.ticketingService!, params: UrlsManager.API_TICKETING_GET_PAYMENT_GATEWAY_KEY)
        
    }
    
    func testConfirmTicketModel() throws {
        let model = ConfirmTicketModel()
                
        model.didCreatedTicket = { ticket in
            XCTAssert(ticket.id == 12, "Ticket created")
        }
        model.didFareReceived = { fare in
            XCTAssert(fare == 12, "Fare received")
        }
        
        model.setLoading = { _ in
            
        }
        
        model.afcsService = AFCSService(delegate: model)
        
        let fareResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {\"amount\": {\"responseBody\": {\"totalFare\": 12}}}}"
        model.onDataReceived(data: fareResponse.data(using: .utf8)!, service: model.afcsService!, params: UrlsManager.API_AFCS_GET_FARE)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.afcsService!, params: UrlsManager.API_AFCS_GET_FARE)
        
        model.ticketingService = TicketingService(delegate: model)
        let createTicketResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {\"ticket\": {\"id\": \"12\",\"idUser\": 13,\"idSrcStation\": \"2\",\"idDstStation\": \"3\",\"srcStation\": \"warje\",\"dstStation\": \"karve road\",\"groupSize\": 1,\"productId\": 1,\"bookingLatitude\": \"4444\",\"bookingLongitude\": \"4444\",\"amount\": \"20\",\"paymentStatus\": 0,\"idTransaction\":\"abc\",\"serial\": 1234,\"idServiceProvider\": 0,\"idServiceType\": 0}}}"
        model.onDataReceived(data: createTicketResponse.data(using: .utf8)!, service: model.ticketingService!, params: UrlsManager.API_TICKETING_CREATE_TICKET)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.ticketingService!, params: UrlsManager.API_TICKETING_CREATE_TICKET)
    }
    
    func testTicketsListModel() throws {
        let model = TicketsListModel()
        model.didActiveTicketsReceived = {
            XCTAssert(model.activeTickets.count == 1, "Active ticket received")
        }
        model.didPastTicketsReceived = {
            XCTAssert(model.pastTickets.count == 1, "Past ticket received")
        }
        
        model.didFiltersChanged = {
            XCTAssert(model.pastTickets.count == 1, "Past ticket received")
        }
        
        model.ticketingService = TicketingService(delegate: model)
        
        let ticketsResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {\"tickets\": [{\"id\": \"12\",\"idUser\": 13,\"idSrcStation\": \"2\",\"idDstStation\": \"3\",\"srcStation\": \"warje\",\"dstStation\": \"karve road\",\"groupSize\": 1,\"productId\": 1,\"bookingLatitude\": \"4444\",\"bookingLongitude\": \"4444\",\"amount\": \"20\",\"paymentStatus\": 0,\"idTransaction\":\"abc\",\"serial\": 1234,\"idServiceProvider\": 0,\"idServiceType\": 0, \"qrs\":[{\"id\":\"4\",\"idSrcStation\":\"101\",\"idDstStation\":\"102\",\"srcStation\":\"PCMC\",\"dstStation\":\"Sant Tukaram Nagar\",\"idTransaction\":2,\"ticketStatus\":1,\"qr\":\"asdllkanvkanvalsnva\",\"idTicket\":\"ce7fb883-679f-43bb-85d7-f0991a8b165b\",\"serial\":\"210618M1624015119175\",\"productId\":\"1\",\"groupSize\":3,\"createdAt\":\"2021-06-18T11:18:39.000Z\",\"updatedAt\":\"2021-06-18T11:18:39.000Z\"}]}]}}"
        model.onDataReceived(data: ticketsResponse.data(using: .utf8)!, service: model.ticketingService!, params: UrlsManager.API_TICKETING_GET_ACTIVE_TRIPS)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.ticketingService!, params: UrlsManager.API_TICKETING_GET_ACTIVE_TRIPS)
        let date = DateFilter()
        date.startDate = Date()
        date.endDate = Date()
        date.title = "Test"
        model.dateRanges = [date]
        model.onDataReceived(data: ticketsResponse.data(using: .utf8)!, service: model.ticketingService!, params: UrlsManager.API_TICKETING_GET_PAST_TRIPS)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.ticketingService!, params: UrlsManager.API_TICKETING_GET_PAST_TRIPS)
        
    }
    
    func testPlacesListModel() throws {
        let model = PlacesListModel()
               
        model.didChangeData = {
            if model.searchString == "aga" {
                XCTAssert(model.places.count >= 1, "Agakhan Palace Found")
            } else if model.searchString == "xyz" {
                XCTAssert(model.places.isEmpty, "No Place found")
            }
        }
        
        model.searchString = "xyz"
        model.searchString = "aga"
    }
    
    func testFareEnquiryModel() throws {
        let model = FareEnquiryModel()
        
        model.didStationsReceived = {
            XCTAssert(LocalDataManager.dataMgr().stations.count == 3, "Stations Received")
        }
        model.didFareReceived = { fare in
            XCTAssert(fare == 12, "Fare received")
        }
        let stationsResponse = "{\"code\": 200,\"timestamp\": \"2021-05-06T03:42:48.723Z\",\"body\": {  \"stations\": { \"stationDetailsList\": [   {\"_active\":true,\"station_id\":1,\"station_name\":\"kothrud\",\"short_name\":\"kt\",\"line_id\":4,\"station_description\":\"\"},{\"_active\":true,\"station_id\":2,\"station_name\":\"warje\",\"short_name\":\"wj\",\"line_id\":5,\"station_description\":\"\"},{\"_active\":false,\"station_id\":3,\"station_name\":\"karve road\",\"short_name\":\"kvr\",\"line_id\":6,\"station_description\":\"\"}]}}}"
        model.afcsService = AFCSService(delegate: model)
        model.onDataReceived(data: stationsResponse.data(using: .utf8)!, service: model.afcsService!, params: UrlsManager.API_AFCS_GET_STATIONS)
        
        let fareResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {\"fare\": {\"responseBody\": {\"totalFare\": 12}}}}"
        model.onDataReceived(data: fareResponse.data(using: .utf8)!, service: model.afcsService!, params: UrlsManager.API_AFCS_GET_FARE)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.afcsService!, params: UrlsManager.API_AFCS_GET_FARE)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.afcsService!, params: UrlsManager.API_AFCS_GET_STATIONS)
    }
    
    func testSmartCardHomeModel() throws {
        let model = SmartCardHomeModel()
        model.didLinkedCardFound = { isTrue in
            XCTAssert(isTrue, "Link Card Found")
        }
        
        model.didBalanceReceived = { Balance in
            XCTAssertNotNil(Balance, "Balance Received")
        }
        
        model.didRequestCardToken = { CardToken in
            XCTAssertNotNil(CardToken, "Card Token Found")
        }
        
        let getLinkCardResponse = "{\"code\":200,\"timestamp\":\"2021-09-14T17:49:34.910Z\",\"body\":{\"linkedCard\":{\"id\":0,\"idUser\":0,\"token\":\"asdasads12asda21123\",\"mobile\":\"+918007007676\"}}}"
        model.smartCardService = SmartCardService(delegate: model)
        model.onDataReceived(data: getLinkCardResponse.data(using: .utf8)!, service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_GET_LINKED)
        
        let getBalanceEnquiryResponse = "{\"code\":200,\"timestamp\":\"2021-09-14T18:07:45.991Z\",\"body\":{\"balance\":\"100\"}}"
        model.onDataReceived(data: getBalanceEnquiryResponse.data(using: .utf8)!, service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_BALANCE_ENQUIRY)
        
        let getrequestCardTokenResponse = "{\"code\":200,\"timestamp\":\"2021-09-14T18:14:47.606Z\",\"body\":{\"refTxnId\":\"asdasads12asda21123\"}}"
        model.onDataReceived(data: getrequestCardTokenResponse.data(using: .utf8)!, service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_REQUEST_TOKEN)
        
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_GET_LINKED)
        
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_BALANCE_ENQUIRY)
        
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_REQUEST_TOKEN)
        
    }
    
    func testSmartCardTopUpModel() throws {
        let model = SmartCardTopUpModel()
       
//        model.didTopUpValidated = { Balance in
//            XCTAssertNotNil(Balance, "Balance Received")
//        }
        
        model.didTransactionReceived = { Transaction in
            XCTAssertNotNil(Transaction, "Transaction Received")
        }
        
        /// Response not available
       /// let getSmartCardTopUpResponse = ""
          model.smartCardService = SmartCardService(delegate: model)
       /// model.onDataReceived(data: getLinkCardResponse.data(using: .utf8)!, service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_VALIDATE_TOPUP)/
        
        let getBalanceEnquiryResponse = "{\"code\":200,\"timestamp\":\"2021-09-14T18:27:36.700Z\",\"body\":{\"transaction\":{\"refTxnId\":\"12\"}}}"
        model.onDataReceived(data: getBalanceEnquiryResponse.data(using: .utf8)!, service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_GET_TRANSACTION)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_GET_TRANSACTION)
        
    }
        
    func testSmartCardOTPModel() throws {
        let model = SmartCardOTPModel()
       
        model.didBalanceReceived = { Balance in
            XCTAssertNotNil(Balance, "Balance Received")
        }
        
        model.goBack = {
            XCTAssertTrue(true, "Token Generated")
        }
        
        model.didDebitProccessed = {
            XCTAssertTrue(true, "Debit Proccessed")
        }
        
        model.smartCardService = SmartCardService(delegate: model)
        let getBalanceEnquiryResponse = "{\"code\":200,\"timestamp\":\"2021-09-14T18:39:08.432Z\",\"body\":{\"balance\":\"100\"}}"
        model.onDataReceived(data: getBalanceEnquiryResponse.data(using: .utf8)!, service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_BALANCE_ENQUIRY)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_BALANCE_ENQUIRY)
        
        let smartCardGenerateModelResponse = "{\"code\":200,\"timestamp\":\"2021-09-14T18:46:54.452Z\",\"body\":{}}"
        model.onDataReceived(data: smartCardGenerateModelResponse.data(using: .utf8)!, service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_GENERATE_TOKEN)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_GENERATE_TOKEN)
        
        let smartCardProcessTopupResponse = "{\"code\":200,\"timestamp\":\"2021-09-14T18:52:17.531Z\",\"body\":{}}"
        model.onDataReceived(data: smartCardProcessTopupResponse.data(using: .utf8)!, service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_PROCESS_TOPUP)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_PROCESS_TOPUP)
        
        let smartCardProcessDebitResponse = "{\"code\":200,\"timestamp\":\"2021-09-14T18:55:36.337Z\",\"body\":{}}"
        model.onDataReceived(data: smartCardProcessDebitResponse.data(using: .utf8)!, service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_PROCESS_DEBIT)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.smartCardService!, params: UrlsManager.API_SMART_CARD_PROCESS_DEBIT)
        

    }
    
    func testUserAccountModel() throws {
        
        let model = UserAccountModel()
        var i = 0
        model.didInputChanged = { enable in
            if i < 1 {
                XCTAssert(!enable, "insufficient Data entered")
            }
            
        }
        model.didReceiveProfile = {
            XCTAssert(true, "User Profile received")
        }
        model.showError = { err in
            let msgName = model.isNameInputValid()
            let msgEmail = model.isEmailTextInputValid()
            if (model.user.name.lengthOfBytes(using: .utf8)) > 3 && msgName != nil {
                XCTAssert(err == "Invalid Name", "Invalid Name Error")
            }
            if (model.user.email.lengthOfBytes(using: .utf8)) > 3 && msgEmail != nil {
                XCTAssert(err == "Invalid Email", "Invalid Email Error")
            }
        }
        
        model.didChangeEdit = {
            XCTAssert(model.isEdit, "Editing")
        }
        model.goBack = {
            XCTAssert(true, "Profile Update successful")
        }
        model.isEdit = true
        model.user = User()
        model.user.name = "A"
        model.user.name = "A*&^"
        model.user.name = "ABCD"
        model.user.email = "abc"
        model.user.email = "abcd@punemetro.in"
        model.user.gender = .Male
        model.dobDate = "31"
        model.dobMonth = "Jun"
        model.dobYear = "1990"
        i += 1
        model.dobDate = "31"
        model.dobMonth = "Jan"
        model.dobYear = "1990"
        
        model.userService = UserService(delegate: model)
        var updateProfileResponse = "{\"code\": 200,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {}}"
        model.onDataReceived(data: updateProfileResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_UPDATE_PROFILE)
        updateProfileResponse = "{\"code\": 401,\"timestamp\": \"2021-04-21T13:16:25.016Z\",\"body\": {}}"
        model.onDataReceived(data: updateProfileResponse.data(using: .utf8)!, service: model.userService!, params: UrlsManager.API_USER_UPDATE_PROFILE)
        model.onDataError(error: URLError.init(.cannotFindHost, userInfo: [:]), service: model.userService!, params: UrlsManager.API_USER_UPDATE_PROFILE)
    }
    
}
