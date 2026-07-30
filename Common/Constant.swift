//
//  Constant.swift
//  SalesJump
//
//  Created by San eforce on 28/07/26.
//

import Foundation
import UIKit

let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
let deviceName = UIDevice.current.name
let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
let deviceVersion = UIDevice.current.systemVersion
let loginType: String = "fmcg"


var login_Url : String {
    APIClient.shared.qaUrl + "api/login"
}

