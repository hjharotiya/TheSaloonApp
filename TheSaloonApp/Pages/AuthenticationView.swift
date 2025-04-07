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
        try await AuthenticationManager.shared.signInGoogle(tokens: tokens)
//        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
    }
    
    func signInAnonymous() async throws {
        
        try await AuthenticationManager.shared.signInAnonymous()
    }
    
}


struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    @StateObject private var vm = AuthenticationViewModel()
    var body: some View {
        VStack {
            
            Button {
                Task {
                    do {
                        try await vm.signInAnonymous()
                        showSignInView = false
                    }
                    catch {
                        print(error.localizedDescription)
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
                        showSignInView = false
                    }
                    catch {
                        print(error)
                    }
                }
                
            }

        }.navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
