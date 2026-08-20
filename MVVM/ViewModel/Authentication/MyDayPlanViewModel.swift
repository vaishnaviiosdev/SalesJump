//
//  MyDayPlanViewModel.swift
//  SalesJump
//
//  Created by Saneforce on 17/08/26.
//

import Foundation
import Combine
internal import CoreData

@MainActor
class MyDayPlanViewModel: ObservableObject {
    
    @Published var WorTypName:String = ""
    @Published var WorTypID:Int = 0
    @Published var workTypeFlag:String = ""
    
    @Published var HeadQuarterName:String = ""
    @Published var HeadQuarterID:String = ""
    
    @Published var DistributorName:String = ""
    @Published var DistributorID:Int = 0
    
    @Published var RouteName:String = ""
    @Published var RouteNameID:Int?
    
    
    @Published var RetailerName:[String] = []
    @Published var RetailerID:[String] = []
    
    @Published  var selectedType = "Self"
    
    
    @Published  var remarks:String = ""
    
    @Published var AllWorkType: [WorkType] = []
    
    @Published var ShowWorkTypsheet:Bool = false
    
    @Published var Subordinates: [Subordinate] = []
    
    @Published var ShowHQsheet:Bool = false
    
    
    @Published var AllDistributorList: [Distributor] = []
    
    @Published var ShowDistributorsheet:Bool = false
    
    
    @Published var AllRouteList: [Route] = []
    @Published var RouteList: [Route] = []
    @Published var ShowRouteheet:Bool = false
    
    @Published var AllJointWorkList: [MasterJointWork] = []
    @Published var SelecetdJointWork:[MasterJointWork]?
    @Published var ShowJointWorkheet:Bool = false
    
    @Published var AllRetailerList:[Retailer] = []
    @Published var SelecetdRetailer:[Retailer]?
    @Published var ShowRetailerSheet:Bool = false
    
    @Published var audioFilePath: String = ""
    
    
    
    func getLocalData() async {

        do {
            AllWorkType = try fetchData(entityType: WorkTypeEntity.self,keyPath: \.workType,modelType: WorkType.self)

            Subordinates = try fetchData(entityType: SubordinateEntity.self,keyPath: \.subordinate,modelType: Subordinate.self)

            AllDistributorList = try fetchData(entityType: DistributorEntity.self,keyPath: \.distributor,modelType: Distributor.self)

            AllRouteList = try fetchData(entityType: RouteEntity.self,keyPath: \.route,modelType: Route.self)

            AllJointWorkList = try fetchData(entityType: JointworkEntity.self,keyPath: \.jointwork,modelType: MasterJointWork.self)

            AllRetailerList = try fetchData(entityType: RetailerEntity.self,keyPath: \.retailer,modelType: Retailer.self)

        } catch {
            print("Fetch Error: \(error)")
        }
    }
    
    func fetchData<T: Decodable, E: NSManagedObject>(entityType: E.Type,keyPath: KeyPath<E, Data?>,modelType: T.Type) throws -> [T] {

        let context = CoreDataStack.shared.viewContext
        let request = NSFetchRequest<E>(entityName: String(describing: entityType))

        guard let entity = try context.fetch(request).first,
              let data = entity[keyPath: keyPath] else {
            return []
        }

        return try JSONDecoder().decode([T].self, from: data)
    }
    
    
    func FetchMyDayplan() async {
    
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
        
        if isMyDayPlan == true {
            WorTypName = plan?.worktypeName ?? ""
            WorTypID = Int(plan?.worktype ?? "0") ?? 0
            workTypeFlag = plan?.workTypeFlag ?? ""
            
            HeadQuarterName = plan?.hqName ?? ""
            HeadQuarterID = plan?.hqCode ?? ""
            
            DistributorName = plan?.distributorName ?? ""
            DistributorID = Int(plan?.distributorId ?? "0") ?? 0
            
            if UserSetup.shared.IsDistributorBased == true {
                
                IsDistributorBasedRouteFilter(id:String(DistributorID))
                
            }else{
                RouteList  = AllRouteList
            }
            
            RouteName = plan?.routeName ?? ""
            RouteNameID = Int(plan?.routeCode ?? "0") ?? 0
            
            let retailerIds = Set<String>(
                plan?.retailerList?.compactMap { $0.id } ?? []
            )

           SelecetdRetailer = AllRetailerList.filter {
                guard let id = $0.id else { return false }
                return retailerIds.contains(String(id))
            }
            
            let jointWorkIds = Set<String>(
                plan?.jointWorkList?.compactMap { $0.id } ?? []
            )
            
            SelecetdJointWork = AllJointWorkList.filter {
                 guard let id = $0.id else { return false }
                 return jointWorkIds.contains(String(id))
             }
            
            if SelecetdJointWork != nil{
                
                selectedType = "Joint Work"
            }
            
            
            remarks =  plan?.remarks ?? ""
            
        }
    } catch {
        print("Fetch Error: \(error)")
    }
}

    
    func IsDistributorBasedRouteFilter(id:String){
        
        let filteredRoutes = AllRouteList.filter { route in route.stockistCode?.split(separator: ",").map {$0.trimmingCharacters(in: .whitespaces) }.contains(id) ?? false
        }
        
        RouteList = filteredRoutes
    }
    

}
