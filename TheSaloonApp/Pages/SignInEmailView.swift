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
        let authDataResult = try await AuthenticationManager.shared.signIn(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await userManager.shared.createUser(user: user)
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password is found !!!")
            return
        }
        let returnUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
    }   
}


struct SignInEmailView: View {
    
    @StateObject private var vm = SignInEmailViewModel()
    @Binding var showSignInView :Bool
    @StateObject private var alertManager = AlertManager()
    
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
                        alertManager.show(type: .accountCreated)
                        showSignInView = false
                        return
                    }
                    catch {
                        print(error)
                        alertManager.show(type: .error(error.localizedDescription))
                    }
                    
                    do {
                        print("try sign in function")
                        try await vm.signIn()
                        alertManager.show(type: .loginSuccess)
                        showSignInView = false
                    }
                    catch {
                        alertManager.show(type: .error(error.localizedDescription))
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
        .attachAlert(using: alertManager)
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
    
}
