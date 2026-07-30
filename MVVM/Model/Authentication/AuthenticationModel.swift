//
//  AuthenticationModel.swift
//  SalesJump
//
//  Created by San eforce on 28/07/26.
//

import Foundation

struct LoginModel: Codable {
    let success: Bool?
    let message: String?
    let response: LoginResponse?
}

struct LoginBiometric: Codable {
    
}

struct LoginResponse: Codable {
    let status_code: String?
    let SF_Code: String?
    let SF_Name: String?
    let Desig_Code: String?
    let SF_Status: Int?
    let Division_Code: String?
    let State_Code: String?
    let SF_Type: Int?
    let SFTPDate: String?
    let IsBiometricneed: LoginBiometric?
    let Logo_Name: String?
    let ProfilePic: String?
    let DeviveRegId: String?
    let IsDayEnd: String?
    let isNonFieldWork: String?
    let hqLatLng: String?
    let sfJoiningDate: String?
    let secOrdToday: Int?
    let priOrdToday: Int?
    let speedoMeterExpStarted: Int?
    let Message: String?
    let Jwt_Token: String?
    let SenderId: String?
    let BaseUrl: String?
    let ServerPath: String?
}

struct UploadImageResponse: Codable {
    let status: [UploadImageStatus]?
}

struct UploadImageStatus: Codable {
    let message: String?
    let fileName: String?
    let imgUrl: String?
}

struct ProfileImageData: Codable {
    let message: String?
    let imageUrl: String?
}
