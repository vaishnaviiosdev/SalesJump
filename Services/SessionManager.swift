//
//  SessionManager.swift
//  SalesJump
//
//  Created by San eforce on 29/07/26.
//

import Foundation

final class SessionManager {
    static let shared = SessionManager()
    private init() {}
    
    var sfCode: String {
        UserDefaults.standard.string(forKey: "Sf_code") ?? ""
    }
    
    var sfName: String {
        UserDefaults.standard.string(forKey: "Sf_Name") ?? ""
    }
    
    var isEventCaptureMandatory: Int {
        UserDefaults.standard.integer(forKey: "Desig_Code")
    }
    
    var senderId: String {
        UserDefaults.standard.string(forKey: "sender_Id") ?? ""
    }
    
    var ProfilePicString: String {
        UserDefaults.standard.string(forKey: "Profile_Pic") ?? ""
    }
    
    var divisionCode: String {
        UserDefaults.standard.string(forKey: "division_Code") ?? ""
    }
    
    var isDayEnd: String {
        UserDefaults.standard.string(forKey: "isDay_End") ?? ""
    }
}
