//
//  SignInEmailView.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 25/03/25.
//

import SwiftUI

class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password is found !!!")
            return
        }
                let returnUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
               
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password is found !!!")
            return
        }
        let returnUserData = try await AuthenticationManager.shared.signIn(email: email, password: password)
                print("Success")
               
    }

    
    
}


struct SignInEmailView: View {
    
    @StateObject private var vm = SignInEmailViewModel()
    @Binding var showSignInView :Bool
    var body: some View {
        VStack {
            TextField("Email...", text: $vm.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerSize:CGSize(width: 10, height: 10) ))
            SecureField("Password", text: $vm.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerSize:CGSize(width: 10, height: 10) ))
            
            Button {
                Task {
                    do {
                        try await vm.signUp()
                        showSignInView = false
                        return
                    }
                    catch {
                        print(error)
                    }
                    
                    do {
                        try await vm.signIn()
                        showSignInView = false
                    }
                    catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign in")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height:55)
                    .frame(maxWidth:.infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerSize:CGSize(width: 10, height: 10) ))
            }
            Spacer()

        }.navigationTitle("Sign With Email")
        .padding()
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
    
}
