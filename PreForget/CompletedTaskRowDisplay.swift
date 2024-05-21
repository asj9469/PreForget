////
////  CompletedTaskRowDisplay.swift
////  PreForget
////
////  Created by Anson Goo on 5/20/24.
////
//import SwiftUI
//
//struct CompletedTaskRowView: View {
//    @Environment(\.managedObjectContext) var viewContext
//    @ObservedObject var completedTask: CompletedTask
//    
//    var body: some View {
//        HStack{
//            Text(task.taskName_history)
//                .font(.body)
//                .padding(.vertical, 3)
//                .onTapGesture {
//                    showDetails.toggle()
//                }
//                .contextMenu{
//                    Button ("View Details") {
//                        taskToDisplay = task
//                        showDetails.toggle()
//                    }
//                }
//            Spacer()
//            Text("Completed on:")
//            + Text(task.completedDate)
//        }
//    }
//}
