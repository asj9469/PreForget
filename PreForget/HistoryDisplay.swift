//
//  History.swift
//  PreForget
//
//  Created by Anson Goo on 5/20/24.
//

import SwiftUI


class HistoryWindowController<RootView : View>: NSWindowController{
    
    convenience init(rootView: RootView) {
            let hostingController = NSHostingController(rootView: rootView.frame(width: 320, height: 400))
            let window = NSWindow(contentViewController: hostingController)
            window.setContentSize(NSSize(width: 320, height: 400))
            window.center()
            self.init(window: window)
        }
}

struct completedTask: Identifiable {
    let id = UUID()
    let taskName: String
    let completionDate: Date
}

struct historyView: View{
//    @Environment(\.managedObjectContext) var viewContext
    
    let completedTasks = [
            completedTask(taskName: "Sample Task 1", completionDate: Date().addingTimeInterval(-3600)),
            completedTask(taskName: "Sample Task 2", completionDate: Date().addingTimeInterval(-7200)),
            completedTask(taskName: "Sample Task 3", completionDate: Date().addingTimeInterval(-10800)),
            completedTask(taskName: "Sample Task 4", completionDate: Date().addingTimeInterval(-14400)),
            completedTask(taskName: "Sample Task 5", completionDate: Date().addingTimeInterval(-18000))
        ]
//    @FetchRequest(sortDescriptors: [
//        SortDescriptor(\.urgency_history, order: .reverse),
//        SortDescriptor(\.completedDate)]) var completedTasks: FetchedResults<CompletedTask>
    
    var body: some View{
        VStack {
            VStack(alignment: .leading){
                HStack{
                    Text("COMPLETED TASKS").font(.headline)
                    Spacer()
                    Text("completed on")
                        .padding(.trailing, 20)
                        .font(.system(size: 12))
                }
                .padding(.leading, 15)
                
                Divider()
            }
            .padding(.top)
            .padding(.bottom, 5)
            
            VStack(alignment: .leading){
                List{
                    ForEach(completedTasks) { task in
                        
                        HStack{
                            Text(task.taskName)
                                .font(.body)
                                .padding(.vertical, 3)
                                
                            Spacer()
                            Text("5/6/2024")
//                                Text("Completed on: \(task.formattedCompletedDate)")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print("Task tapped: \(task.taskName)")
                            let detailsView = completedTaskDetailsView()
                            let detailsWindow = CompletedTaskDetailsWindowController(rootView: completedTaskDetailsView())
                            detailsWindow.window?.title = "Task Details"
                            detailsWindow.showWindow(nil)
                            
                            NSApp.setActivationPolicy(.regular)
                            NSApp.activate(ignoringOtherApps: true)
                            detailsWindow.window?.orderFrontRegardless()
//                                    taskToDisplay = task
                            
                        }
                        .contextMenu{
                            Button ("View Details") {
                                let detailsView = completedTaskDetailsView()
                                let detailsWindow = CompletedTaskDetailsWindowController(rootView: completedTaskDetailsView())
                                detailsWindow.window?.title = "Task Details"
                                detailsWindow.showWindow(nil)
                                
                                NSApp.setActivationPolicy(.regular)
                                NSApp.activate(ignoringOtherApps: true)
                                detailsWindow.window?.orderFrontRegardless()
//                                        taskToDisplay = task
                            }
                        }
                        .padding(.bottom, 8)
                        .padding(.top, 8)
                    }
//                    .onDelete(perform: deleteTask)
                    
                    if(self.completedTasks.isEmpty){
                        Text("No completed tasks yet")
                    }
                }
                
            }
            
            Spacer()
            
            HStack{
                Button(action: {
                    NSApplication.shared.keyWindow?.close()
                }, label: {
                    Text("Close")
                })
            }
            .padding(.top, 8)
            .padding(.bottom)
        }
        .frame(width: 340, height: 350)
    }
    
//    func deleteTask(at offsets: IndexSet){
//        for offset in offsets{
//            let task = completedTasks[offset]
//            viewContext.delete(task)
//        }
//        try? viewContext.save()
//    }
}




struct historyView_Previews: PreviewProvider {
    static var previews: some View {
        historyView()
    }
}
