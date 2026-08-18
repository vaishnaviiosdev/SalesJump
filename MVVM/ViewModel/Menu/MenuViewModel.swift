//
//  MenuViewModel.swift
//  SalesJump
//
//  Created by San eforce on 15/08/26.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class MenuViewModel: ObservableObject {
    @Published var leaveTypes: [LeaveData] = []
    @Published var leave: LeaveModel?
    
    func fetchLeaveType() async {
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let url =
        APIClient.shared.qaUrl +
        "api/\(SessionManager.shared.senderId)/leavedetails" +
        "?sfCode=\(SessionManager.shared.sfCode)" +
        "&Year=\(currentYear)"
        
        do {
            let response : LeaveModel = try await NetworkManager.shared.fetchData(from: url, as: LeaveModel.self
            )
            self.leave = response
            self.leaveTypes = response.data ?? []
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
}
