//
//  CrpytoListCoreDataStack.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation
import CoreData

final class CrpytoListCoreDataStack {
    
    // MARK: - Properties
    static let shared = CrpytoListCoreDataStack()
    let persistentContainer: NSPersistentContainer
    
    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var writerContext: NSManagedObjectContext {
      let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
      context.parent = persistentContainer.viewContext
      return context
    }
    
    // MARK: - Initializer
    private init() {
        let container = NSPersistentContainer(name: "CrpytoListCoreDataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let _ = error as NSError? {
                return
            }
        })
        self.persistentContainer = container
    }
    
    @objc func saveMainContext() throws {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                throw error
            }
        }
    }
}
