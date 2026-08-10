//
//  AuthenticationViewModel.swift
//  SalesJump
//
//  Created by San eforce on 28/07/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var loginSuccess = false
    @Published var loginData: LoginModel?
    @Published var showSaveSuccessAlert = false
    @Published var saveSuccessMessage: String = ""
    @Published var uploadImageData: UploadImageResponse?
    @Published var profileImage: UIImage?
    @Published var changePwdData: passwordResponse?
    @Published var ImageData: getImageData?
    @Published var logout: logoutData?
    
    func SignIn(username: String, password: String) async {
    
        let parameters: [String: Any] = [
            "username": username,
            "password": password,
            "app_Version": appVersion ?? "",
            "device_Name": deviceName,
            "device_ID": deviceID,
            "device_Version": deviceVersion,
            "fcM_App_Token": "",
            "loginType": loginType,
            "latitude": "",
            "longitude": ""
        ]
        
        do {
            let response: LoginModel = try await NetworkManager.shared.postJSON(urlString: login_Url, parameters: parameters, responseType: LoginModel.self
            )
            self.loginData = response
            self.showSaveSuccessAlert = true
            self.saveSuccessMessage = response.message ?? "Login Successfully"
            
            
            UserDefaults.standard.set(response.response?.SF_Code ?? "", forKey: "Sf_code")
            UserDefaults.standard.set(response.response?.SF_Name ?? "", forKey: "Sf_Name")
            UserDefaults.standard.set(response.response?.Desig_Code ?? "", forKey: "Desig_Code")
            UserDefaults.standard.set(response.response?.Jwt_Token ?? "", forKey: "jwt_Token")
            UserDefaults.standard.set(response.response?.SenderId ?? "", forKey: "sender_Id")
            UserDefaults.standard.set(response.response?.ProfilePic ?? "", forKey: "Profile_Pic")
            UserDefaults.standard.set(response.response?.Division_Code ?? "", forKey: "division_Code")
            UserDefaults.standard.set(response.response?.IsDayEnd ?? "", forKey: "isDay_End")
            UserDefaults.standard.set(true, forKey: "User_Login")
            
            loginSuccess = true
        }
        catch {
            self.saveSuccessMessage = error.localizedDescription
            self.showSaveSuccessAlert = true
            print("Error fetching data is \(error.localizedDescription)")
        }
    }
    
    func logout(latitude: String, longitude: String) async {
        
        let url = APIClient.shared.qaUrl + "api/\(SessionManager.shared.senderId)/logout"
        
        let parameters: [String: Any] = [
            "sfCode": SessionManager.shared.sfCode,
            "divisionCode": SessionManager.shared.divisionCode,
            "srtEndNd": 0,
            "day": 0,
            "time": "",
            "latitude": latitude,
            "longitude": longitude,
            "remarks": "",
            "dayEndKm": "",
            "isDayEnd": SessionManager.shared.isDayEnd,

            "endKmPhoto": [
                "imgUrl": "",
                "title": "",
                "remarks": ""
            ],

            "stopWorkPhoto": [
                "imgUrl": "",
                "title": "",
                "remarks": ""
            ]
        ]
        
        do {
            let response : logoutData = try await NetworkManager.shared.postTokenJSON(urlString: url, parameters: parameters, responseType: logoutData.self
            )
        
            self.logout = response
            self.showSaveSuccessAlert = true
            self.saveSuccessMessage = response.message ?? "Logout Successfully"
        }
        catch {
            self.showSaveSuccessAlert = true
            self.saveSuccessMessage = error.localizedDescription
        }
    }
    
    func uploadImage(selectedImage: UIImage) async {

        let parameters: [String: Any] = [
            "SF_Code": SessionManager.shared.sfCode,
            "senderId": SessionManager.shared.senderId
        ]

        let url = APIClient.shared.qaUrl + "api/\(SessionManager.shared.senderId)/imageupload"

        do {

            let response: UploadImageResponse =
            try await NetworkManager.shared.uploadMultipart(
                urlString: url,
                parameters: parameters,
                image: selectedImage,
                imageKey: "files",
                responseType: UploadImageResponse.self
            )
            self.uploadImageData = response
            
            if let fileName = response.status?[0].imgUrl {
                await fetchProfileImage(fileName: fileName)
            }
            print("Upload Success")
            print(response)
            showSaveSuccessAlert = true
        }
        catch {
            print("Upload Failed: \(error.localizedDescription)")
            saveSuccessMessage = error.localizedDescription
            showSaveSuccessAlert = true
        }
    }
    
    func saveProfileImage(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        let url = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask)[0]
            .appendingPathComponent("profile.jpg")

        do {
            try data.write(to: url)
            UserDefaults.standard.set(url.path, forKey: "ProfileImagePath")
        } catch {
            print(error)
        }
    }
    
    func loadProfileImage() -> UIImage? {

        guard let path = UserDefaults.standard.string(forKey: "ProfileImagePath") else {
            return nil
        }

        return UIImage(contentsOfFile: path)
    }
        
    func fetchProfileImage(fileName: String) async {

        let senderId = SessionManager.shared.senderId

        var components = URLComponents(
            string: APIClient.shared.qaUrl + "api/\(senderId)/getimagebitmap"
        )!

        components.queryItems = [
            URLQueryItem(name: "fileName", value: fileName),
            URLQueryItem(name: "senderId", value: senderId)
        ]

        guard let url = components.url else { return }

        do {

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("*/*", forHTTPHeaderField: "Accept")

            if let token = UserDefaults.standard.string(forKey: "jwt_Token") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                return
            }

            print("Status:", http.statusCode)

            if let image = UIImage(data: data) {
                self.profileImage = image
                self.saveProfileImage(image)
            }
            else {
                print("Response is not an image")
            }
        }
        catch {
            print(error)
        }
    }
    
    func postTokenJSON<T: Decodable>(
        urlString: String,
        parameters: [String: Any],
        responseType: T.Type
    ) async throws -> T {

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Add JWT Token
        if let token = UserDefaults.standard.string(forKey: "jwt_Token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Authorization: Bearer \(token)")
        } else {
            print("JWT Token not found")
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)

        print("Request URL:", urlString)

        if let body = request.httpBody,
           let json = String(data: body, encoding: .utf8) {
            print("Request Body:", json)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("Status Code:", httpResponse.statusCode)

        if let responseString = String(data: data, encoding: .utf8) {
            print("Response:", responseString)
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func fetchImage(fileName: String) async {

        let senderId = SessionManager.shared.senderId

        var components = URLComponents(
            string: APIClient.shared.qaUrl + "api/\(senderId)/getprofileimage"
        )!

        components.queryItems = [
            URLQueryItem(name: "fileName", value: fileName),
            URLQueryItem(name: "senderId", value: senderId)
        ]

        guard let url = components.url else { return }

        do {

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("*/*", forHTTPHeaderField: "Accept")

            if let token = UserDefaults.standard.string(forKey: "jwt_Token") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                return
            }

            print("Status:", http.statusCode)

            if let image = UIImage(data: data) {
                self.profileImage = image
                self.saveProfileImage(image)
            }
            else {
                print("Response is not an image")
            }
        }
        catch {
            print(error)
        }
    }
    
    func changePassword(pwd: String) async {
        let senderId = SessionManager.shared.senderId

        guard let url = URL(string: APIClient.shared.qaUrl + "api/\(senderId)/changecredential") else {
            return
        }

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            if let token = UserDefaults.standard.string(forKey: "jwt_Token") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            let parameters: [String: Any] = [
                "sfCode": SessionManager.shared.sfCode,
                "passKey": pwd,
            ]

            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                return
            }

            print("Status Code:", http.statusCode)

            let decoder = JSONDecoder()
            let result = try decoder.decode(passwordResponse.self, from: data)
            
            print(result)

            await MainActor.run {
                self.changePwdData = result
                self.showSaveSuccessAlert = true
                self.saveSuccessMessage = result.message ?? "Password Changed"
            }
        }
        catch {
            self.showSaveSuccessAlert = true
            self.saveSuccessMessage = error.localizedDescription
        }
    }
}
