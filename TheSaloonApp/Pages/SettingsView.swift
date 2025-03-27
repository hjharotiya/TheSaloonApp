//
//  SettingsView.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 26/03/25.
//

import SwiftUI

@MainActor
final class settingsViewModel: ObservableObject {
    
    
    func Logout() {
        AuthenticationManager.shared.SignOut()
    }
    
}

struct SettingsView: View {
    @StateObject var vm = settingsViewModel()
    @Binding var showSignInView :Bool
    var body: some View {
        List {
            Button {
                vm.Logout()
                showSignInView = true
            } label: {
                Text("Log out")
            }
        }.navigationTitle("Settings")

    }
}

#Preview {
    NavigationStack {
        SettingsView( showSignInView: .constant(false))
    }
}
