//
//  LeaveViewModel.swift
//  SalesJump
//
//  Created by San eforce on 17/08/26.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class LeaveViewModel: ObservableObject {
    @Published var leaveSubmit: LeaveSubmitResponse?
    @Published var leaveHistory: LeaveHistoryModel?
    @Published var showSaveSuccessAlert = false
    @Published var saveSuccessMessage: String = ""
    
    func leaveSubmit(fromDate: String, toDate: String, halfDayFlag: Bool, halfDay: String, leaveType: String, noofDays: Double, reason: String, imageUrl: String, fileName: String) async {
        
        let todayDate = getTodayDateTime()
        
        let parameters: [String: Any] = [
            "address": "",
            "divisioncode": SessionManager.shared.divisionCode,
            "from_date": fromDate,
            "half_flag": halfDayFlag,
            "half_leave_id": 0,
            "halfday": halfDay,
            "img_url": [
                [
                    "fileName": fileName,
                    "imgurl": imageUrl
                ]
            ],
            "leave_type": leaveType,
            "no_of_days": "\(noofDays)",
            "reason": reason,
            "sfcode": SessionManager.shared.sfCode,
            "sfname": SessionManager.shared.sfName,
            "to_date": toDate,
            "currentZoneDateTime": todayDate
        ]
        
        let url = APIClient.shared.qaUrl + "api/\(SessionManager.shared.senderId)/leavesubmit"
        
        do {
            let response : LeaveSubmitResponse = try await NetworkManager.shared.postTokenJSON(urlString: url, parameters: parameters, responseType: LeaveSubmitResponse.self
            )
            self.leaveSubmit = response
            self.showSaveSuccessAlert = true
            self.saveSuccessMessage = response.message ?? "Leave Submitted"
        }
        catch {
            self.showSaveSuccessAlert = true
            self.saveSuccessMessage = error.localizedDescription
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
    
    func fetchLeaveHistory(SelectedYear: Int) async {
        
        let url =
        APIClient.shared.qaUrl +
        "api/\(SessionManager.shared.senderId)/leavehistory" +
        "?sfCode=\(SessionManager.shared.sfCode)" +
        "&Year=\(SelectedYear)" + "&DivisionCode=\(SessionManager.shared.divisionCode)"
        
        do {
            let response : LeaveHistoryModel = try await NetworkManager.shared.fetchData(from: url, as: LeaveHistoryModel.self
            )
            self.leaveHistory = response
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
}
