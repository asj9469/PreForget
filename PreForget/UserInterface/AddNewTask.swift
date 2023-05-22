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
    let successfulAction: () -> Void
    
    var body: some View{
        TabView(){
            //first task name set page
            titleView(taskName: $taskName)
                .tabItem{
                    Text("Set Name")
                }
            
            //second details page
            detailsView(details: $details)
                .tabItem{
                    Text("Details")
                }
            otherView(urgency: $urgency, dueDate: $dueDate, reminderDate: $reminderDate)
                .tabItem{
                    Text("Other")
                }
        }
        .padding(.top, 20)
        .frame(width: 250, height: 180)
        
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
                vm.task.dueDate = dueDate
                vm.task.reminderDate = reminderDate
                
                successfulAction()
                if vm.task.isValid{
                    try? vm.save()
                    showAddField.toggle()
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

//MARK: Title View
struct titleView: View{
//    let names = ["my friend", "*custom input*"]
//    let randomName: String
    @FocusState private var focusedField: Bool
    @Binding var taskName: String
//
//    init(taskName: Binding<String>) {
//        self.randomName = names.randomElement()!
//        self._taskName = taskName
//    }
    @State private var redMessage: String = ""
    @State private var input: Bool = false
    var body: some View{
        VStack{
            Text("What's your task?")
                . padding(.bottom, 5)
            TextField("Come on, don't be shy", text: $taskName, axis: .vertical)
                .padding(.horizontal)
                .onChange(of: taskName) { newValue in
                    taskName = taskName
                    if(taskName.localizedCaseInsensitiveContains("nothin") || taskName.localizedCaseInsensitiveContains("nothing")){
                        redMessage = "LOLLL wdym nothing 🙄"
                    }else if(taskName.localizedCaseInsensitiveContains("sleep")){
                        redMessage = "...ok valid"
                    }else if(taskName.localizedCaseInsensitiveContains("hello") || taskName.localizedCaseInsensitiveContains("hi")){
                        redMessage = "hi wassup"
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

//MARK: Details View
struct detailsView: View{
    let detailPhrases = ["Wanna give me some details?", "Ok, so what is this exactly about", "Any details to remember?", "mhm I'm listening","Are there any specifics?", "Anything important about this task?"]
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
    
    var body: some View{
        VStack(alignment: .trailing){
//            Toggle("Is this urgent?", isOn: $showUrgency)
//                .padding(.vertical, 5)
            DatePicker(
                    "Due",
                    selection: $dueDate,
                    displayedComponents: [.date]
                )
            .padding(.top,5)
            .padding(.horizontal, 40)
            .padding(.leading, 12)
            
            HStack{
                Spacer()
                Text("When should I remind you?")
                Spacer()
            }
            .padding(.top, 5)
            
            DatePicker(
                "",
                selection: $reminderDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .padding(.top, -5)
            .padding(.horizontal, 20)
            .padding(.leading, 12)
            
            
            Toggle(isOn: $urgency){
                Text("Is this urgent?")
            }
                .padding(.top, 5)
                .padding(.leading, 11)
                .toggleStyle(.switch)
                .padding(.trailing, 50)
        }
    }
}
