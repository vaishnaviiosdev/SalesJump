//
//  MasterSyncViewModel.swift
//  SalesJump
//
//  Created by Saneforce on 11/08/26.
//

import Foundation
import Combine
import CoreData
@MainActor
class MasterSyncViewModel: ObservableObject {
    
    @Published var MasterSyncAPI: [MasterSync] = []

    @Published var getHqSf_Code: String = SessionManager.shared.sfCode

    
    init() {
        MasterSyncAPI.append(MasterSync(id:1,Name: "Retailer",Master_Name: "retailer",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code,isLoading: false,Count: 0, ShowContandLoading: false))
        
        MasterSyncAPI.append(MasterSync(id: 2, Name: "Distributor",Master_Name: "distributor",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
        MasterSyncAPI.append(MasterSync(id:3, Name: "Work Type",Master_Name: "worktype",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
        
                MasterSyncAPI.append(MasterSync(id:4, Name: "Route",Master_Name: "route",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:5, Name: "Joint Work",Master_Name: "jointwork",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:6, Name: "Quick Action Setup",Master_Name: "quickactionsetup",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code:SessionManager.shared.sfCode, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:7, Name: "Products",Master_Name: "products",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:8, Name: "State",Master_Name: "state",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:9, Name: "Brand",Master_Name: "brand",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:10, Name: "Category",Master_Name: "category",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:11, Name: "Units",Master_Name: "units",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:12, Name: "Tax",Master_Name: "tax",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:13, Name: "State rate",Master_Name: "staterate",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:14, Name: "Subordinate",Master_Name: "subordinate",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code:SessionManager.shared.sfCode, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:15, Name: "Product Group",Master_Name: "productgroup",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
        
                MasterSyncAPI.append(MasterSync(id:16, Name: "Scheme",Master_Name: "scheme",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:17, Name: "Competitor",Master_Name: "competitor",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
        
                MasterSyncAPI.append(MasterSync(id:18, Name: "Super Stockist",Master_Name: "superstockist",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:19, Name: "Stockist rate",Master_Name: "stockiestrate",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:20, Name: "Super Stockist rate",Master_Name: "superstockistrate",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:21, Name: "Van Sale rate",Master_Name: "vansalesrate",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:22, Name: "Payment List",Master_Name: "paymentlist",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:23, Name: "Tour Plan Periods",Master_Name: "tpperiodicwise",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
        
                MasterSyncAPI.append(MasterSync(id:24, Name: "Templates",Master_Name: "template",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:25, Name: "Retailer Class",Master_Name: "retailerclass",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:26, Name: "Retailer Category",Master_Name: "retailercategory",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:27, Name: "Retailer Type",Master_Name: "retailertype",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:28, Name: "Sample Products",Master_Name: "sample_products",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:29, Name: "Distributor Type",Master_Name: "sample_products",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
                MasterSyncAPI.append(MasterSync(id:30, Name: "Variants",Master_Name: "variants",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false))
        
    }
    
    
    
    
 
    func SyncAll() async {
        

        await withTaskGroup(of: (Int, Int).self) { group in
            
            for index in MasterSyncAPI.indices {
                
                let item = MasterSyncAPI[index]
                
                group.addTask {
                    
                    let count = await self.CallMasterSyncAPI(
                        Master_Name: item.Master_Name,
                        SF_Code: item.SF_Code,
                        State_Code: item.State_Code,
                        Division_Code: item.Division_Code,
                        HqSf_Code: item.HqSf_Code
                    )
                    
                    return (index, count)
                }
            }
            
            for await (index, count) in group {
                MasterSyncAPI[index].Count = count
                MasterSyncAPI[index].isLoading = false
            }
        }
    }
    
    func SyncData(Index:Int) async{
        
        let Item = MasterSyncAPI[Index]
        MasterSyncAPI[Index].isLoading = true
        MasterSyncAPI[Index].ShowContandLoading = true
        let count =  await CallMasterSyncAPI(Master_Name: Item.Master_Name, SF_Code: Item.SF_Code, State_Code: Item.State_Code, Division_Code: Item.Division_Code, HqSf_Code: Item.HqSf_Code)
       
             MasterSyncAPI[Index].Count = count
             
             MasterSyncAPI[Index].isLoading = false
        
    }
    
    
    
    func CallMasterSyncAPI(Master_Name:String,SF_Code:String,State_Code:String,Division_Code:String,HqSf_Code:String) async -> Int {
        
        var components = URLComponents(string:"http://sjapi.salesjump.in/api/qc/getmasterSync")!
        components.queryItems = [
            URLQueryItem(name: "Master_Name", value:Master_Name),
            URLQueryItem(name: "SF_Code", value:SF_Code),
            URLQueryItem(name: "State_Code", value: State_Code),
            URLQueryItem(name: "Division_Code", value: Division_Code),
            URLQueryItem(name: "HqSf_Code", value: HqSf_Code)
        ]
        guard let url = components.url else { return 0 }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(SessionManager.shared.JWT_Token)", forHTTPHeaderField: "Authorization")
        do {
               let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("\(Master_Name) - Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return 0
            }
               
               guard !data.isEmpty else {
                   print("\(Master_Name) - No Data")
                   return 0
               }
               
           
               await saveMasterSyncData(masterName: Master_Name, data: data)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                 let dataCount = json["dataCount"] as? Int {

                  print("\(Master_Name) dataCount = \(dataCount)")
                return dataCount
              }
            
               
           } catch {
               print("\(Master_Name) API failed: \(error.localizedDescription)")
               return 0
           }
        
        return 0
    }
    
    
    func saveMasterSyncData( masterName: String, data: Data) async {
        
        let context = CoreDataStack.shared.newBackgroundContext()
        
        await context.perform {
            do {
                switch masterName {
                    
                case "retailer":
                    
                    let items = try JSONDecoder().decode(RetailerResponse.self, from: data)
                    let Response = items.response
                    Response.forEach { RetailerEntity.saveOrUpdate(from: $0, context: context) }
                    
                default:
                    print("No model mapped for \(masterName)")
                    return
                }
            
                try context.save()
                print("\(masterName) synced successfully")
                    let fetchRequest: NSFetchRequest<RetailerEntity> = RetailerEntity.fetchRequest()
                    let count = try context.count(for: fetchRequest)
                    print(" RetailerEntity total rows in Core Data: \(count)")
                    let allRecords = try context.fetch(fetchRequest)
                
                    print(allRecords)
                
            } catch {
                print("Decode/Save error for \(masterName): \(error)")
            }
        }
    }
    
}


extension RetailerEntity {
    
    static func saveOrUpdate(from response: Retailer, context: NSManagedObjectContext) {
        
        guard let responseId = response.id else { return }
        
        let fetchRequest: NSFetchRequest<RetailerEntity> = RetailerEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", responseId)
        fetchRequest.fetchLimit = 1
        
        let entity = (try? context.fetch(fetchRequest))?.first ?? RetailerEntity(context: context)
        
        entity.id = Int64(response.id ?? 0)
        entity.name = response.name
        entity.townCode = response.townCode
        entity.townName = response.townName
        entity.image = response.image
        entity.outstandingAmount = response.outstandingAmount ?? 0.0
        entity.lat = response.lat
        entity.long = response.long
        entity.addrs = response.addrs
        entity.listedDrAddress1 = response.listedDrAddress1
        entity.listedDrSlNo = response.listedDrSlNo
        entity.mobileNumber = response.mobileNumber
        entity.docCatCode = Int64(response.docCatCode ?? 0)
        entity.contactPersion = response.contactPersion
        entity.docSpecialCode = Int64(response.docSpecialCode ?? 0)
        entity.distributorCode = response.distributorCode
        entity.doctorCode = Int64(response.doctorCode ?? 0)
        entity.gst = response.gst
        entity.createdDate = response.createdDate
        entity.doctorActiveFlag = response.doctorActiveFlag
        entity.listedDrEmail = response.listedDrEmail
        entity.specDocCode = response.specDocCode
        entity.debtorCode = response.debtorCode
        entity.creditLimit = response.creditLimit ?? 0.0
        entity.creditDays = response.creditDays ?? 0.0
        entity.retailerCategory = response.retailerCategory
        entity.retailerClass = response.retailerClass
        entity.imageUrl = response.imageUrl
    }
}
