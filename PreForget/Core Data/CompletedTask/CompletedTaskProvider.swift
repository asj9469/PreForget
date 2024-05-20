//
//  TasksProvider.swift
//  preforget
//
//  Created by Anson Goo on 4/9/23.
//

import CoreData
import SwiftUI

struct CompletedTaskProvider{
    
    static let shared = CompletedTaskProvider()
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    private init(){
        container = NSPersistentContainer(name: "CompletedTaskModel")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func exists(_ completedTask: CompletedTask, in context: NSManagedObjectContext) -> CompletedTask? {
            try? context.existingObject(with: completedTask.objectID) as? CompletedTask
    }
    
    func delete(_ completedTask: CompletedTask, in context: NSManagedObjectContext) throws {
        if let existingCompletedTask = exists(completedTask, in: context) {
            context.delete(existingCompletedTask)
            try context.save()
            }
    }
        
    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
        
}
