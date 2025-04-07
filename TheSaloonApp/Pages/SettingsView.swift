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
    @Published var authUser : AuthenticationModel? = nil
    
    func loadAuthProvider() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func Logout() throws {
        AuthenticationManager.shared.SignOut()
    }
    
    func deleteUser () async throws {
        try await AuthenticationManager.shared.DeleteUser()
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
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
         
    }
    func linkEmailAccount(email:String ,password: String) async throws {
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
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
            
            Button (role: .destructive) {
                Task {
                    do {
                        try await vm.deleteUser()
                        showSignInView = true
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Delete Account")
            }

            
            if vm.authProviders.contains(.email) {
                emailSection()
            }
            
            if  vm.authUser?.isAnonymous == true {
                anonymousSection(showSignInView: $showSignInView)
            }
            
           

            
        }.navigationTitle("Settings")
            .onAppear {
                vm.loadAuthProvider()
                vm.loadAuthUser()
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

struct anonymousSection: View {
    @StateObject var vm = settingsViewModel()
    @State var email: String = ""
    @State var password: String = ""
    @Binding var showSignInView :Bool
    
    var body: some View {
        TextField("Email...", text: $email)
            .padding()
            .background(Color.gray.opacity(0.4))
            .clipShape(RoundedRectangle(cornerSize:CGSize(width: 10, height: 10) ))
        SecureField("Password", text: $password)
            .padding()
            .background(Color.gray.opacity(0.4))
            .clipShape(RoundedRectangle(cornerSize:CGSize(width: 10, height: 10) ))
        
        Button {
            Task {
                do {
                    try await vm.linkEmailAccount(email: email, password: password)
                    print("Email Linked!!!")
                }
                catch {
                    print(error)
                }
            }
        } label: {
            Text("link Email!")
                .font(.headline)
                .foregroundStyle(Color.white)
                .frame(height:55)
                .frame(maxWidth:.infinity)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerSize:CGSize(width: 10, height: 10) ))
        }
        Button {
            Task {
                try await vm.linkGoogleAccount()
                print("google linked!!!")
            }
            
        } label: {
            Text("link Google")
        }

    }
}

#Preview {
    NavigationStack {
        SettingsView( showSignInView: .constant(false))
    }
}
