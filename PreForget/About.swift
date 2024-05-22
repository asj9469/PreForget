//
//  aboutView.swift
//  PreForget
//
//  Created by Anson Goo on 5/6/23.
//

import SwiftUI
class AboutWindowController<RootView : View>: NSWindowController{
    
    convenience init(rootView: RootView) {
            let hostingController = NSHostingController(rootView: rootView.frame(width: 350, height: 380))
            let window = NSWindow(contentViewController: hostingController)
            window.setContentSize(NSSize(width: 350, height: 380))
            window.center()
            self.init(window: window)
        }
}
struct aboutView: View {
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Image(systemName: "info.square")
                    .font(.title)
                Text("About this app")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 8)
            ScrollView{
                Text("This reminder app was developed to make task management easy, accessible, interactive, and fun. \n\nThis app can be helpful for individuals who often forget things and/or want to keep track of their tasks right on their Mac menubar. \n\n As a productivity enthusiast, my goal is to encourage people to become motivated in maintaining their tasks in an well-organized manner. \n\n I hope you find this app helpful :D")
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.top, 3)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
            }
            .frame(height: 230)
            HStack{
                Button(action: {
                    NSApplication.shared.keyWindow?.close()
                }, label: {
                    Text("Close")
                })
                .padding(.bottom, 8)
            }
            .padding(.top, 10)
        }
        .frame(width: 340, height: 350)
    }
}

struct aboutView_Previews: PreviewProvider {
    static var previews: some View {
        aboutView()
    }
}
