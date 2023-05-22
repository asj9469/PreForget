//
//  TasksProvider.swift
//  preforget
//
//  Created by Anson Goo on 4/9/23.
//

import CoreData
import SwiftUI

struct TaskProvider{
    
    static let shared = TaskProvider()
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    private init(){
        container = NSPersistentContainer(name: "TaskModel")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func exists(_ task: Task, in context: NSManagedObjectContext) -> Task? {
            try? context.existingObject(with: task.objectID) as? Task
    }
    
    func delete(_ task: Task, in context: NSManagedObjectContext) throws {
        if let existingTask = exists(task, in: context) {
            context.delete(existingTask)
            try context.save()
            }
    }
        
    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
        
}
