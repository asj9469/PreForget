//
//  History.swift
//  PreForget
//
//  Created by Anson Goo on 5/20/24.
//

import SwiftUI

//class HistoryWindowController<RootView : View>: NSWindowController{
//    
//    convenience init(rootView: RootView) {
//            let hostingController = NSHostingController(rootView: rootView.frame(width: 320, height: 400))
//            let window = NSWindow(contentViewController: hostingController)
//            window.setContentSize(NSSize(width: 320, height: 400))
//            window.center()
//            self.init(window: window)
//        }
//}

struct historyView: View{
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.completedDateTime, order: .reverse)], predicate: NSPredicate(value: true)) var completedTasks: FetchedResults<CompletedTask>

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
            
            VStack(alignment: .leading){
                List{
                    ForEach(completedTasks) { task in
                        
                        HStack{
                            Text(task.taskName_c)
                                .font(.body)
                                .padding(.vertical, 3)
                            
                            Spacer()
                            Text("\(task.formattedCompletedDate)")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            let detailsView = completedTaskDetailsView(task: task)
                            let hostingController = NSHostingController(rootView: detailsView.frame(width: 320, height: 300))
                            let window = NSWindow(contentViewController: hostingController)
                            window.setContentSize(NSSize(width: 320, height: 300))
                            window.center()
                            window.title = "Task Details"
                            window.makeKeyAndOrderFront(nil)
                            window.orderFrontRegardless()
                        }
                        .contextMenu{
                            Button ("View Details") {
                                let detailsView = completedTaskDetailsView(task: task)
                                let hostingController = NSHostingController(rootView: detailsView.frame(width: 320, height: 300))
                                let window = NSWindow(contentViewController: hostingController)
                                window.setContentSize(NSSize(width: 320, height: 300))
                                window.center()
                                window.title = "Task Details"
                                window.makeKeyAndOrderFront(nil)
                                window.orderFrontRegardless()
                            }
                        }
                        .padding(.bottom, 8)
                        .padding(.top, 8)
                    }
                    .onDelete(perform: deleteTask)
                    
                    if(self.completedTasks.isEmpty){
                        VStack{
                            Spacer()
                            Text("No completed tasks yet")
                                .font(.callout)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        
                    }
                }
                
            }
            .padding(.top,-8)
            
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
        .frame(width: 320, height: 400)
    }
    
    func deleteTask(at offsets: IndexSet){
        for offset in offsets{
            let task = completedTasks[offset]
            viewContext.delete(task)
        }
        try? viewContext.save()
    }
}
