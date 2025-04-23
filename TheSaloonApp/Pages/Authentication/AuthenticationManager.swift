

import Foundation
import Firebase
import FirebaseAuth

struct AuthenticationModel {
    let uid: String
    let email: String?
    let photUrl: String?
    let phoneNumber: String?
    let isAnonymous: Bool
    
    init (user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photUrl = user.photoURL?.absoluteString
        self.phoneNumber = user.phoneNumber
        self.isAnonymous = user.isAnonymous
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthenticationModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthenticationModel(user: user)
    }

    func SignOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func DeleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        try await user.delete()
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID)
            {
                providers.append(option)
            }else {
                assertionFailure("Provider option not found : \(provider.providerID)")
            }
            
        }
        return providers
    }
    
}

// MARK: SIGN IN EMAIL

extension AuthenticationManager {
    
    @discardableResult
    func createUser (email: String , password: String)async throws-> AuthenticationModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthenticationModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signIn(email: String , password: String) async throws -> AuthenticationModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthenticationModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
        
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updateEmail(to: email)
    }
}

// MARK: SIGN IN SSO

extension AuthenticationManager {
    
    @discardableResult
    func signInGoogle (tokens: GoogleSignInResultModel) async throws -> AuthenticationModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn (credential: AuthCredential) async throws -> AuthenticationModel {
      let authDataResult = try await Auth.auth().signIn(with: credential )
        return AuthenticationModel(user: authDataResult.user)
    }
}


// MARK: SIGN IN ANONYMOUS

extension AuthenticationManager {
    
    @discardableResult
    func signInAnonymous () async throws -> AuthenticationModel {
        let authDataResult = try await Auth.auth().signInAnonymously()
        return AuthenticationModel(user: authDataResult.user)
    }
    
    func linkEmail(email: String , password: String) async throws -> AuthenticationModel{
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        return try await linkcredential(credential: credential)
    }
    
    func linkGoogle(tokens:GoogleSignInResultModel ) async throws -> AuthenticationModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        
        return try await linkcredential(credential: credential)
        
    }
    
    private func linkcredential (credential: AuthCredential) async throws -> AuthenticationModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        let authdataResult = try await user.link(with: credential)
        return AuthenticationModel(user: authdataResult.user)
    }
    
}
