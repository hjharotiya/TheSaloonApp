//
//  TheSaloonAppApp.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 24/03/25.
//

import SwiftUI

@main
struct TheSaloonAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
