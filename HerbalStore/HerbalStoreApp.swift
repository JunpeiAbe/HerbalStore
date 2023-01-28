//
//  HerbalStoreApp.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/09.
//

import SwiftUI
//import FirebaseCore
import Firebase

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}

@main
struct HerbalStoreApp: App {
    
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        FirebaseApp.configure()
    }
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel.shared)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
