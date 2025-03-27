

import Foundation
import Firebase
import FirebaseAuth

struct AuthenticationModel {
    let uid: String?
    let email: String?
    let photUrl: String?
    let phoneNumber: String?
    
    init (user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photUrl = user.photoURL?.absoluteString
        self.phoneNumber = user.phoneNumber
    }
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
    
    func createUser (email: String , password: String)async throws-> AuthenticationModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthenticationModel(user: authDataResult.user)
        
    }
    
    func SignOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}
