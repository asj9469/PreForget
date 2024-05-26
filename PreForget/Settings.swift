//
//  Settings.swift
//  PreForget
//
//  Created by Anson Goo on 4/20/23.
//

import SwiftUI
import PhotosUI
import UserNotifications
import LaunchAtLogin


//class SettingsWindowController<RootView : View>: NSWindowController{
//    
//    convenience init(rootView: RootView) {
//            let hostingController = NSHostingController(rootView: rootView.frame(width: 320, height: 400))
//            let window = NSWindow(contentViewController: hostingController)
//            window.setContentSize(NSSize(width: 320, height: 400))
//            window.center()
//            self.init(window: window)
//        }
//}

struct settingsView: View{
    
    @Environment(\.managedObjectContext) var viewContext
    let un = UNUserNotificationCenter.current()
    @Binding var customColor: String
    @State var color: Color = Color.pink
    
    @Binding var customImageData: Data
    @State var customImageItem: PhotosPickerItem?
    @State var imageData: Data = NSImage(imageLiteralResourceName: "cautionSign").tiffRepresentation!
    
    @State var circle1: Bool = true
    @State var circle2: Bool = false
    @State var text1: String = "Wassup I'm a preview 😎"
    @State var text2: String = "btw you can edit these"
    
    var body: some View{
        VStack {
            VStack(alignment: .leading){
                Text("APP SETTINGS").font(.headline)
                    .padding(.leading, 15)
                
                Divider()
                
                LaunchAtLogin.Toggle("Launch at Login")
                    .padding(.top, 5)
                    .padding(.leading, 30)
                    
            }
            .padding(.top)
            .padding(.bottom, 10)
            
            VStack(alignment: .leading){
                HStack{
                    Text("COLOR SETTINGS").font(.headline)
                        .padding(.leading, 15)
                    Spacer()
                    ColorPicker("", selection: $color, supportsOpacity: false)
                        .padding(.trailing, 15)
                        .font(.headline)
                }
                
                Divider()
                
                HStack{
                    Button{
                        circle1.toggle()
                    } label:{
                        Image(systemName: circle1 ? "circle.circle":"circle")
                            .font(.body)
                            .imageScale(.large)
                            .foregroundColor(color)
                    }
                    .padding(.leading, 45)
                    .padding(.horizontal, 5.0)
                    .padding(.top, 3)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    TextField(text1, text: $text1)
                        .font(.body)
                        .padding(.vertical, 3)
                        .padding(.trailing, 60)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                
                HStack{
                    Button{
                        circle2.toggle()
                    } label:{
                        Image(systemName: circle2 ? "circle.circle":"circle")
                            .font(.body)
                            .imageScale(.large)
                            .foregroundColor(color)
                    }
                    .padding(.leading, 45)
                    .padding(.horizontal, 5.0)
                    .padding(.top, 3)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    TextField(text2, text: $text2)
                        .font(.body)
                        .padding(.vertical, 3)
                        .padding(.trailing, 60)
                        .textFieldStyle(PlainTextFieldStyle())
                }
            }
            HStack{
                Spacer()
                Button(action: {
                }, label: {

                    Text("+ ADD NEW TASK")
                        .font(.callout)
                        .fontWeight(.bold)
                        .padding(.vertical, 4.0)
                        .frame(maxWidth: 200)
                        .background(
                            ZStack{
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(color)
                            }
                        )
                })
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 5)
                Spacer()
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading){
                ZStack(alignment: .trailing){
                    HStack{
                        Text("NOTIFICATION SETTINGS").font(.headline)
                            .padding(.leading, 15)
                        Spacer()
                    }
                    Button {
                        
                        //initial permission request
                        un.requestAuthorization(options: [.alert, .badge, .sound]) { authorized, error in
                            if authorized {
                                print("All set!")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                        
                        let content = UNMutableNotificationContent()
                        let id = "ID"
                        content.title = "PreForget Reporting 🫡"
                        content.subtitle = "Reminder: \"test notification\""
                        content.body = "Due: \"MM/DD/YYYY\""
                        content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: "notifSound.wav"))
                        content.categoryIdentifier = "reminderNotif"
                        
//                        let launchApp = UNNotificationAction(identifier: "launchApp", title: "View in app", options: [.foreground])
                        
//                        let fileUrl = URL(fileURLWithPath: UserDefaults.standard.string(forKey: "notificationIcon")!)
                        if let attachment = UNNotificationAttachment.create(identifier: "img.jpeg", imageData: imageData as Data, options: nil)
                        {
                            content.attachments = [attachment]
                        }
                        
                        let category = UNNotificationCategory(identifier: "reminderNotif", actions: [], intentIdentifiers: [], options: [])

                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        
                        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

                        self.un.setNotificationCategories([category])
                        self.un.add(request) { (error : Error?) in
                            if let theError = error {
                                print(theError.localizedDescription)
                            }
                        }
                        
                    } label: {
                        Label("Try Out", systemImage: "bell.fill")
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 15)
                }
                
                    
                Divider()
                    .padding(.bottom, 10)
                
                HStack{
                    PhotosPicker(selection: $customImageItem, photoLibrary:.shared()) {
                        Label("Select Image", systemImage: "photo")
                    }
                    .padding(.leading, 30)
                    Spacer()
                    
                    if let customImage = NSImage(data: imageData){
                        Spacer()
                        Image(nsImage: customImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }else{
                        Spacer()
                        Image("cautionSign")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Spacer()
                    }
                }
                
            }
            .padding(.top, 5)
            .onChange(of: customImageItem) { newImage in
                guard let customImage = customImageItem else{
                    return
                }
                customImage.loadTransferable(type: Data.self) { result in
                    switch result{
                    case.success(let data):
                        if let data = data{
                            self.imageData = data
                        }
                    case.failure(let failure):
                        fatalError("\(failure)")
                    }
                }
                
                    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let url = documents.appendingPathComponent("notificationIcon.png")

                        do {
                            // Write to Disk
                            try imageData.write(to: url)

                            // Store URL in User Defaults
                            UserDefaults.standard.set(url, forKey: "notificationIcon")

                        } catch {
                            print("Unable to Write Data to Disk (\(error))")
                        }
            }
            .padding(.bottom, 10)
            
            Spacer()
            
            HStack{
                Button(action: {
                    if (NSColorPanel.shared.isVisible) {
                        NSColorPanel.shared.orderOut(nil)
                        }
                    NSApplication.shared.keyWindow?.close()
                    
                }, label: {
                    Text("Cancel")
                })
                .padding(.leading, 15)
                
                Spacer()
                Button(action: {
                    
                    if(LaunchAtLogin.isEnabled == true){
                        LaunchAtLogin.isEnabled = false
                    }
                    color = Color(hex:"406cb4")!
                    circle1 = true
                    circle2 = false
                    text1 = "Mission complete :D"
                    text2 = "Successfully restored 🫡"
                    
                    imageData = NSImage(imageLiteralResourceName: "cautionSign").tiffRepresentation!
                    
//                    if(imageData != nil){
//                        imageData = nil
//                    }
                }, label: {
                    Text("Restore")
                })
                
                Button(action: {
                    customColor = color.hex ?? ""
                    customImageData = imageData
                    if (NSColorPanel.shared.isVisible) {
                        NSColorPanel.shared.orderOut(nil)
                        }
                    
                    NSApplication.shared.keyWindow?.close()

                }, label: {
                    Text("Save Changes")
                })
                .padding(.trailing, 15)
            }
            .padding(.bottom)
        }
        .onAppear{
            if(customColor != ""){
                color = Color(hex: customColor)!
            }
            
            if(customImageData != imageData){
                imageData = customImageData
            }
            
        }
        .frame(width: 300, height: 280)
    }
}

extension UNNotificationAttachment {
    static func create(identifier: String, imageData: Data?, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            guard let imageData = imageData else {
                return nil
            }
            try imageData.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
                print("error " + error.localizedDescription)
        }
        return nil
    }
}
