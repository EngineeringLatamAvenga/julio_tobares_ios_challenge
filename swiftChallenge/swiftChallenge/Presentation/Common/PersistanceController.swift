//
//  PersistanceController.swift
//  swiftChallenge
//
//  Created by Julio Gabriel Tobares on 05/01/2025.
//

import Foundation
import CoreData

struct PersistanceController {
    
    static let shared = PersistanceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CityCD")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
    }
}
