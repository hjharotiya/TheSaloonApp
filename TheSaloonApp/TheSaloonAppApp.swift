//
//  TheSaloonAppApp.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 24/03/25.
//

import SwiftUI
import Firebase

@main
struct TheSaloonAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            
               
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("configured!!!")
    return true
  }
}
