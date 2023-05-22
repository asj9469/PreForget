////
////  NotificationListView.swift
////  PreForget
////
////  Created by Anson Goo on 5/5/23.
////
//
//import SwiftUI
//import UserNotifications
//
//struct NotificationListView: View {
//    @EnvironmentObject var nm: NotificationManager
//    @Binding var showPendingNotifs: Bool
//    let un = UNUserNotificationCenter.current()
//    var body: some View {
//        VStack{
//            List {
//                ForEach(nm.pendingRequests, id: \.identifier) { request in
//                    VStack(alignment: .leading) {
//                        HStack{
//                            Spacer()
//                            Text(request.identifier)
//                            Spacer()
//                        }
//
//                        HStack {
//                            Spacer()
//                            Text(request.content.title)
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                            Spacer()
//                        }
//
//                    }
//                    .swipeActions {
//                        Button("Delete", role: .destructive) {
//                            un.removePendingNotificationRequests(withIdentifiers: [request.identifier])
//                        }
//                    }
//
//                }
//
//            }
//            HStack{
//                Button(action: {
//                    showPendingNotifs.toggle()
//                }, label: {
//                    Text("Close")
//                })
//                .padding(.bottom, 8)
//            }
//        }
//        .frame(width: 260, height: 260)
//
//    }
//}
////
////struct NotificationListView_Previews: PreviewProvider {
////    static var previews: some View {
////        NotificationListView()
////    }
////}
