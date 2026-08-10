//
//  SalesJumpApp.swift
//  SalesJump
//
//  Created by San eforce on 27/07/26.
//

import SwiftUI
import CoreData
import Combine

@main
struct SalesJumpApp: App {

    let persistenceController = PersistenceController.shared

    @StateObject private var router = AppRouter()
    @StateObject private var toastManager = ToastManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
                .environmentObject(toastManager)
                .environment(\.managedObjectContext,
                             persistenceController.container.viewContext)
        }
    }
}

class AppRouter: ObservableObject {

    enum RootView {
        case welcome
        case dashboard
    }

    @Published var root: RootView = .welcome
    @Published var path = NavigationPath()

    @AppStorage("User_Login") private var isLoggedIn = false

    init() {
        decideInitialView()
    }

    func decideInitialView() {
        root = isLoggedIn ? .dashboard : .welcome
    }

    func loginSuccess() {
        isLoggedIn = true
        root = .dashboard
    }

    func logout() {
        isLoggedIn = false
        path = NavigationPath()
        root = .welcome
    }
}

struct RootView: View {

    @EnvironmentObject var router: AppRouter

    var body: some View {
        //LoginView()
        
        NavigationStack {
            switch router.root {
                
            case .welcome:
                LoginView()
                
            case .dashboard:
                DashboardView()
                
            
            }
        }
        .id(router.root)

    }
}
