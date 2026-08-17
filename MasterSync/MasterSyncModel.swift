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
    var HqSf_Code:String
    var isLoading:Bool
    var Count:Int
    var ShowContandLoading:Bool
    var error:Bool
    
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







struct SubordinateResponse: Codable {
    let success: Bool?
    let message: String?
    let dataCount: Int?
    let masterName: String?
    let response: [Subordinate]?
}

struct Subordinate: Codable {
    let id: String?
    let name: String?
    let ownDiv: Int?
    let divisionCode: String?
    let sfDetail: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ownDiv = "OwnDiv"
        case divisionCode = "Division_Code"
        case sfDetail = "SF_Detail"
    }
}




struct WorkTypeResponse: Codable {
    let success: Bool?
    let message: String?
    let dataCount: Int?
    let masterName: String?
    let response: [WorkType]?
}

struct WorkType: Codable {
    let id: Int?
    let name: String?
    let eTabs: String?
    let fWFlg: String?
    let placeInvolved: String?
    let wTypeSName: String?
    let expNeeded: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case eTabs = "ETabs"
        case fWFlg = "FWFlg"
        case placeInvolved = "Place_Involved"
        case wTypeSName = "WType_SName"
        case expNeeded = "exp_needed"
    }
}





struct DistributorResponse: Codable {
    let success: Bool?
    let message: String?
    let dataCount: Int?
    let masterName: String?
    let response: [Distributor]?
}

struct Distributor: Codable, Identifiable {
    let id: Int?
    let name: String?
    let contactPerson: String?
    let townCode: String?
    let townName: String?
    let addr1: String?
    let addr2: String?
    let city: String?
    let pincode: String?
    let gstn: String?
    let lat: String?
    let long: String?
    let addrs: String?
    let tcode: String?
    let mobile: String?
    let fieldCode: String?
    let fieldName: String?
    let listedDrCount: Int?
    let outletCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case contactPerson = "contact_person"
        case townCode = "Town_Code"
        case townName = "Town_Name"
        case addr1 = "Addr1"
        case addr2 = "Addr2"
        case city = "City"
        case pincode = "Pincode"
        case gstn = "GSTN"
        case lat
        case long
        case addrs
        case tcode = "Tcode"
        case mobile
        case fieldCode = "field_code"
        case fieldName = "field_name"
        case listedDrCount = "ListedDrCount"
        case outletCount = "OutletCount"
    }
}






struct RouteResponse: Codable {
    let success: Bool?
    let message: String?
    let dataCount: Int?
    let masterName: String?
    let response: [Route]?

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case dataCount
        case masterName
        case response
    }
}

struct Route: Codable, Identifiable {
    let id: Int?
    let name: String?
    let target: String?
    let minProd: String?
    let fieldCode: String?
    let stockistCode: String?
    let allowanceType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case target
        case minProd = "min_prod"
        case fieldCode = "field_code"
        case stockistCode = "stockist_code"
        case allowanceType = "Allowance_Type"
    }
}





struct JointWorkResponse: Codable {
    let success: Bool?
    let message: String?
    let dataCount: Int?
    let masterName: String?
    let response: [MasterJointWork]?
}

struct MasterJointWork: Codable, Identifiable {
    let id: String?
    let name: String?
    let desig: String?
}
