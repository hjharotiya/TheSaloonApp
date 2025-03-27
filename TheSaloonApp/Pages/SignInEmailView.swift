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
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password is found !!!")
            return
        }
        Task {
            do {
                let returnUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnUserData)
            }
            catch {
                print("Error \(error.localizedDescription)")
            }
        }
        
    }
    
}


struct SignInEmailView: View {
    
    @StateObject private var vm = SignInEmailViewModel()
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
                vm.signIn()
                
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
        SignInEmailView()
    }
    
}
