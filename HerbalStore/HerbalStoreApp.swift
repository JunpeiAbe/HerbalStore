//
//  HerbalStoreApp.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/09.
//

import SwiftUI
import Firebase

@main
struct HerbalStoreApp: App {
    
    
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
