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
            self.saveSuccessMessage = response.message ?? "Login Successfully"
            self.showSaveSuccessAlert = true
            
            UserDefaults.standard.set(response.response?.SF_Code ?? "", forKey: "Sf_code")
            UserDefaults.standard.set(response.response?.SF_Name ?? "", forKey: "Sf_Name")
            UserDefaults.standard.set(response.response?.Desig_Code ?? "", forKey: "Desig_Code")
            UserDefaults.standard.set(response.response?.Jwt_Token ?? "", forKey: "jwt_Token")
            UserDefaults.standard.set(response.response?.SenderId ?? "", forKey: "sender_Id")
            UserDefaults.standard.set(true, forKey: "User_Login")
            
            loginSuccess = true
        }
        catch {
            self.saveSuccessMessage = error.localizedDescription
            self.showSaveSuccessAlert = true
            print("Error fetching data is \(error.localizedDescription)")
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
}
