//
//  Task.swift
//  preforget-priv
//
//  Created by Anson Goo on 4/14/23.
//

import Foundation
import CoreData

final class Task: NSManagedObject, Identifiable{
    
    @NSManaged var taskName: String
    @NSManaged var details: String
    @NSManaged var dueDate: Date
    @NSManaged var reminderDate: Date
    @NSManaged var urgency: Bool
    @NSManaged var reminder: Bool
    
    var formattedDate: String{
        let df = DateFormatter()
        df.dateFormat = "MM/dd/YYYY hh:mm a"
        return df.string(from: dueDate)
    }
    
    var formattedReminderDate: String{
        let df = DateFormatter()
//        df.dateFormat = "MMM d, h:mm a"
        df.dateFormat = "MM/dd/yyyy hh:mm a"
        return df.string(from: reminderDate)
    }
    
    var isValid: Bool {
        !taskName.isEmpty
    }
    
}

extension Task{
    private static var taskFetchRequest: NSFetchRequest<Task>{
        NSFetchRequest(entityName: "Task")
    }
}
