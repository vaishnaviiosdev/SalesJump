//
//  UserSetup.swift
//  SalesJump
//
//  Created by Saneforce on 14/08/26.
//

import Foundation
internal import CoreData

class UserSetup {

    static let shared = UserSetup()

    let context = CoreDataStack.shared.newBackgroundContext()

    func fetchSetup() {
        let request: NSFetchRequest<AppSetupEntity> = AppSetupEntity.fetchRequest()
        do {
            if let entity = try context.fetch(request).first,
            let data = entity.setupData {
            let setup = try JSONDecoder().decode(AppSetupData.self,from: data)

              print(setup)
                
            }
        } catch {
            print("Error:", error)
        }
    }
}
