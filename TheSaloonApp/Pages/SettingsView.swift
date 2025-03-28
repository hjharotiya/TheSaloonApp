//
//  SettingsView.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 26/03/25.
//

import SwiftUI

@MainActor
final class settingsViewModel: ObservableObject {
    
    
    func Logout() throws {
        AuthenticationManager.shared.SignOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
        
    }
    
}

struct SettingsView: View {
    @StateObject var vm = settingsViewModel()
    @Binding var showSignInView :Bool
    var body: some View {
        List {
            Button {
                Task {
                    do {
                        try await vm.resetPassword()
                        print("password reset Successfull !!")
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Reset Password !!!")
            }
            
            Button {
                Task {
                    do {
                        try vm.Logout()
                        showSignInView = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
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
