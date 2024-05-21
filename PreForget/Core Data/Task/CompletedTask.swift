//
//  Task.swift
//  preforget-priv
//
//  Created by Anson Goo on 4/14/23.
//

import Foundation
import CoreData

final class CompletedTask: NSManagedObject, Identifiable{
    
    @NSManaged var taskName: String
    @NSManaged var details: String
    @NSManaged var dueDate: Date
    @NSManaged var reminderDate: Date
    @NSManaged var urgency: Bool
    @NSManaged var reminder: Bool
    @NSManaged var completedDate: Date
    @NSManaged var completedDateTime: Date
    
    var formattedDate: String{
        let df = DateFormatter()
        df.dateFormat = "mm/dd/yyyy"
        return df.string(from: dueDate)
    }
    
    var formattedReminderDate: String{
        let df = DateFormatter()
        df.dateFormat = "mm/dd/yyyy hh:mm a"
        return df.string(from: reminderDate)
    }
    
    var formattedCompletedDate: String{
        let df = DateFormatter()
        df.dateFormat = "mm/dd/yyyy"
        return df.string(from: completedDate)
    }
    
    var formattedCompletedDateTime: String{
        let df = DateFormatter()
        df.dateFormat = "mm/dd/yyyy hh:mm a"
        return df.string(from: completedDateTime)
    }
    
    var isValid: Bool {
        !taskName.isEmpty
    }
    
}

extension CompletedTask{
    private static var completedTaskFetchRequest: NSFetchRequest<CompletedTask>{
        NSFetchRequest(entityName: "CompletedTask")
    }
}
