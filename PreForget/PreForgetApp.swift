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
    let persistanceController = TaskProvider.shared
    
    var body: some Scene {
        WindowGroup {
            EmptyView().frame(width: 0, height: 0)
        }
    }
}
