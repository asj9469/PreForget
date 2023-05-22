//
//  EditTaskViewModel.swift
//  preforget-priv
//
//  Created by Anson Goo on 4/15/23.
//

import Foundation
import CoreData

class EditTaskViewModel: ObservableObject{
    
    @Published var task: Task
    let isNew: Bool
    private let provider: TaskProvider
    private let context: NSManagedObjectContext
    
    init(provider: TaskProvider, task: Task? = nil){
        self.provider = provider
        self.context = provider.newContext
        
        if let task,
           let existingTaskCopy = provider.exists(task,in: context) {
            self.task = existingTaskCopy
            self.isNew = false
        } else {
            self.task = Task(context: self.context)
            self.isNew = true
        }
        
    }
    
    func save() throws {
        try provider.persist(in: context)
    }
    
}
