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
    
    func leaveSubmit(fromDate: String, toDate: String, halfDayFlag: Bool, halfDay: String, leaveType: String, noofDays: Double, reason: String) async {
        
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
                    "fileName": "",
                    "imgurl": ""
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
            let response : LeaveSubmitResponse = try await NetworkManager.shared.postJSON(urlString: url, parameters: parameters, responseType: LeaveSubmitResponse.self
            )
            self.leaveSubmit = response
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
}
