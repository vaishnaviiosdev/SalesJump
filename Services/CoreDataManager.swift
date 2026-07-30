//
//  CoreDataManager.swift
//  SalesJump
//
//  Created by San eforce on 29/07/26.
//

import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    private init() {}

    var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }
    
//    func fetchUser() -> UserInfo? {
//
//        let request: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
//
//        do {
//            return try context.fetch(request).first
//        }
//        catch {
//            print(error)
//        }
//
//        return nil
//    }

//    func saveUser(login: LoginModel) {
//        let request: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
//
//        do {
//
//            let users = try context.fetch(request)
//
//            let user: UserInfo
//
//            if let existingUser = users.first {
//                user = existingUser
//            }
//            else {
//                user = UserInfo(context: context)
//            }
//
//            user.sfCode = login.response?.SF_Code
//            user.sfName = login.response?.SF_Name
//            user.desigCode = login.response?.Desig_Code
//            user.jwtToken = login.response?.Jwt_Token
//
//            try context.save()
//
//            print("User saved successfully.")
//
//        }
//        catch {
//            print("Save Error: \(error.localizedDescription)")
//        }
//    }

}
