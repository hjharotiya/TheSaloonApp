//
//  SettingsView.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 26/03/25.
//

import SwiftUI

@MainActor
final class settingsViewModel: ObservableObject {
    
    @Published var authProviders : [AuthProviderOption] = []
    
    func loadAuthProvider() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
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
    
    func updatePassword (password: String) async throws {
        try await AuthenticationManager.shared.updatePassword(password: password)
        print("Success!!!")
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
                        try vm.Logout()
                        showSignInView = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Log out")
            }
            if vm.authProviders.contains(.email) {
                emailSection()
            }
            
            
           

            
        }.navigationTitle("Settings")
            .onAppear {
                vm.loadAuthProvider()
            }

    }
}

struct emailSection: View {
    @StateObject var vm = settingsViewModel()
    @State var password: String = ""
    var body: some View {
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
        TextField("Update Password", text:$password )
        Button {
            Task {
               try await vm.updatePassword(password: password)
                password = ""
            }
            
        } label: {
            Text("Update password")
        }

    }
}

#Preview {
    NavigationStack {
        SettingsView( showSignInView: .constant(false))
    }
}
