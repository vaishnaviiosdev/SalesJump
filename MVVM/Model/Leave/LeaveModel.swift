//
//  LeaveModel.swift
//  SalesJump
//
//  Created by San eforce on 18/08/26.
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
