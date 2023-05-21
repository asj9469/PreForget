//
//  PreForgetApp.swift
//  PreForget
//
//  Created by Anson Goo on 5/21/23.
//

import SwiftUI

@main
struct PreForgetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
