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

struct completedTaskDetailsView: View{
    @Environment(\.dismiss) var dismiss
    @State private var nameViewContentSize: CGSize = .zero
    @State private var detailsViewContentSize: CGSize = .zero
    let task: CompletedTask
    
    var body: some View{
        VStack(alignment: .leading){
            HStack(alignment: VerticalAlignment.top){
                Text("Name: ")
                    .padding(.leading, 15)
                
                Text(task.taskName_c)
                    .lineLimit(nil)
                    .padding(.leading, 27)
                    .padding(.top, 5.0)
                    .overlay(GeometryReader { geo in
                        Color.clear.onAppear {
                            nameViewContentSize = geo.size
                        }
                    })
            }
            .padding(.bottom, 10)
            .frame(minWidth: 100, maxHeight: max(100, nameViewContentSize.height))
            
            HStack(alignment: VerticalAlignment.top){
                Text("Details: ")
                    .padding(.leading, 15)
                if(task.details_c.isEmpty){
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
                        Text(task.details_c)
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
                Text(task.formattedDate_c)
                    .padding(.bottom,5)
                    .padding(.leading, 42)
            }
            
            HStack{
                Text("Remind: ")
                    .padding(.bottom,5)
                    .padding(.leading, 15)
                Text(task.formattedReminderDate_c)
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
                Label("Urgent", systemImage: task.urgency_c == true ? "square.fill" : "square")
                Label("Reminder", systemImage: task.reminder_c == true ? "square.fill" : "square")
                Spacer()
            }
            
            HStack{
                Spacer()
                Button(action: {
                    NSApplication.shared.keyWindow?.close()
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





//struct completedTaskDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        completedTaskDetailsView()
//    }
//}
