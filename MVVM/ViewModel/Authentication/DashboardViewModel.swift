//
//  DashboardViewModel.swift
//  SalesJump
//
//  Created by San eforce on 07/08/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    
    @Published var secondarySales: secondarySalesResponse?
    @Published var primarySales: primarySalesResponse?
    @Published var MTD: MTDResponse?
    @Published var recentActivity: RecentActivityModel?
    
    func getSecondarySales(Type: Int) async {
        
        let todayDate = getTodayDate()
        
        let url =
        APIClient.shared.qaUrl +
        "api/\(SessionManager.shared.senderId)/todayactivity" +
        "?sfCode=\(SessionManager.shared.sfCode)" +
        "&activityDate=\(todayDate)" +
        "&Type=\(Type)"
        
        if Type == 1 {
            do {
                let response : secondarySalesResponse = try await NetworkManager.shared.fetchData(from: url, as: secondarySalesResponse.self)
                self.secondarySales = response
            }
            catch {
                print("Error fetching data is \(error.localizedDescription)")
            }
        }
        else {
            do {
                let response : primarySalesResponse = try await NetworkManager.shared.fetchData(from: url, as: primarySalesResponse.self)
                self.primarySales = response
            }
            catch {
                print("Error fetching data is \(error.localizedDescription)")
            }
        }
    }
    
    func getMTD() async {
        
        let todayDate = getTodayDate()
        
        let url =
        APIClient.shared.qaUrl +
        "api/\(SessionManager.shared.senderId)/monthlist" +
        "?sfCode=\(SessionManager.shared.sfCode)" +
        "&activityDate=\(todayDate)"
        
        do {
            let response : MTDResponse = try await NetworkManager.shared.fetchData(from: url, as: MTDResponse.self
            )
            self.MTD = response
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
    
    func getRecentActivity() async {
        
        let todayDate = getTodayDate()
        
        let url =
        APIClient.shared.qaUrl +
        "api/\(SessionManager.shared.senderId)/recentactivities" +
        "?sfCode=\(SessionManager.shared.sfCode)" +
        "&activityDate=\(todayDate)"
        
        do {
            let response : RecentActivityModel = try await NetworkManager.shared.fetchData(from: url, as: RecentActivityModel.self
            )
            self.recentActivity = response
        }
        catch {
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
}
