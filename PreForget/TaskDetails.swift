//
//  ViewEditDetails.swift
//  PreForget
//
//  Created by Anson Goo on 4/14/23.
//

import SwiftUI
import UserNotifications

struct detailsDisplayView: View {
    @Environment(\.dismiss) var dismiss
    @State private var nameViewContentSize: CGSize = .zero
    @State private var detailsViewContentSize: CGSize = .zero
    
    let task: Task
    
    var body: some View{

        VStack(alignment: .leading){
            HStack(alignment: VerticalAlignment.top){
                Text("Name: ")
                    .padding(.top, 20.0)
                    .padding(.leading, 15)
                
                ScrollView{
                    Text(task.taskName)
                        .lineLimit(nil)
                        .padding(.top, 4.0)
                        .overlay(GeometryReader { geo in
                            Color.clear.onAppear {
                                nameViewContentSize = geo.size
                            }
                        })
                    }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.vertical,6)
                .frame(height: 60)
                
            }
            .padding(.top, 30)
            .padding(.bottom, 20)
            .frame(maxHeight: nameViewContentSize.height)
            
            HStack(alignment: VerticalAlignment.top){
                Text("Details: ")
                    .padding(.leading, 15)
                if(task.details.isEmpty){
                    Text("(no description)")
                        .lineLimit(nil)
                        .overlay(GeometryReader { geo in
                            Color.clear.onAppear {
                                detailsViewContentSize = geo.size
                            }
                        })
                    .padding(.leading, 4.0)
                    
                }else{
                    ScrollView{
                        Text(task.details)
                            .overlay(GeometryReader { geo in
                                Color.clear.onAppear {
                                    detailsViewContentSize = geo.size
                                }
                            })
                    }
                    .frame(maxHeight: detailsViewContentSize.height)
                    .padding(.leading, 4.0)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            
            HStack{
                Text("Due: ")
                    .padding(.bottom,5)
                    .padding(.leading, 15)
                Text(task.formattedDate)
                    .padding(.bottom,5)
                    .padding(.leading, 20)
            }
            
            HStack{
                Text("Remind: ")
                    .padding(.bottom,5)
                    .padding(.leading, 15)
                Text(task.formattedReminderDate)
                    .padding(.bottom,5)
            }

            HStack{
                Spacer()
                Label("Urgent", systemImage: task.urgency == true ? "square.fill" : "square")
                Label("Reminder", systemImage: task.reminder == true ? "square.fill" : "square")
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom, -1.0)
            
            HStack{
                Spacer()
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Close")
                })
                .padding(.bottom, 10)
                .padding(.top, 10)
                Spacer()
            }
        }
        .frame(width: 320, height: 320)
    }
    
}

struct detailsEditView: View{
    let task: Task
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: EditTaskViewModel
    @State private var nameViewContentSize: CGSize = .zero
    @State private var detailsViewContentSize: CGSize = .zero
    @Binding var imageData: Data
    
    var body: some View{
        VStack(alignment: .leading){
            HStack(alignment: VerticalAlignment.top){
                Text("Name: ")
                    .padding(.top, 10.0)
                    .padding(.leading, 15)
                TextField(task.taskName, text: $vm.task.taskName)
                    .padding(.leading, 6)
                    .padding(.top, 18.0)
                    .padding(.trailing, 10)
                    .overlay(GeometryReader { geo in
                        Color.clear.onAppear {
                            nameViewContentSize = geo.size
                        }
                    })
                    .frame(height: 20)
            }
            .padding(.top, -20.0)
            
            .frame(maxHeight: nameViewContentSize.height)
            
            HStack(alignment: VerticalAlignment.top){
                Text("Details: ")
                    .padding(.top,3)
                    .padding(.leading, 15)
                if(task.details.isEmpty){
                    ScrollView{
                        TextField("(no description)", text: $vm.task.details, axis: .vertical)
                            .padding(.top,-3)
                            .lineLimit(4...10)
                            .overlay(GeometryReader { geo in
                                Color.clear.onAppear {
                                    detailsViewContentSize = geo.size
                                }
                            })
                    }
                    
                }else{
                    ScrollView{
                        TextField(task.details, text: $vm.task.details, axis: .vertical)
                            .padding(.top,-3.0)
                            .frame(minHeight: 30)
                            .overlay(GeometryReader { geo in
                                Color.clear.onAppear {
                                    detailsViewContentSize = geo.size
                                }
                            })
                        }
                    }
                
            }
            .padding(.top, -3.0)
            .frame(minHeight: 50, maxHeight: max(50, detailsViewContentSize.height))
            
            HStack{
                Text("Due: ")
                    .padding(.bottom,5)
                    .padding(.leading, 15)

                DatePicker(
                        "",
                        selection: $vm.task.dueDate,
                        displayedComponents: [.date]
                    )
                .datePickerStyle(.compact)
                .padding(.bottom,5)
                .padding(.leading, 10.0)
            }
            .padding(.bottom, -14.0)
            
            HStack{
                Text("Remind: ")
                    .padding(.bottom,5)
                    .padding(.leading, 15)

                DatePicker(
                        "",
                        selection: $vm.task.reminderDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                .datePickerStyle(.compact)
                .padding(.bottom,5)
                .padding(.leading, -11)
            }
            .padding(.bottom, -14.0)

            HStack{
                Spacer()
                Toggle("Urgent", isOn: $vm.task.urgency)
                Toggle("Reminder", isOn: $vm.task.reminder)
                
                Spacer()
            }
            .padding(.top, 9.0)
            

            HStack{
                Spacer()
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                })
                .padding(.bottom, 10)
                .padding(.top, 3)
                
                Button(action: {
                    if(vm.task.reminder == true){
//                        let startDate = Date.now
//                        let endDate = task.dueDate
                        
                        NotificationManager(taskName: vm.task.taskName, formattedDate: vm.task.formattedDate, imageData: $imageData).requestNotifPermission()
                        NotificationManager(taskName: vm.task.taskName, formattedDate: vm.task.formattedDate, imageData: $imageData).scheduleNotif(with: hashString(obj: task), date: vm.task.reminderDate)
                    }
                    
                    if(vm.task.reminder != true){
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [hashString(obj: task)])
                    }
                    try? vm.save()
                    dismiss()
                }, label: {
                    Text("Save")
                })
                .padding(.bottom, 10)
                .padding(.top, 3.0)
                
                Spacer()
            }
            .padding(.bottom, 2.0)

        }
        .frame(width: 320, height: 320)
    }
}

func hashString(obj: AnyObject) -> String {
    return String(UInt(bitPattern: ObjectIdentifier(obj)))
}

