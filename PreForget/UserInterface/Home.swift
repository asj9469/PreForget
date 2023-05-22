//
//  Home.swift
//  PreForget
//
//  Created by Anson Goo on 4/9/23.
//

import SwiftUI
import NVMColor

import UserNotifications

//mostly deals with functions
struct Home: View {
    
    let un = UNUserNotificationCenter.current()
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.urgency, order: .reverse),
        SortDescriptor(\.dueDate)]) var tasks: FetchedResults<Task>
    @AppStorage("customColor") var customColor: String = "406cb4"
    @AppStorage("imageData") var imageData: Data = NSImage(imageLiteralResourceName: "cautionSign").tiffRepresentation!
    @State var showAddField: Bool = false
    @State private var selectedTab = "titleView"
    
    //edit task
    @State var showDetails: Bool = false
    @State var showPendingNotifs = false
    @State var shouldShowAddSuccess = false
    @State var shouldShowCompleteSuccess = false
    @State var shouldShowNotifSuccess = false
    @State var shouldHideNotifSuccess = false
    
    @State var newTask: Task?
    @State var taskToEdit: Task?

    var body: some View {
        ZStack{
            VStack{
                // MARK: Title
                ZStack(alignment: .trailing){
                    HStack{
                        Spacer()
                        Text("Before You Forget...")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.top, 9)
                        Spacer()
                    }
                    HStack{
//                        Button {
//                            showPendingNotifs.toggle()
//                        }label: {
//                            Image(systemName: "bell.fill")
//                        }
//                        .buttonStyle(BorderlessButtonStyle())
//                        .buttonStyle(PlainButtonStyle())
//                        .padding(.top, 9)
                        
                        Button {
                            let settingsView = settingsView(customColor: $customColor, customImageData: $imageData)
                            let settingsWindow = SettingsWindowController(rootView: settingsView)
                            settingsWindow.window?.title = "Settings";
                            settingsWindow.showWindow(nil)
                            
                            NSApp.setActivationPolicy(.regular)
                            NSApp.activate(ignoringOtherApps: true)
                            settingsWindow.window?.orderFrontRegardless()
                        } label: {
                            Image(systemName: "gearshape.fill")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .buttonStyle(PlainButtonStyle())
                        .buttonStyle(.plain)
                        .padding(.top, 9)
                    }
                    
                    .padding(.trailing, 10)
                }
                
                // MARK: Task list
                VStack(alignment: .leading){
                    List{
                        ForEach(tasks) { task in
                            
                            TaskRowView(task: task, showDetails: $showDetails, taskToEdit: $taskToEdit, customColor: $customColor, shouldShowCompleteSuccess: $shouldShowCompleteSuccess, shouldShowNotifSuccess: $shouldShowNotifSuccess, shouldHideNotifSuccess: $shouldHideNotifSuccess, imageData: $imageData)
                        }
                        .onDelete(perform: deleteTask)
                        
                        if(self.tasks.isEmpty){
                            NoTaskView()
                        }
                    }
                    
                }
                
                // MARK: Add New Task Button
                Button(action: {
                    showAddField.toggle()
                }, label: {
                    
                    Text("+ ADD NEW TASK")
                        .font(.callout)
                        .fontWeight(.bold)
                        .padding(.vertical, 4.0)
                        .frame(maxWidth: 200)
                        .background(
                            ZStack{
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(hex: customColor) ?? Color(.systemPink))
                            }
                        )
                })
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 30)
                .padding(.top, 5)
                .padding(.bottom, 20)
                .disabled(showAddField)
            }
        }
//        .sheet(isPresented: $showPendingNotifs, content: {
//            NotificationListView(showPendingNotifs: $showPendingNotifs)
//        })
        .sheet(isPresented: $showAddField){
            addNewView(vm: .init(provider: TaskProvider.shared, task: newTask), showAddField: $showAddField, imageData: $imageData){
                withAnimation(.spring().delay(0.25)) {
                    self.shouldShowAddSuccess.toggle()
                }
            }
        }
        .sheet(item: $taskToEdit, onDismiss: {
            taskToEdit = nil
        }, content: { task in
            
            TabView{
//
//                detailsDisplayView()
//                detailsEditView()
                detailsDisplayView(task: task)
                    .tabItem{
                        Text("Details")
                    }
                
                detailsEditView(task: task, vm: .init(provider: TaskProvider.shared, task: task), imageData: $imageData)
                    .tabItem {
                        Text("Edit Task")
                    }
            }
            .padding(.vertical, 10)
//            .frame(width: 300, height: 250)
            .frame(width: 290, height: 290)
            
        })
        .overlay{
            if shouldShowAddSuccess{
                AddedPopoverView()
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           withAnimation(.spring().delay(1)) {
                               self.shouldShowAddSuccess.toggle()
                            }
                        }
                    }
            }
            if shouldShowCompleteSuccess{
                CompletedPopoverView()
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           withAnimation(.spring().delay(1)) {
                               self.shouldShowCompleteSuccess.toggle()
//                               try? viewContext.save()
                            }
                        }
                    }
            }
            if shouldShowNotifSuccess{
                NotifOnPopoverView()
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           withAnimation(.spring().delay(1)) {
                               self.shouldShowNotifSuccess.toggle()
                            }
                        }
                    }
            }
            if shouldHideNotifSuccess{
                NotifOffPopoverView()
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           withAnimation(.spring().delay(1)) {
                               self.shouldHideNotifSuccess.toggle()
                            }
                        }
                    }
            }
            
        }
        
    }

    func deleteTask(at offsets: IndexSet){
        for offset in offsets{
            let task = tasks[offset]
            viewContext.delete(task)
        }
        try? viewContext.save()
    }
    
}

