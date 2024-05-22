//
//  CompletedTask.swift
//  preforget
//
//  Created by Anson Goo on 5/21/24
//

import Foundation
import CoreData

final class CompletedTask: NSManagedObject, Identifiable{
    
    @NSManaged var taskName_c: String
    @NSManaged var details_c: String
    @NSManaged var dueDate_c: Date
    @NSManaged var reminderDate_c: Date
    @NSManaged var urgency_c: Bool
    @NSManaged var reminder_c: Bool
    @NSManaged var completedDate: Date
    @NSManaged var completedDateTime: Date
    
    var formattedDate_c: String{
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        return df.string(from: dueDate_c)
    }
    
    var formattedReminderDate_c: String{
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy hh:mm a"
        return df.string(from: reminderDate_c)
    }
    
    var formattedCompletedDate: String{
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        return df.string(from: completedDate)
    }
    
    var formattedCompletedDateTime: String{
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy hh:mm a"
        return df.string(from: completedDateTime)
    }
    
    var isValid: Bool {
        !taskName_c.isEmpty
    }
    
}

extension CompletedTask{
    private static var completedTaskFetchRequest: NSFetchRequest<CompletedTask>{
        NSFetchRequest(entityName: "CompletedTask")
    }
}
