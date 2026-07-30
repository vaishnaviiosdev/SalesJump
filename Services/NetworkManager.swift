//
//  NetworkManager.swift
//  SalesJump
//
//  Created by San eforce on 28/07/26.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(
        from urlString: String,
        as type: T.Type
    ) async throws -> T {

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        print("Requesting URL:", url)

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            request.cachePolicy = .reloadIgnoringLocalCacheData

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status:", httpResponse.statusCode)

                guard 200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("The Fetch Data Response is:\n\(responseString)")
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return try decoder.decode(T.self, from: data)
        }
        catch let DecodingError.typeMismatch(type, context) {
            print("Type mismatch for \(type):", context.debugDescription)
            print("CodingPath:", context.codingPath)
            throw DecodingError.typeMismatch(type, context)
        }
        catch let DecodingError.keyNotFound(key, context) {
            print("Missing key '\(key.stringValue)':", context.debugDescription)
            print("CodingPath:", context.codingPath)
            throw DecodingError.keyNotFound(key, context)
        }
        catch let DecodingError.valueNotFound(value, context) {
            print("Value not found for \(value):", context.debugDescription)
            print("CodingPath:", context.codingPath)
            throw DecodingError.valueNotFound(value, context)
        }
        catch {
            print("Error fetching data:", error.localizedDescription)
            throw error
        }
    }

//    func postDatas<T: Decodable>(
//        urlString: String,
//        parameters: [String: Any],
//        responseType: T.Type
//    ) async throws -> T {
//
//        guard let url = URL(string: urlString) else {
//            throw URLError(.badURL)
//        }
//
//        var components = URLComponents()
//
//        components.queryItems = parameters.map { key, value in
//            // If value is array/dictionary, convert to JSON string
//            if JSONSerialization.isValidJSONObject(value) {
//                if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []),
//                   let jsonString = String(data: jsonData, encoding: .utf8) {
//                    return URLQueryItem(name: key, value: jsonString)
//                } else {
//                    return URLQueryItem(name: key, value: "\(value)")
//                }
//            }
//            else {
//                return URLQueryItem(name: key, value: "\(value)")
//            }
//        }
//
//        guard let bodyData = components.percentEncodedQuery?.data(using: .utf8) else {
//            throw URLError(.badURL)
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue(
//            "application/x-www-form-urlencoded",
//            forHTTPHeaderField: "Content-Type"
//        )
//        request.httpBody = bodyData
//
//        print("Request URL:", urlString)
//        print("Encoded Body:", components.percentEncodedQuery ?? "")
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              200..<300 ~= httpResponse.statusCode else {
//            throw URLError(.badServerResponse)
//        }
//
//        if let responseString = String(data: data, encoding: .utf8) {
//            print("Raw Response:", responseString)
//        }
//
//        return try JSONDecoder().decode(T.self, from: data)
//    }
    
    func postJSON<T: Decodable>(//Raw JSON
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

    func postFormData<T: Decodable>(
            urlString: String,
            parameters: [String: Any],
            responseType: T.Type
        ) async throws -> T {
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }

            // Extract only "data"
            guard let dataValue = parameters["data"] else {
                throw URLError(.cannotParseResponse)
            }

            print(parameters)

            // Convert to JSON string
            let jsonData = try JSONSerialization.data(withJSONObject: dataValue)
            let jsonString = String(data: jsonData, encoding: .utf8)!

            // Convert to x-www-form-urlencoded
            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "data", value: jsonString)
            ]

            guard let bodyData = components.percentEncodedQuery?.data(using: .utf8) else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(
                "application/x-www-form-urlencoded",
                forHTTPHeaderField: "Content-Type"
            )
            request.httpBody = bodyData
            
            request.cachePolicy = .reloadIgnoringLocalCacheData

            print("Request URL:", urlString)
            print("Encoded Body:", components.percentEncodedQuery ?? "")

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw Response:", responseString)
            }
            else {
                print("error")
            }

            return try JSONDecoder().decode(T.self, from: data)
    }
    
    func uploadMultipart<T: Decodable>(
        urlString: String,
        parameters: [String: Any],
        image: UIImage?,
        imageKey: String,
        fileName: String = "image.jpg",
        mimeType: String = "image/jpeg",
        responseType: T.Type
    ) async throws -> T {

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        print("===================================")
        print("Upload URL: \(url.absoluteString)")
        print("HTTP Method: POST")
        print("Parameters: \(parameters)")
        print("Image Key: \(imageKey)")
        print("===================================")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")

        if let token = UserDefaults.standard.string(forKey: "jwt_Token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Authorization: Bearer \(token)")
        }

        var body = Data()

        // Parameters
        for (key, value) in parameters {

            print("Parameter -> \(key) : \(value)")

            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        // Image
        if let image = image,
           let imageData = image.jpegData(compressionQuality: 0.8) {

            print("Image Size: \(imageData.count) bytes")

            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(imageKey)\"; filename=\"\(fileName)\"\r\n")
            body.append("Content-Type: \(mimeType)\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        } else {
            print("No Image Found")
        }

        body.append("--\(boundary)--\r\n")

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("Status Code: \(httpResponse.statusCode)")
        print("Headers: \(httpResponse.allHeaderFields)")

        if let responseString = String(data: data, encoding: .utf8) {
            print("Response:")
            print(responseString)
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
    
}

extension Data {

    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
