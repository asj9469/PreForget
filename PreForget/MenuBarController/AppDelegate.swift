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
    
    static var popover = NSPopover()
    var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        UNUserNotificationCenter.current().delegate = self
        
        if let window = NSApplication.shared.windows.first {
                window.close()
            }
        
        statusBar = StatusBarController(Self.popover)
        
        Self.popover.contentViewController = NSHostingController(rootView:  Home().environment(\.managedObjectContext, TaskProvider.shared.container.viewContext))
        
        Self.popover.behavior = .transient
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        return completionHandler([.list, .sound])
    }
}
