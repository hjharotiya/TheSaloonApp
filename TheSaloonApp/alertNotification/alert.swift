//
//  alert.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 07/04/25.
//

import Foundation
import SwiftUI
import Swift

enum alertType {
    case loginSuccess
    case logoutSuccess
    case accountCreated
    case error(String)
}

func getAlertContent(for type: alertType?) -> (String, String) {
    switch type {
    case .loginSuccess:
        return ("Success", "Welcome! your're now logged in.")
    case .logoutSuccess:
        return ("Success", "You have been Logout Successfully.")
    case .accountCreated:
        return ("Account Created", "Your account has been created successfully!")
    case .error(let errorMessage):
        return ("Error", errorMessage)
    case .none:
        return ("", "")
    }
}

// MARK: Alert Manager

class AlertManager : ObservableObject {
    @Published var isPresented = false
    @Published var alertType: alertType?
    
    func show(type: alertType) {
        self.alertType = type
        self.isPresented = true
    }
}

// MARK: - VIEW EXTENSION

//extension View {
//    func attachAlert(using manager: AlertManager) -> some View {
//        self.alert(isPresented: $manager.isPresented) {
//            let content = getAlertContent(for: manager.alertType)
//            return Alert(
//                title: Text(content.0),
//                message: Text(content.1),
//                dismissButton: .default(Text("OK"))
//            )
//        }
//    }
//}

extension View {
    func attachAlert(using manager: AlertManager) -> some View {
        let content = getAlertContent(for: manager.alertType)

        return self.alert(
            isPresented: Binding<Bool>(
                get: { manager.isPresented },
                set: { newValue in manager.isPresented = newValue }
            )
        ) {
            Alert(
                title: Text(content.0),
                message: Text(content.1),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
