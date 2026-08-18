//
//  LeaveModel.swift
//  SalesJump
//
//  Created by San eforce on 15/08/26.
//

import Foundation

struct LeaveModel: Codable {
    let success: Bool?
    let data: [LeaveData]?
}

struct LeaveData: Codable, Identifiable {
    var id = UUID().uuidString
    let SFCode: String?
    let LeaveCode: String?
    let LeaveValue: Int?
    let LeaveAvailability: Int?
    let LeaveTaken: Int?
    let Leave_SName: String?
    let Leave_Name: String?
    
    enum CodingKeys: String, CodingKey {
        case SFCode
        case LeaveCode
        case LeaveValue
        case LeaveAvailability
        case LeaveTaken
        case Leave_SName
        case Leave_Name
    }
}

struct LeaveSubmitResponse: Codable {
    let status: String?
    let message: String?
    let leave_Id: String?
    let reporting_To_SF: String?
}

struct LeaveHistoryModel: Codable {
    let success: Bool
    let data: [LeaveHistoryData]?
}

struct LeaveHistoryData: Codable, Identifiable {
    var id = UUID().uuidString
    let Leave_Date: String?
    let Created_Date: String?
    let Reason: String?
    let Leave_Type_Name: String?
    let Rejected_Reason: String?
    let No_of_Days: Double?
    let Leave_flag: String?
    let halfday: Double?
    let Leave_status: String?

    enum CodingKeys: String, CodingKey {
        case Leave_Date
        case Created_Date
        case Reason
        case Leave_Type_Name
        case Rejected_Reason
        case No_of_Days
        case Leave_flag
        case halfday
        case Leave_status
    }
}
