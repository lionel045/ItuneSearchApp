//
//  CoreDataStack.swift
//  iTunesSearchApp
//
//  Created by Lion on 23/01/2024.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    //MARK: Singleton
    
    static let sharedInstance = CoreDataStack()
    
    private init() {}
    
    private let persistantContainerName = "Song"

    var viewContext: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistantContainer.viewContext

    }
    
    private lazy var persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistantContainerName) // Nom du container
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) for: \(storeDescription.description)")
            }
        }
        
        return container
    }()
}


