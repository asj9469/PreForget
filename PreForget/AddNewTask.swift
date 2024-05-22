//
//  AddNew.swift
//  PreForget
//
//  Created by Anson Goo on 4/10/23.
//

import SwiftUI

//MARK: Combined Tab View of Title, Details, and Other View
struct addNewView: View{
    @ObservedObject var vm: EditTaskViewModel
    @Binding var showAddField: Bool
    @Binding var imageData: Data
    
    @State var taskName: String = ""
    @State var details: String = ""
    @State var dueDate: Date = Date.now
    @State var reminderDate: Date = Date.now
    @State var urgency: Bool = false
    @State var reminder: Bool = false
    let successfulAction: () -> Void
    
    //title validation message
    @State var redMessage: String = ""
    let titlePhrases = ["Don't forget the title!", "Title is required", "We need a title to save the task", "Task name is required", "No task name... what a bold choice"]
    let randomTitlePhrase: String
    
    init(vm: EditTaskViewModel, showAddField: Binding<Bool>, imageData: Binding<Data>, successfulAction: @escaping () -> Void) {
        self.vm = vm
        self._showAddField = showAddField
        self._imageData = imageData
        self.successfulAction = successfulAction
        self.randomTitlePhrase = titlePhrases.randomElement()!
    }
    
    var body: some View{
        TabView(){
            //first task name set page
            setTaskView(taskName: $taskName, redMessage: $redMessage, details: $details)
                .tabItem{
                    Text("New Task")
                }
            
            //second details page
//            detailsView(details: $details)
//                .tabItem{
//                    Text("Details")
//                }
            
            otherView(urgency: $urgency, dueDate: $dueDate, reminderDate: $reminderDate, reminder: $reminder)
                .tabItem{
                    Text("Other")
                }
        }
        .padding(.top, 20)
        .frame(width: 300, height: 300)
        
        HStack{
            Button(action: {
                showAddField.toggle()
            }, label: {
                Text("Cancel")
            })
            .padding(.top, 5)
            .padding(.bottom, 10)
            
            Button(action: {
                
                vm.task.taskName = taskName
                vm.task.details = details
                vm.task.urgency = urgency
                vm.task.reminder = reminder
                vm.task.dueDate = dueDate
                vm.task.reminderDate = reminderDate
                
                successfulAction()
                if vm.task.isValid{
                    try? vm.save()
                    showAddField.toggle()
                }else{
                    redMessage = randomTitlePhrase
                }
                
            }, label: {
                Text("Save")
            })
            .padding(.top, 5)
            .padding(.bottom, 10)
            .padding(.horizontal)
        }
        .padding(.horizontal, 40)
        
    }
}

//MARK: Title + Details View
struct setTaskView: View{
    // title part
    @FocusState private var focusedField: Bool
    @Binding var taskName: String
    
    @Binding var redMessage: String
    @State private var input: Bool = false
    
    
    //detail part
    let detailPhrases = ["What are some details you want to remember?", "What is this exactly about?", "Any details to remember?","Are there any specifics?", "Anything important about this task?"]
    let randomDetailPhrase: String
    
    @Binding var details: String
    
