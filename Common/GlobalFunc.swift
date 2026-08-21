//
//  GlobalFunc.swift
//  SalesJump
//
//  Created by Saneforce on 21/08/26.
//

import Foundation
internal import CoreData

final class GlobalFunc {

    struct MasterSync: Codable {
        let id: Int
        let name: String
        let masterName: String
        let sfCode: String
        let stateCode: String
        let divisionCode: String
        let hqSfCode: String
    }

    static func FieldMasterSync(SFCode: String) async -> Bool {

        let masterSyncAPI: [MasterSync] = [

            MasterSync(id: 1,name: "Retailer",masterName: "retailer",sfCode: SessionManager.shared.sfCode,stateCode:SessionManager.shared.State_Code,divisionCode: SessionManager.shared.divisionCode,hqSfCode: SFCode),

            MasterSync(id: 2,name: "Distributor",masterName: "distributor",sfCode: SessionManager.shared.sfCode,stateCode: SessionManager.shared.State_Code,divisionCode: SessionManager.shared.divisionCode,hqSfCode: SFCode),

            MasterSync(id: 3,name: "Route",masterName: "route",sfCode: SessionManager.shared.sfCode,stateCode: SessionManager.shared.State_Code,divisionCode: SessionManager.shared.divisionCode,hqSfCode: SFCode)
        ]
        

        return await SyncAll(masterSyncAPI)
    }

    private static func SyncAll(_ masterSyncAPI: [MasterSync]) async -> Bool {

        await withTaskGroup(of: Bool.self) { group in

            for item in masterSyncAPI {

                group.addTask {

                    return await CallMasterSyncAPI(
                        masterName: item.masterName,
                        sfCode: item.sfCode,
                        stateCode: item.stateCode,
                        divisionCode: item.divisionCode,
                        hqSfCode: item.hqSfCode
                    )
                }
            }

            var allSuccess = true

            for await result in group {
                if !result {
                    allSuccess = false
                }
            }

            return allSuccess
        }
    }

    private static func CallMasterSyncAPI(
        masterName: String,
        sfCode: String,
        stateCode: String,
        divisionCode: String,
        hqSfCode: String
    ) async -> Bool {

        var components = URLComponents(
            string: "\(APIClient.shared.Url)getmasterSync"
        )!

        components.queryItems = [
            URLQueryItem(name: "Master_Name", value: masterName),
            URLQueryItem(name: "SF_Code", value: sfCode),
            URLQueryItem(name: "State_Code", value: stateCode),
            URLQueryItem(name: "Division_Code", value: divisionCode),
            URLQueryItem(name: "HqSf_Code", value: hqSfCode)
        ]

        guard let url = components.url else {
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue(
            "Bearer \(SessionManager.shared.JWT_Token)",
            forHTTPHeaderField: "Authorization"
        )

        do {

            let (data, response) = try await URLSession.shared.data(
                for: request
            )

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("\(masterName) Invalid Response")
                return false
            }

            guard !data.isEmpty else {
                print("\(masterName) Empty Response")
                return false
            }

            return await saveMasterSyncData(
                masterName: masterName,
                data: data,
                hqsf: hqSfCode
            )

        } catch {

            print("\(masterName) API Error : \(error)")
            return false
        }
    }

    private static func saveMasterSyncData(masterName: String,data: Data,hqsf: String) async -> Bool {

        let context = CoreDataStack.shared.newBackgroundContext()

        do {
            switch masterName {
            case "retailer":

                let items = try JSONDecoder().decode(RetailerResponse.self, from: data)

                return await context.perform {

                    do {

                        let entity = RetailerEntity(context: context)
                        entity.retailer = try JSONEncoder()
                            .encode(items.response)
                        entity.lastUpdated = Date()
                        entity.masterName = items.masterName
                        entity.sfcode = hqsf

                        try context.save()

                        return true

                    } catch {

                        print("Retailer Save Error: \(error)")
                        return false
                    }
                }

            case "distributor":

                let items = try JSONDecoder()
                    .decode(DistributorResponse.self, from: data)

                return await context.perform {

                    do {

                        let entity = DistributorEntity(context: context)
                        entity.distributor = try JSONEncoder()
                            .encode(items.response)
                        entity.lastUpdated = Date()
                        entity.masterName = items.masterName
                        entity.sfcode = hqsf

                        try context.save()

                        return true

                    } catch {

                        print("Distributor Save Error: \(error)")
                        return false
                    }
                }

            case "route":

                let items = try JSONDecoder()
                    .decode(RouteResponse.self, from: data)

                return await context.perform {

                    do {

                        let entity = RouteEntity(context: context)
                        entity.route = try JSONEncoder()
                            .encode(items.response)
                        entity.lastUpdated = Date()
                        entity.masterName = items.masterName
                        entity.sfcode = hqsf

                        try context.save()

                        return true

                    } catch {

                        print("Route Save Error: \(error)")
                        return false
                    }
                }

            default:
                print("Unknown Master Name: \(masterName)")
                return false
            }

        } catch {

            print("Decode Error: \(error)")
            return false
        }
    }
    
    
}
