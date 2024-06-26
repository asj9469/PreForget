//
//  PreForgetApp.swift
//  PreForget
//
//  Created by Anson Goo on 5/21/23.
//

import SwiftUI

@main
struct PreForgetApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = TaskProvider.shared
    
    var body: some Scene {
        WindowGroup {}
    }
}
