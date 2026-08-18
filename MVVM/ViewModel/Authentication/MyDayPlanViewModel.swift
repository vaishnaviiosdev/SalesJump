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
    
    @Published var HeadQuarterName:String = ""
    @Published var HeadQuarterID:String = ""
    
    @Published var DistributorName:String = ""
    @Published var DistributorID:Int = 0
    
    @Published var RouteName:String = ""
    @Published var RouteNameID:Int = 0
    
    
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
    
    
    @Published var ShowRouteheet:Bool = false
    
    @Published var AllJointWorkList: [MasterJointWork] = []
    
    @Published var ShowJointWorkheet:Bool = false

    
    
    func getLocalData() async{
        let context = CoreDataStack.shared.viewContext
        
        do {
            let request: NSFetchRequest<WorkTypeEntity> = WorkTypeEntity.fetchRequest()
            
            guard let entity = try context.fetch(request).first,
                  let data = entity.workType else {
               
                return
            }
            
            let items = try JSONDecoder().decode([WorkType].self, from: data)
            
            AllWorkType = items
            
        } catch {
            print("Fetch Error: \(error)")
        }
        
        
        
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
        
        
        
        do {
            let request: NSFetchRequest<DistributorEntity> = DistributorEntity.fetchRequest()
            
            guard let entity = try context.fetch(request).first,
                  let data = entity.distributor else {
               
                return
            }
            
            let items = try JSONDecoder().decode([Distributor].self, from: data)
            
            AllDistributorList = items
            
        } catch {
            print("Fetch Error: \(error)")
        }
        
        
        
        do {
            let request: NSFetchRequest<RouteEntity> = RouteEntity.fetchRequest()
            
            guard let entity = try context.fetch(request).first,
                  let data = entity.route else {
               
                return
            }
            
            let items = try JSONDecoder().decode([Route].self, from: data)
            
            AllRouteList = items
            
        } catch {
            print("Fetch Error: \(error)")
        }
        
        
        
        do {
            let request: NSFetchRequest<JointworkEntity> = JointworkEntity.fetchRequest()
            
            guard let entity = try context.fetch(request).first,
                  let data = entity.jointwork else {
               
                return
            }
            
            let items = try JSONDecoder().decode([MasterJointWork].self, from: data)
            
            AllJointWorkList = items
            
        } catch {
            print("Fetch Error: \(error)")
        }
        
        
    }


}
