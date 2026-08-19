//
//  MasterSyncViewModel.swift
//  SalesJump
//
//  Created by Saneforce on 11/08/26.
//

import Foundation
import Combine
internal import CoreData
@MainActor
class MasterSyncViewModel: ObservableObject {
    
    @Published var HeadquarterName:String = ""
    @Published var HeadquarterID:String = ""
    @Published var MasterSyncAPI: [MasterSync] = []
    @Published var getHqSf_Code: String = SessionManager.shared.sfCode
    @Published var Subordinates: [Subordinate] = []
    @Published var AllApiCompleted: Bool = false

    
    init() {
        MasterSyncAPI.append(MasterSync(id:1,Name: "Retailer",Master_Name: "retailer",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code,isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
        MasterSyncAPI.append(MasterSync(id: 2, Name: "Distributor",Master_Name: "distributor",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
        MasterSyncAPI.append(MasterSync(id:3, Name: "Work Type",Master_Name: "worktype",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
        
                MasterSyncAPI.append(MasterSync(id:4, Name: "Route",Master_Name: "route",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:5, Name: "Joint Work",Master_Name: "jointwork",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:6, Name: "Quick Action Setup",Master_Name: "quickactionsetup",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code:SessionManager.shared.sfCode, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:7, Name: "Products",Master_Name: "products",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:8, Name: "State",Master_Name: "state",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:9, Name: "Brand",Master_Name: "brand",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:10, Name: "Category",Master_Name: "category",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:11, Name: "Units",Master_Name: "units",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:12, Name: "Tax",Master_Name: "tax",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:13, Name: "State rate",Master_Name: "staterate",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:14, Name: "Subordinate",Master_Name: "subordinate",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code:SessionManager.shared.sfCode, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:15, Name: "Product Group",Master_Name: "productgroup",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
        
                MasterSyncAPI.append(MasterSync(id:16, Name: "Scheme",Master_Name: "scheme",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:17, Name: "Competitor",Master_Name: "competitor",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
        
                MasterSyncAPI.append(MasterSync(id:18, Name: "Super Stockist",Master_Name: "superstockist",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:19, Name: "Stockist rate",Master_Name: "stockiestrate",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:20, Name: "Super Stockist rate",Master_Name: "superstockistrate",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:21, Name: "Van Sale rate",Master_Name: "vansalesrate",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:22, Name: "Payment List",Master_Name: "paymentlist",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:23, Name: "Tour Plan Periods",Master_Name: "tpperiodicwise",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
        
                MasterSyncAPI.append(MasterSync(id:24, Name: "Templates",Master_Name: "template",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:25, Name: "Retailer Class",Master_Name: "retailerclass",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:26, Name: "Retailer Category",Master_Name: "retailercategory",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:27, Name: "Retailer Type",Master_Name: "retailertype",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:28, Name: "Sample Products",Master_Name: "sample_products",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:29, Name: "Distributor Type",Master_Name: "sample_products",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
                MasterSyncAPI.append(MasterSync(id:30, Name: "Variants",Master_Name: "variants",SF_Code: SessionManager.shared.sfCode,State_Code: SessionManager.shared.State_Code,Division_Code:SessionManager.shared.divisionCode,HqSf_Code: getHqSf_Code, isLoading: false,Count: 0, ShowContandLoading: false, error: false))
        
    }
    
    
    
    
 
    func SyncAll() async {
        for index in MasterSyncAPI.indices {
            MasterSyncAPI[index].ShowContandLoading = true
            MasterSyncAPI[index].isLoading = true
            MasterSyncAPI[index].Count = 0
        }
        
        await withTaskGroup(of: Void.self) { group in
            
            for index in MasterSyncAPI.indices {
                
                let item = MasterSyncAPI[index]
                
                group.addTask {
                    
                    await self.CallMasterSyncAPI(
                        Master_Name: item.Master_Name,
                        SF_Code: item.SF_Code,
                        State_Code: item.State_Code,
                        Division_Code: item.Division_Code,
                        HqSf_Code: item.HqSf_Code,
                        index: index
                    )
                }
            }
            
            for await _ in group {
                
            }
        }
        await MainActor.run {
              self.AllApiCompleted = true
          }
    }
    
    func SyncData(Index:Int) async{
        
        let Item = MasterSyncAPI[Index]
        MasterSyncAPI[Index].isLoading = true
        MasterSyncAPI[Index].ShowContandLoading = true
       await CallMasterSyncAPI(Master_Name: Item.Master_Name, SF_Code: Item.SF_Code, State_Code: Item.State_Code, Division_Code: Item.Division_Code, HqSf_Code: Item.HqSf_Code, index: Index)
            
    }
    
    func CallMasterSyncAPI(Master_Name:String,SF_Code:String,State_Code:String,Division_Code:String,HqSf_Code:String,index:Int) async {
        
        var components = URLComponents(string:"\(APIClient.shared.Url)getmasterSync")!
        components.queryItems = [
            URLQueryItem(name: "Master_Name", value:Master_Name),
            URLQueryItem(name: "SF_Code", value:SF_Code),
            URLQueryItem(name: "State_Code", value: State_Code),
            URLQueryItem(name: "Division_Code", value: Division_Code),
            URLQueryItem(name: "HqSf_Code", value: HqSf_Code)
        ]
        guard let url = components.url else { return  }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(SessionManager.shared.JWT_Token)", forHTTPHeaderField: "Authorization")
        do {
               let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("\(Master_Name) - Bad response: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                MasterSyncAPI[index].error = true
                return
            }
               
               guard !data.isEmpty else {
                   print("\(Master_Name) - No Data")
                   return
               }
               
           
               await saveMasterSyncData(masterName: Master_Name, data: data)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                 let dataCount = json["dataCount"] as? Int {

                  print("\(Master_Name) dataCount = \(dataCount)")
                MasterSyncAPI[index].error = false
                MasterSyncAPI[index].Count = dataCount
                MasterSyncAPI[index].isLoading = false
               
              }
            
               
           } catch {
               print("\(Master_Name) API failed: \(error.localizedDescription)")
               MasterSyncAPI[index].error = true
         
           }
        
      
    }
    
    func saveMasterSyncData(masterName: String, data: Data) async {

        do {
            switch masterName {
            case "retailer":
                let items = try JSONDecoder().decode(RetailerResponse.self,from: data)
                let context = CoreDataStack.shared.newBackgroundContext()
                
                await context.perform {
                    do {
        let request: NSFetchRequest<RetailerEntity> = RetailerEntity.fetchRequest()
        let oldRecords = try context.fetch(request)
            for item in oldRecords {
                            context.delete(item)
                        }
                        let entity = RetailerEntity(context: context)
                        entity.retailer = try JSONEncoder().encode(items.response)
                        entity.lastUpdated = Date()
                        entity.masterName = items.masterName
                        if context.hasChanges {
                            try context.save()
                        }
                    } catch {
                        print("CoreData Save Error: \(error)")
                    }
                }

            case "subordinate":
                let items = try JSONDecoder().decode(SubordinateResponse.self,from: data)
                let context = CoreDataStack.shared.newBackgroundContext()
                await context.perform {
                    do {
                        
                        let request: NSFetchRequest<SubordinateEntity> = SubordinateEntity.fetchRequest()
                        let oldRecords = try context.fetch(request)
                            for item in oldRecords {
                                            context.delete(item)
                            }

                        
                        let entity = SubordinateEntity(context: context)
                        entity.subordinate = try JSONEncoder().encode(items.response)
                        if context.hasChanges {
                            try context.save()
                        }
                    } catch {
                        print("CoreData Save Error: \(error)")
                    }
                }
                
            case "worktype":
                let items = try JSONDecoder().decode(WorkTypeResponse.self,from: data)
                let context = CoreDataStack.shared.newBackgroundContext()
                await context.perform {
                    do {
                        
                        let request: NSFetchRequest<WorkTypeEntity> = WorkTypeEntity.fetchRequest()
                        let oldRecords = try context.fetch(request)
                            for item in oldRecords {
                                            context.delete(item)
                            }
                        let entity = WorkTypeEntity(context: context)
                        entity.workType = try JSONEncoder().encode(items.response)
                        entity.lastUpdated = Date()
                        entity.masterName = items.masterName
                        if context.hasChanges {
                            try context.save()
                        }
                    } catch {
                        print("CoreData Save Error: \(error)")
                    }
                }
                
                
            case "distributor":
                let items = try JSONDecoder().decode(DistributorResponse.self,from: data)
                let context = CoreDataStack.shared.newBackgroundContext()
                await context.perform {
                    do {
                        let request: NSFetchRequest<DistributorEntity> = DistributorEntity.fetchRequest()
                        let oldRecords = try context.fetch(request)
                            for item in oldRecords {
                                            context.delete(item)
                            }
                        let entity = DistributorEntity(context: context)
                        entity.distributor = try JSONEncoder().encode(items.response)
                        entity.lastUpdated = Date()
                        entity.masterName = items.masterName
                        if context.hasChanges {
                            try context.save()
                        }
                    } catch {
                        print("CoreData Save Error: \(error)")
                    }
                }
            case "route":
                let items = try JSONDecoder().decode(RouteResponse.self,from: data)
                let context = CoreDataStack.shared.newBackgroundContext()
                await context.perform {
                    do {
                        
                        let request: NSFetchRequest<RouteEntity> = RouteEntity.fetchRequest()
                        let oldRecords = try context.fetch(request)
                            for item in oldRecords {
                                            context.delete(item)
                            }
                        
                        let entity = RouteEntity(context: context)
                        entity.route = try JSONEncoder().encode(items.response)
                        entity.lastUpdated = Date()
                        entity.masterName = items.masterName
                        if context.hasChanges {
                            try context.save()
                        }
                    } catch {
                        print("CoreData Save Error: \(error)")
                    }
                }
                
            case "jointwork":
                let items = try JSONDecoder().decode(JointWorkResponse.self,from: data)
                let context = CoreDataStack.shared.newBackgroundContext()
                await context.perform {
                    do {
                        
                        let request: NSFetchRequest<JointworkEntity> = JointworkEntity.fetchRequest()
                        let oldRecords = try context.fetch(request)
                     for item in oldRecords {
                                context.delete(item)
                            }
                        let entity = JointworkEntity(context: context)
                        entity.jointwork = try JSONEncoder().encode(items.response)
                        entity.lastUpdated = Date()
                        entity.masterName = items.masterName
                        if context.hasChanges {
                            try context.save()
                        }
                    } catch {
                        print("CoreData Save Error: \(error)")
                    }
                }
                
            default:
                print("No model mapped for \(masterName)")
            }

        } catch {
            print("Decode Error for \(masterName): \(error)")
        }
    }
    

    func fetchSubordinate() async {
        
        let context = CoreDataStack.shared.viewContext
        
        do {
            let request: NSFetchRequest<SubordinateEntity> = SubordinateEntity.fetchRequest()
            
            guard let entity = try context.fetch(request).first,
                  let data = entity.subordinate else {
               
                return
            }
            
            let items = try JSONDecoder().decode([Subordinate].self, from: data)
            
            Subordinates = items
            
        } catch {
            print("Fetch Error: \(error)")
        }
    }
    
    
    func FetchMyDayplan(isLogIn:Bool) async {

        let context = CoreDataStack.shared.viewContext

        do {

            let request: NSFetchRequest<MyDayPlanEntity> =
                MyDayPlanEntity.fetchRequest()

            guard let entity = try context.fetch(request).first else {
                return
            }

            let plan = try? JSONDecoder().decode(DayPlanResponse.self,from: entity.response ?? Data())
            _ = try? JSONDecoder().decode([TPItem].self,from: entity.tpList ?? Data())
            let isMyDayPlan = entity.isMyDayPlan

            
            if isMyDayPlan{
                HeadquarterName = plan?.hqName ?? "-"
                for index in MasterSyncAPI.indices {
                    
                    if MasterSyncAPI[index].Master_Name != "quickactionsetup"  || MasterSyncAPI[index].Master_Name != "subordinate" {
                        MasterSyncAPI[index].HqSf_Code = plan?.hqCode ?? ""
                    }
                    
                }
                
                if isLogIn{
                    
                   await SyncAll()
                    
                }
            }else{
                if isLogIn{
                    await SyncAll()
                }
            }

        } catch {
            print("Fetch Error: \(error)")
        }
    }
    
    
    func ClearData() async {

        let context = CoreDataStack.shared.newBackgroundContext()
        await context.perform {

            do {
                let entityNames = [
                    "RetailerEntity",
                    "SubordinateEntity",
                    "MyDayPlanEntity"
                ]

                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
                        entityName: entityName
                    )
                    let deleteRequest = NSBatchDeleteRequest(
                        fetchRequest: fetchRequest
                    )

                    try context.execute(deleteRequest)
                }
                try context.save()
                print("All Core Data Cleared")
            } catch {
                print("Clear Data Error: \(error)")
            }
        }
    }
}