    init(taskName: Binding<String>, redMessage:Binding<String>, details: Binding<String>){
        self.randomDetailPhrase = detailPhrases.randomElement()!
        self._taskName = taskName
        self._redMessage = redMessage
        self._details = details
    }
    
//    @State private var redMessage: String = ""
//    @State private var input: Bool = false
    
    
    var body: some View{
        VStack{
            Spacer()
            Text("What's your task?")
                .padding(.bottom, 5)
                .padding(.top,10)
            TextField("Come on, don't be shy", text: $taskName, axis: .vertical)
                .padding(.horizontal)
                .padding(.bottom, 10)
                .onChange(of: taskName) { newValue in
                    taskName = taskName
                    if(taskName.isEmpty){
                        redMessage = ""
                    }
                    if(taskName.localizedCaseInsensitiveContains("nothin") || taskName.localizedCaseInsensitiveContains("nothing")){
                        redMessage = "LOLLL wdym nothing 🙄"
                    }else if (taskName.localizedCaseInsensitiveContains("no")){
                        redMessage = "nahhhh come onnnnn"
                    }else if(taskName.localizedCaseInsensitiveContains("sleep")){
                        redMessage = "...ok valid"
                    }else if(taskName.localizedCaseInsensitiveContains("hello") || taskName.localizedCaseInsensitiveContains("hi")){
                        redMessage = "hi wassup"
                    }else{
                        redMessage = ""
                    }
                    
                    self.input = true
                }
            
            //details part
            Text(randomDetailPhrase)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
                .padding(.horizontal)
            
            ScrollView{
                TextField("Add details that you can't afford to forget", text: $details, axis: .vertical)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .lineLimit(4...15)
                    .onChange(of: details) { newValue in
                        details = details
                        
                        if(details == "nah" || details == "no"){
                            redMessage = "you sure?"
                        }else{
                            redMessage = ""
                        }
                        self.input = true
                    }
            }
            
            
            if input{
                Text(redMessage)
//                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.red)
                    .padding(.top, 1)
                    .padding(.bottom, 15)
            }
        }
    }
}

//MARK: Details View (not used for now)
struct detailsView: View{
    let detailPhrases = ["Important details you want to remember?", "What is this exactly about?", "Any details to remember?","Are there any specifics?", "Anything important about this task?"]
    let randomDetailPhrase: String
    
    @Binding var details: String
//    _ vm: EditTaskViewModel
    init(details: Binding<String>){
        self.randomDetailPhrase = detailPhrases.randomElement()!
        self._details = details
    }
    
    @State private var redMessage: String = ""
    @State private var input: Bool = false
    
    var body: some View{
        VStack{
            Text(randomDetailPhrase)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
                .padding(.horizontal)
            
            TextField("Tell me about it", text: $details, axis: .vertical)
                .padding(.horizontal)
                .onChange(of: details) { newValue in
                    details = details
                    
                    if(details == "nah" || details == "no"){
                        redMessage = "you sure?"
                    }else{
                        redMessage = ""
                    }
                    self.input = true
                }
            
            if input{
                Text(redMessage)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.red)
                    .padding(.top, 1)
            }
        }
    }
}

struct otherView: View{
    var color = #colorLiteral(red: 0.9981229901, green: 0.5598730445, blue: 0.8389188647, alpha: 1)
//    @ObservedObject var vm: EditTaskViewModel
    @Binding var urgency: Bool
    @Binding var dueDate: Date
    @Binding var reminderDate: Date
    @Binding var reminder: Bool
    
    var body: some View{
        VStack(alignment: .center) {
        VStack(alignment: .trailing){
//            Toggle("Is this urgent?", isOn: $showUrgency)
//                .padding(.vertical, 5)
            HStack{
                Spacer()
                Text("Due / Deadline")
                Spacer()
            }
            .padding(.top, -5)
            
            DatePicker(
                    "",
                    selection: $dueDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
            .padding(.top,-5)
            .padding(.horizontal, 40)
            .padding(.leading, 12)
            
            HStack{
                Spacer()
                Text("Set Reminder Time")
                Spacer()
            }
            .padding(.top, 5)
            
            DatePicker(
                "",
                selection: $reminderDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .padding(.top, -5)
            .padding(.horizontal, 40)
            .padding(.leading, 12)
            .padding(.bottom, 10)
        }
            
            Toggle(isOn: $reminder){
                Text("Set reminder")
            }
            .padding(.top, 5)
            .padding(.leading, 11)
            .toggleStyle(.switch)
//            .padding(.trailing, 50)
            
            Toggle(isOn: $urgency){
                Text("Is this urgent?")
            }
                .padding(.top, 5)
                .padding(.leading, 11)
                .toggleStyle(.switch)
                .padding(.trailing, 6)
        }
    }
}
