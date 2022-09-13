//
//  DaosManager.swift
//  PuneMetro
//
//  Created by Admin on 20/04/21.
//

import Foundation

class DaosManager {
    // Users DAOs
    static let DAO_USER_CHECK_DEVICE: String = "{\"idDevice\": \"[DEVICE_ID]\",\"token\": \"[FCM_TOKEN]\"}"
    static let DAO_USER_VERIFY_TOKEN: String = "{\"idDevice\": \"[DEVICE_ID]\",\"token\": \"[FCM_TOKEN]\",\"device_type\": \"[DEVICE_TYPE]\",\"version_code\": \"[VERSION_CODE]\"}"
    static let DAO_USER_INITIATE_LOGIN: String = "{\"idServiceProvider\": 0,\"idServiceType\": 0,\"mobile\": \"[MOBILE]\"}"
    static let DAO_USER_VALIDATE_LOGIN: String = "{\"idUser\": [ID_USER],\"otp\": [OTP],\"idDevice\": \"[DEVICE_ID]\"}"
    static let DAO_USER_RESEND_OTP: String = "{\"idUser\": [ID_USER]}"
    static let DAO_USER_UPDATE_PROFILE: String = "{\"idUser\": [ID_USER],\"name\": \"[NAME]\",\"email\": \"[EMAIL]\",\"gender\": [GENDER],\"dobDate\": [DOB_DATE],\"dobMonth\": [DOB_MONTH],\"dobYear\": [DOB_YEAR],\"locale\": \"[LOCALE]\",\"campaignOpted\": \"[CAMPAIGNOPTED]\"}"
    static let DAO_USER_SEND_VERIFY_EMAIL: String = "{\"locale\": \"[LOCALE]\"}"
    static let DAO_USER_RESET_MPIN_VALIDATE_OTP: String = "{\"otp\": [OTP]}"
    static let DAO_USER_UPDATE_MPIN: String = "{\"mPin\": \"[MPIN]\"}"
    static let DAO_USER_VALIDATE_MPIN: String = "{\"mPin\": \"[MPIN]\"}"
    
    // AFCS DAOs
    static let DAO_AFCS_GET_FARE: String = "{\"idSrcStation\": [IDSRCSTATION],\"idDstStation\": [IDDSTSTATION],\"numOfTickets\": [NUMTICKETS],\"productId\": \"[PRODUCTID]\",\"groupSize\": [GROUPOSIZE],\"bookingLatitude\": \"[LAT]\",\"bookingLongitude\": \"[LON]\",\"srcStation\": \"[SRCSTATION]\",\"dstStation\": \"[DSTSTATION]\",\"idServiceProvider\": [IDSERVICEPROVIDER],\"idServiceType\": [IDSERVICETYPE]}"
    static let DAO_AFCS_ISSUE_TICKET: String = "{\"id\": [ID],\"idUser\": [ID_USER],\"idSrcStation\": [IDSRCSTATION],\"srcStation\": \"[NAMESRCSTATION]\",\"idDstStation\": [IDDSTSTATION],\"dstStation\": \"[NAMEDSTSTATION]\",\"groupSize\": [GROUPOSIZE],\"groupTicket\": [GROUPTICKET],\"returnJourney\": [RETURN],\"bookingLatitude\": \"[LAT]\",\"bookingLongitude\": \"[LON]\",\"fare\": [FARE],\"paymentStatus\": 0,\"ticketStatus\": 0,\"idTicket\": \"[IDTICKET]\",\"serial\": [SERIAL],\"productId\": [PRODUCTID],\"idServiceProvider\": 1,\"idServiceType\": 1}"
    
