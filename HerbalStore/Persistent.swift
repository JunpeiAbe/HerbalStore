//
//  Persistent.swift
//  HerbalStore
//
//  Created by Junpei  on 2022/12/27.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "CartItem")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error is \(error)")
            }
        }
    }
}
