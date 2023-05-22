//
//  TaskRowDisplay.swift
//  PreForget
//
//  Created by Anson Goo on 4/15/23.
//

import SwiftUI
import NVMColor
import UserNotifications

struct TaskRowView: View {
    @Environment(\.managedObjectContext) var viewContext

    @ObservedObject var task: Task
//    let provider: TaskProvider
    @Binding var showDetails: Bool
    @Binding var taskToEdit: Task?
    @Binding var customColor: String
    @Binding var shouldShowCompleteSuccess: Bool
    @Binding var shouldShowNotifSuccess: Bool
    @Binding var shouldHideNotifSuccess: Bool
    @Binding var imageData: Data
    init(task: Task, showDetails: Binding<Bool>, taskToEdit: Binding<Task?>, customColor: Binding<String>, shouldShowCompleteSuccess: Binding<Bool>, shouldShowNotifSuccess: Binding<Bool>, shouldHideNotifSuccess: Binding<Bool>, imageData: Binding<Data>) {
        self.task = task
        self._showDetails = showDetails
        self._taskToEdit = taskToEdit
        self._customColor = customColor
        self._shouldShowCompleteSuccess = shouldShowCompleteSuccess
        self._shouldShowNotifSuccess = shouldShowNotifSuccess
        self._shouldHideNotifSuccess = shouldHideNotifSuccess
        self._imageData = imageData
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack{
                Button{
    //                viewContext.delete(task)
                    withAnimation(.spring().delay(0.25)) {
                        self.shouldShowCompleteSuccess.toggle()
                    }
                    viewContext.delete(task)
                    try? viewContext.save()
                } label:{
                    Image(systemName: task.urgency == true ? "exclamationmark.square.fill" : "square")
                        .foregroundColor(Color(hex:customColor) ?? Color.pink)
                }
                .padding(.leading, 10)
                .padding(.horizontal, 5.0)
                .padding(.top, 3)
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
            }
            HStack{
                Text(task.taskName)
                    .font(.body)
                    .padding(.vertical, 3)
                    .onTapGesture {
                        taskToEdit = task
                        showDetails.toggle()
                    }
                    .contextMenu{
                        Button ("View/Edit Details") {
                            taskToEdit = task
                            showDetails.toggle()
                        }
                    }
                Spacer()
            }
            .padding(.leading, 45)
            HStack{
                Button{
                    task.reminder.toggle()
                    
                    if task.reminder != true{
                        withAnimation(.spring().delay(0.25)) {
                            self.shouldHideNotifSuccess.toggle()
                            self.shouldShowNotifSuccess = false
                        }
                    }else{
                        withAnimation(.spring().delay(0.25)) {
                            self.shouldShowNotifSuccess.toggle()
                            self.shouldHideNotifSuccess = false
                        }
                    }
                    
                    if(task.reminder == true){
//                        let startDate = Date.now
//                        let endDate = task.dueDate
                        
                        NotificationManager(taskName: task.taskName, formattedDate: task.formattedDate, imageData: $imageData).requestNotifPermission()
                        NotificationManager(taskName: task.taskName, formattedDate: task.formattedDate, imageData: $imageData).scheduleNotif(with: hashString(obj: task), date: task.reminderDate)
                    }
                    
                    if(task.reminder != true){
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [hashString(obj: task)])
                    }
                    try? viewContext.save()
                } label:{
                    Image(systemName: task.reminder == true ? "bell.fill" : "bell")
    //                    .foregroundColor(Color(hex:customColor))
//                        .foregroundColor(Color(hex:"f6b800"))
                }
                .padding(.horizontal, 5.0)
                .padding(.top, 3)
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

struct NoTaskView: View {
    
    let emptyPhrases = ["It's a bit too empty here...", "This is a bit empty for the app's purpose don't you think?", "You should definitely give me some work to do 👀", "Don't name your tasks too long... It's so hard to read it all out when I'm reminding you of it 😭", "wow you must be very free... lucky..."]
    let randomEmptyPhrase: String
    
    init(){
        self.randomEmptyPhrase = emptyPhrases.randomElement()!
    }
    
    var body: some View {
        HStack{
            Spacer()
            Text(randomEmptyPhrase)
                .padding(.top, 12)
                .font(.callout)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.vertical, 40)
    }
}