    // Ticketing DAOs
    static let DAO_TICKENTING_GET_PAST_TRIPS: String = "{\"offset\":[OFFSET]}"
    static let DAO_TICKENTING_GET_TICKET: String = "{\"id\": [ID]}"
    static let DAO_TICKENTING_REFUND_TRANSACTION: String = "{\"correlationIdTransaction\": \"[CORR_ID_TR]\"}"
    static let DAO_TICKENTING_REFUND_TICKET: String = "{\"correlationIdTicket\": \"[CORR_ID_TI]\"}"
    static let DAO_DOWNLOAD_TICKET: String = "{\"correlationId\": \"[CORR_ID_TI]\"}"
    static let DAO_TICKETING_CREATE_TICKET: String = "{\"idSrcStation\": [IDSRCSTATION],\"srcStation\": \"[NAMESRCSTATION]\",\"idDstStation\": [IDDSTSTATION],\"dstStation\": \"[NAMEDSTSTATION]\",\"groupTicket\": [GROUPTICKET],\"returnJourney\": [RETURN],\"productId\": \"[PRODUCTID]\",\"paymentMethod\": \"[PAYMENT_METHOD]\",\"fare\": [FARE],\"groupSize\": [GROUPOSIZE],\"bookingLatitude\": \"[LAT]\",\"bookingLongitude\": \"[LON]\",\"idServiceProvider\": 1,\"idServiceType\": 1 }"
    static let DAO_TICKENTING_GET_HASH = "{\"param\": \"[PARAM]\"}"
    static let DAO_TICKETING_ISSUE_AND_UPDATE_QR_TICKET = "{\"idTransaction\": \"[ID]\",\"refTxnId\": \"[TXN_ID]\"}"
    static let DAO_TICKETING_CREATE_TICKET_NEW = "{\"method\": \"PG\"}"
    
    // Smart Card DAOs
    static let DAO_SMART_CARD_GENERATE_TOKEN: String = "{\"refTxnId\": \"[TXN_ID]\",\"otp\": \"[OTP]\"}"
    static let DAO_SMART_CARD_VALIDATE_DEBIT: String = "{\"amount\": \"[AMOUNT]\"}"
    static let DAO_SMART_CARD_PROCESS_DEBIT: String = "{\"amount\": \"[AMOUNT]\",\"otp\": \"[OTP]\",\"refTxnId\": \"[TXN_ID]\"}"
    static let DAO_SMART_CARD_VALIDATE_TOPUP: String = "{\"amount\": \"[AMOUNT]\"}"
    static let DAO_SMART_CARD_PROCESS_TOPUP: String = "{\"amount\": \"[AMOUNT]\",\"otp\": \"[OTP]\",\"refTxnId\": \"[TXN_ID]\"}"
    static let DAO_SMART_CARD_GET_TRANSACTION: String = "{\"idTransaction\":\"[ID_TRANSACTION]\"}"
    
    // KYC DAOs
    static let DAO_KYC_UPLOAD: String = "{\"type\": \"[TYPE]\",\"kyc\": \"[KYC]\"}"
    
    // Journey Planner DAOs
    static let DAO_JOURNEY_PLANNER: String = "{\"searchString\": \"[SEARCHSTRING]\",\"uuid\": \"[UUID]\"}"
    static let DAO_GET_PLACE_DETAILS: String = "{\"idPlace\": \"[IDPLACE]\",\"uuid\": \"[UUID]\"}"
    static let DAO_GET_JOURNEY_PARTS: String = "{\"latitude1\": \"[LATITUDE1]\",\"longitude1\": \"[LONGITUDE1]\",\"latitude2\": \"[LATITUDE2]\",\"longitude2\": \"[LONGITUDE2]\",\"place1\": \"[PLACE1]\",\"placeName1\": \"[PLACENAME1]\",\"place2\": \"[PLACE2]\",\"placeName2\": \"[PLACENAME2]\"}"
    
    // Lost And Found DAOs
    static let DAO_LOST_AND_FOUND_UPLOAD: String = "{\"idUser\": [IDUSER],\"stationName\": \"[STATIONNAME]\",\"location\": \"[LOCATION]\",\"description\": \"[DESCRIPTION]\",\"sourceType\": \"[SOURCETYPE]\",\"articleDescription\": \"[ARTICALDESCRIPTION]\",\"ticketSerialNumber\": \"[TICKETID]\"}"
    static let DAO_LOST_AND_FOUND_GET: String = "{\"idUser\": [IDUSER] }"
    // Lost and Found APIs
    static let DAO_GRIEVENCES_UPLOAD: String = "{\"message\": \"[MESSAGE]\"}"
    
    // Lost and Found APIs
    static let DAO_FEEDBACK_UPLOAD: String = "{\"message\": \"[MESSAGE]\"}"
    // verifyPaymentFunc
    static let VERIFY_PAYMENT: String = "{\"id\": \"[ID]\"}"
    static let DAO_USER_UPDATE_SETTINGS: String = "{\"campaignOpted\": \"[CAMPAIGNOPTED]\",\"enableAppLock\": \"[ENABLEAPPLOCK]\"}"
    
}
