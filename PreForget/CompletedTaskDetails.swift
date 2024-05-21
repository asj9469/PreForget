//
//  CompletedTaskDetails.swift
//  PreForget
//
//  Created by Anson Goo on 5/20/24.
//

import SwiftUI


class CompletedTaskDetailsWindowController<RootView : View>: NSWindowController{
    
    convenience init(rootView: RootView) {
            let hostingController = NSHostingController(rootView: rootView.frame(width: 320, height: 300))
            let window = NSWindow(contentViewController: hostingController)
            window.setContentSize(NSSize(width: 320, height: 300))
            window.center()
            self.init(window: window)
        
            let desiredSize = hostingController.view.intrinsicContentSize
            window.setContentSize(desiredSize)
            
            window.center()
            self.init(window: window)
        }
}

struct completedtask: Identifiable {
    let id = UUID()
    let taskName: String
    let completionDate: Date
    let details: String
    let dueDate: Date
    let formattedDate: String
    let formattedReminderDate: String
    let formattedCompletedDateTime: String
    let urgency: Bool
    let reminder: Bool
}

struct completedTaskDetailsView: View{
    @Environment(\.dismiss) var dismiss
    @State private var nameViewContentSize: CGSize = .zero
    @State private var detailsViewContentSize: CGSize = .zero
//    let task: CompletedTask
    let task = completedtask(
            taskName: "Sample Task 1",
            completionDate: Date().addingTimeInterval(-3600),
            details: "This is a detailed description of the task.",
            dueDate: Date().addingTimeInterval(3600),
            formattedDate: "5/20/2024",
            formattedReminderDate: "5/20/2024 11:59pm",
            formattedCompletedDateTime: "5/23/2024 11:59pm",
            urgency: true,
            reminder: true
        )
    
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
                .padding(.leading, 31)
                .padding(.trailing, 10)
                .padding(.vertical,6)
                .frame(height: 60)
                
            }
            .padding(.bottom, 10)
            .frame(maxHeight: nameViewContentSize.height)
            
            HStack(alignment: VerticalAlignment.top){
                Text("Details: ")
                    .padding(.leading, 15)
                if(task.details.isEmpty){
                    ScrollView{
                        Text("(no description)")
                            .lineLimit(nil)
                            .overlay(GeometryReader { geo in
                                Color.clear.onAppear {
                                    detailsViewContentSize = geo.size
                                }
                            })
                        }
                    .padding(.leading, 25)
                }else{
                    ScrollView{
                        Text(task.details)
                            .lineLimit(nil)
                            .overlay(GeometryReader { geo in
                                Color.clear.onAppear {
                                    detailsViewContentSize = geo.size
                                }
                            })
                    }
                    
                    .padding(.leading, 25)
                }
            }
            .padding(.top, -10.0)
            .frame(maxHeight: detailsViewContentSize.height)
            
            HStack{
                Text("Due: ")
                    .padding(.bottom,5)
                    .padding(.leading, 15)
                Text(task.formattedDate)
                    .padding(.bottom,5)
                    .padding(.leading, 42)
            }
            
            HStack{
                Text("Remind: ")
                    .padding(.bottom,5)
                    .padding(.leading, 15)
                Text(task.formattedReminderDate)
                    .padding(.leading, 21)
                    .padding(.bottom,5)
            }
            
            HStack{
                Text("Completed: ")
                    .padding(.bottom,5)
                    .padding(.leading, 15)
                Text(task.formattedCompletedDateTime)
                    .padding(.bottom,5)
            }
            
            HStack{
                Spacer()
                Label("Urgent", systemImage: task.urgency == true ? "square.fill" : "square")
                Label("Reminder", systemImage: task.reminder == true ? "square.fill" : "square")
                Spacer()
            }
            
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
        .frame(width: 300)
    }
    }
    
//    func deleteTask(at offsets: IndexSet){
//        for offset in offsets{
//            let task = completedTasks[offset]
//            viewContext.delete(task)
//        }
//        try? viewContext.save()
//    }




struct completedTaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        completedTaskDetailsView()
    }
}
