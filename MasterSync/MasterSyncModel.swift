//
//  MasterSyncModel.swift
//  SalesJump
//
//  Created by Saneforce on 11/08/26.
//

import Foundation


struct MasterSync: Codable {
    let id:Int
    let Name:String
    let Master_Name:String
    let SF_Code:String
    let State_Code:String
    let Division_Code:String
    let HqSf_Code:String
    var isLoading:Bool
    var Count:Int
    var ShowContandLoading:Bool
    
}


struct RetailerResponse: Codable {
    let masterName: String
    let response: [Retailer]
    
    enum CodingKeys: String, CodingKey {
        case masterName = "masterName"
        case response = "response"
    }
}

struct Retailer: Codable, Identifiable {
    
    let id: Int?
    let name: String?
    let townCode: String?
    let townName: String?
    let image: String?
    let outstandingAmount: Double?
    let lat: String?
    let long: String?
    let addrs: String?
    let listedDrAddress1: String?
    let listedDrSlNo: String?
    let mobileNumber: String?
    let docCatCode: Int?
    let contactPersion: String?
    let docSpecialCode: Int?
    let distributorCode: String?
    let doctorCode: Int?
    let gst: String?
    let createdDate: String?
    let doctorActiveFlag: String?
    let listedDrEmail: String?
    let specDocCode: String?
    let debtorCode: String?
    let creditLimit: Double?
    let creditDays: Double?
    let retailerCategory: String?
    let retailerClass: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case townCode = "town_code"
        case townName = "town_name"
        case image = "Image"
        case outstandingAmount = "outstandingamount"
        case lat
        case long
        case addrs
        case listedDrAddress1 = "ListedDr_Address1"
        case listedDrSlNo = "ListedDr_Sl_No"
        case mobileNumber = "Mobile_Number"
        case docCatCode = "Doc_Cat_Code"
        case contactPersion = "ContactPersion"
        case docSpecialCode = "Doc_Special_Code"
        case distributorCode = "Distributor_Code"
        case doctorCode = "Doctor_Code"
        case gst
        case createdDate
        case doctorActiveFlag = "Doctor_Active_flag"
        case listedDrEmail = "ListedDr_Email"
        case specDocCode = "Spec_Doc_Code"
        case debtorCode = "debtor_code"
        case creditLimit = "Credit_Limit"
        case creditDays = "Credit_Days"
        case retailerCategory = "Retailer_Category"
        case retailerClass = "Retailer_Class"
        case imageUrl
    }
}
