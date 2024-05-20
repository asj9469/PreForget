//
//  Task.swift
//  preforget-priv
//
//  Created by Anson Goo on 4/14/23.
//

import Foundation
import CoreData

final class CompletedTask: NSManagedObject, Identifiable{
    
    @NSManaged var taskName_history: String
    @NSManaged var details_history: String
    @NSManaged var dueDate_history: Date
    @NSManaged var reminderDate_history: Date
    @NSManaged var urgency_history: Bool
    @NSManaged var reminder_history: Bool
    @NSManaged var completedDate: Date
    @NSManaged var completedDateTime: Date
    
    var formattedDate: String{
        let df = DateFormatter()
        df.dateFormat = "mm/dd/yyyy"
        return df.string(from: dueDate_history)
    }
    
    var formattedReminderDate: String{
        let df = DateFormatter()
        df.dateFormat = "mm/dd/yyyy hh:mm a"
        return df.string(from: reminderDate_history)
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
        !taskName_history.isEmpty
    }
    
}

extension CompletedTask{
    private static var completedTaskFetchRequest: NSFetchRequest<CompletedTask>{
        NSFetchRequest(entityName: "CompletedTask")
    }
}
