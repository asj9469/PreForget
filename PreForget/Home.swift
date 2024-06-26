//
//  Home.swift
//  PreForget
//
//  Created by Anson Goo on 4/9/23.
//

import SwiftUI
import NVMColor
import AppKit
import UserNotifications

//mostly deals with functions
struct Home: View {
    
    let un = UNUserNotificationCenter.current()
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.urgency, order: .reverse),
        SortDescriptor(\.dueDate)]) var tasks: FetchedResults<Task>
    
//    @FetchRequest(sortDescriptors: [
//        SortDescriptor(\.completedDateTime, order: .reverse)]) var completedTasks: FetchedResults<CompletedTask>
    
    var dynamicCustomColor: String {
        if colorScheme == .dark {
            return "717576"
        } else {
            return "bec5c7"
        }
    }
    
    @AppStorage("customColor") var customColor: String = "717576"
    @AppStorage("imageData") var imageData: Data = NSImage(imageLiteralResourceName: "cautionSign").tiffRepresentation!
    @State var showAddField: Bool = false
    @State private var selectedTab = "titleView"
    
    //edit task
    @State var showPendingNotifs = false
    @State var shouldShowAddSuccess = false
    @State var shouldShowCompleteSuccess = false
    @State var shouldShowNotifSuccess = false
    @State var shouldHideNotifSuccess = false
    
    @State var newTask: Task?
    @State var taskToEdit: Task?
    @State private var isMenuOpen = false

    var body: some View {
        ZStack{
            VStack{
                // MARK: Title
                ZStack(alignment: .trailing){
                    HStack{
                        Button {
                            let aboutView = aboutView()
                            let hostingController = NSHostingController(rootView: aboutView.frame(width: 350, height: 380))
                            let window = NSWindow(contentViewController: hostingController)
                            
                            window.setContentSize(NSSize(width: 350, height: 380))
                            window.center()
                            
                            window.title = "About this app"
                            window.makeKeyAndOrderFront(nil)
                            window.orderFrontRegardless()
                            
                        } label: {
                            Image(systemName: "info.circle.fill")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.top, 12)
                        .padding(.trailing, 270)
                    }
                    
                    HStack{
                        Spacer()
                        Text("Before You Forget...")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.top, 9)
                        Spacer()
                    }
                    HStack{
                        Menu {
                            Button {
                                isMenuOpen.toggle()
                                let settingsView = settingsView(customColor: $customColor, customImageData: $imageData)
                                let hostingController = NSHostingController(rootView: settingsView.frame(width: 320, height: 400))
                                let window = NSWindow(contentViewController: hostingController)
                                
                                window.setContentSize(NSSize(width: 320, height: 400))
                                window.center()
                                
                                window.title = "Settings"
                                window.makeKeyAndOrderFront(nil)
                                window.orderFrontRegardless()
                            } label:{
                                Text("Settings")
                            }
                            .keyboardShortcut(",")
                            
                            Button {
                                isMenuOpen.toggle()
                                let historyView = historyView()
                                    .environment(\.managedObjectContext, self.viewContext)
                                let hostingController = NSHostingController(rootView: historyView.frame(width: 320, height: 400))
                                let window = NSWindow(contentViewController: hostingController)
                                window.setContentSize(NSSize(width: 320, height: 400))
                                window.center()
                                
                                window.title = "History"
                                window.makeKeyAndOrderFront(nil)
                                window.orderFrontRegardless()
                            } label : {
                                Text("History")
                            }
                            .keyboardShortcut("h")
                            
                            Button(action: {
                                NSApplication.shared.terminate(nil)
                            }) {
                                Text("Quit")
                            }
                            .keyboardShortcut("q")
                            
                        } label: {
                            Image(systemName: "gearshape.fill")
                        }
                        .menuStyle(BorderlessButtonMenuStyle())
                        .buttonStyle(BorderlessButtonStyle())
                        .buttonStyle(PlainButtonStyle())
                        .buttonStyle(.plain)
                        .padding(.top, 9)
                        .opacity(0.6)
                            
                    }
                    .padding(.trailing, 10)
                }
                .padding(.vertical, 5)
                
                // MARK: Task list
                VStack(alignment: .leading){
                    List{
                        ForEach(tasks) { task in
                            
                            TaskRowView(task: task, taskToEdit: $taskToEdit, customColor: $customColor, shouldShowCompleteSuccess: $shouldShowCompleteSuccess, shouldShowNotifSuccess: $shouldShowNotifSuccess, shouldHideNotifSuccess: $shouldHideNotifSuccess, imageData: $imageData)
                        }
                        .onDelete(perform: deleteTask)
                        
                        if(self.tasks.isEmpty){
                            Spacer()
                            NoTaskView()
                            Spacer()
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
                        .padding(.vertical, 2)
                        .frame(maxWidth: 200, maxHeight: 31)
                        .contentShape(Rectangle())
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
        .onAppear {
            customColor = dynamicCustomColor
        }
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
            .frame(width: 360, height: 360)
            
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
