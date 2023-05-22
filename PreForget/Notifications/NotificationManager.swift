//
//  NotificationManager.swift
//  PreForget
//
//  Created by Anson Goo on 4/23/23.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationManager: ObservableObject{
//    @Published var pendingRequests: [UNNotificationRequest] = []
//    var updatedPendingRequests: [UNNotificationRequest] = []
//    var id: String
    var taskName: String
    var formattedDate: String
    let un = UNUserNotificationCenter.current()
    @Binding var imageData: Data
    
    init(taskName: String, formattedDate: String, imageData: Binding<Data>){
//        self.id = id
        self.taskName = taskName
        self.formattedDate = formattedDate
        self._imageData = imageData
    }
    
    func requestNotifPermission(){
        //initial permission request
        un.requestAuthorization(options: [.alert, .badge, .sound]) { authorized, error in
            if authorized {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
//    func scheduleNotifs(from startDate: Date, to endDate: Date) {
////        var curDate = startDate
////        var count: Int = 0
//        let delta = endDate.timeIntervalSince(startDate)
//        //edit the remind interval here
//        scheduleNotif(with: "\(id)1", date: startDate+(delta/2)) //halfway mark
//        scheduleNotif(with: "\(id)2", date: endDate-(delta/4)) //3/4 of interval
//
////        while curDate.compare(endDate) != .orderedDescending{
////            delta /= 2
////            scheduleNotif(with: "\(id)_\(count)", date: curDate)
////            curDate = curDate.addingTimeInterval(delta)
////            count += 1
////        }
//    }

    func scheduleNotif(with identifier: String, date: Date) {

        let content = UNMutableNotificationContent()
        
        content.title = "PreForget Reporting 🫡"
        content.subtitle = "Reminder: \"\(taskName)\""
        content.body = "Due: \(formattedDate)"
        content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: "notifSound.wav"))
        content.categoryIdentifier = "reminderNotif"
        
        let launchApp = UNNotificationAction(identifier: "launchApp", title: "View in app", options: [.foreground])
//        let disableTaskNotif = UNNotificationAction(identifier: "disableTaskNotif", title: "Turn off reminder for this task", options: [.foreground])
        
        if let attachment = UNNotificationAttachment.create(identifier: "img.jpeg", imageData: imageData as Data, options: nil)
        {
            content.attachments = [attachment]
        }
        
        let category = UNNotificationCategory(identifier: "reminderNotif", actions: [launchApp], intentIdentifiers: [], options: [])

        let triggerTime = Calendar.current.dateComponents([.year, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        self.un.setNotificationCategories([category])
        self.un.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        
//        //updating pending requests
//        un.getPendingNotificationRequests { (notificationRequests) in
//             for notificationRequest:UNNotificationRequest in notificationRequests {
//                 self.updatedPendingRequests.append(notificationRequest)
//            }
//        }
//
//        pendingRequests = updatedPendingRequests
    }
}
