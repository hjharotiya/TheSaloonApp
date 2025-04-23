//
//  AuthenticationView.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 25/03/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth



@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle () async throws {
        
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await userManager.shared.createUser(user: user)
        
    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
//        try await userManager.shared.createNewUser(auth: authDataResult)
        
        let user = DBUser(auth: authDataResult)
        try await userManager.shared.createUser(user: user)
    }
    
}


struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    @StateObject private var vm = AuthenticationViewModel()
    @StateObject private var alertManager = AlertManager()
    
    var body: some View {
        VStack {
            
            Button {
                Task {
                    do {
                        try await vm.signInAnonymous()
                        alertManager.show(type: .loginSuccess)
                        showSignInView = false
                    }
                    catch {
                        print(error.localizedDescription)
                        alertManager.show(type: .error(error.localizedDescription))
                    }
                }
            } label: {
                Text("Sign in Anonymously")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            
            NavigationLink(destination: SignInEmailView(showSignInView: $showSignInView)) {
                Text("Sign In with Email")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                
                Task {
                    do{
                        try await vm.signInGoogle()
                        alertManager.show(type: .loginSuccess)
                        showSignInView = false
                    }
                    catch {
                        alertManager.show(type: .error(error.localizedDescription))
                        print(error)
                    }
                }
                
            }

        }.navigationTitle("Sign In")
            .attachAlert(using: alertManager)
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
