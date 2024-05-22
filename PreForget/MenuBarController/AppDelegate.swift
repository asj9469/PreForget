//
//  AppDelegate.swift
//  PreForget
//
//  Created by Anson Goo on 4/9/23.
//

import Cocoa
import SwiftUI
import UserNotifications

class AppDelegate:  NSObject, NSApplicationDelegate {
    
    // popover
    var popover: NSPopover!
    var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view (i.e. the content).
        let contentView = Home()
        
        UNUserNotificationCenter.current().delegate = self
        
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        
        // Create the popover and sets ContentView as the rootView
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 300)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        // Create the status bar item
        self.statusBar = StatusBarController(popover)
        self.popover.contentViewController = NSHostingController(rootView:  Home().environment(\.managedObjectContext, TaskProvider.shared.container.viewContext))
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        return completionHandler([.list, .sound])
    }
}
