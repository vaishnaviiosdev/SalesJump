//
//  DashboardModel.swift
//  SalesJump
//
//  Created by San eforce on 07/08/26.
//

import Foundation

struct secondarySalesResponse: Codable {
    let success: Bool?
    let data : [SecondarySalesData]?
}

struct SecondarySalesData: Codable {
    let Route_Name: String?
    let Route_Code: Int?
    let Visited_Count: Int?
    let Pending_Count: Int?
    let Total_Order_Value: Double?
}

struct primarySalesResponse: Codable {
    let success: Bool?
    let data: [PrimarySalesData]?
}

struct PrimarySalesData: Codable {
    let VisitedCount: Int?
    let PendingCount: Int?
    let TotalCount: Int?
    let TotalOrderValue: Int?
}

struct MTDResponse: Codable {
    let success: Bool?
    let data: [MTDData]?
}

struct MTDData: Codable {
    let Coverage: Int?
    let TotalCalls: Int?
    let ProductiveCalls: Int?
    let TotalOrderValue: String?
    let TargetValue: String?
}

struct RecentActivityModel: Codable {
    let success: Bool?
    let data: [RecentActivityData]?
}

struct RecentActivityData: Codable, Identifiable {
    var id = UUID().uuidString
    let Title: String?
    let Amount: Int?
    let Date: String?
    
    enum CodingKeys: String, CodingKey {
        case Title
        case Amount
        case Date
    }
}
