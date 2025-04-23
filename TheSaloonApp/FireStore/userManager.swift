

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

struct DBUser: Codable {
    let userId : String
    let isAnonymous : Bool?
    let email : String?
    let photoUrl : String?
    let phoneNumber: String?
    let DateCreated: Date?
    var isPremium: Bool?
    
    init(auth: AuthenticationModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.isAnonymous = auth.isAnonymous
        self.phoneNumber = auth.phoneNumber
        self.photoUrl = auth.photUrl
        self.DateCreated = Date()
        self.isPremium = false
    }
    
    init( userId : String,
     isAnonymous : Bool?,
    email : String?,
     photoUrl : String?,
    phoneNumber: String?,
     DateCreated: Date?,
          isPremium: Bool?)
    {
        self.userId = userId
        self.email = email
        self.isAnonymous = isAnonymous
        self.phoneNumber = phoneNumber
        self.photoUrl = photoUrl
        self.DateCreated = Date()
        self.isPremium = isPremium
    }
    
//    func togglePremiumStatus() -> DBUser {
//        let currentValue = isPremium ?? false
//        return DBUser(userId: userId,
//                      isAnonymous: isAnonymous,
//                      email: email,
//                      photoUrl: photoUrl,
//                      phoneNumber: phoneNumber,
//                      DateCreated: DateCreated,
//                      isPremium: !currentValue)
//    }
    
    mutating func togglePremiumStatus() {
        let currentValue = isPremium ?? false
        isPremium = !currentValue
    }
    
    enum CodingKeys: String,CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case phoneNumber = "phone_number"
        case DateCreated = "date_created"
        case isPremium = "is_premium"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.DateCreated = try container.decodeIfPresent(Date.self, forKey: .DateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(self.DateCreated, forKey: .DateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
    }

}

final class userManager {
    
    static let shared = userManager()
    private init () {
    }
    
    private let userCollection = Firestore.firestore().collection("users")
   
    
    private func userDocuments(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
//    private let encoder: Firestore.Encoder = {
//        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
//        return encoder
//    }()
//    
//    private let decoder: Firestore.Decoder = {
//        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        return decoder
//    }()
    
    func createUser(user: DBUser) async throws {
        userDocuments(userId: user.userId).setData(from: user , merge: false)
    }
    
//    func createNewUser(auth: AuthenticationModel) async throws {
//        
//        var userData : [String: Any] = [
//            "user_id": auth.uid,
//            "is_anonymous": auth.isAnonymous,
//            "date_created":Timestamp(),
//        ]
//        if let email = auth.email {
//            userData["email"] = email
//        }
//        if let photUrl = auth.photUrl {
//            userData["photo_url"] = photUrl
//        }
//        
//        if let phoneNumber = auth.phoneNumber {
//            userData["phone_number"] = phoneNumber
//        }
//        
//        try await userDocuments(userId: auth.uid).setData(userData, merge: false)
//    }
    
    func getUser(userId: String) async throws -> DBUser {
       return try await userDocuments(userId: userId).getDocument(as: DBUser.self)
    }
    
//    func getUser(userId: String) async throws -> DBUser {
//        
//        let snapShot = try await userDocuments(userId: userId).getDocument()
//        
//        guard let data = snapShot.data() , let userId = data["user_id"] as? String else {
//            throw URLError(.badServerResponse)
//        }
//    
//        let isAnonymous = data["is_anonymous"] as? Bool
//        let email = data["email"] as? String
//        let photoUrl = data["photo_url"] as? String
//        let phoneNumber = data["phone_number"] as? String
//        let DateCreated = data["date_created"] as? Date
//        
//        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, phoneNumber: phoneNumber, DateCreated: DateCreated)
//        
//    }
    
//    func updateUserPremiumStatus(user: DBUser) async throws {
//        try userDocuments(userId: user.userId).setData(from:user , merge: true)
//    }
    
    func updateUserPremiumStatus(userId: String , isPremium: Bool) async throws {
        let data: [String: Any] = [
            "is_premium" : isPremium
        ]
        try await userDocuments(userId: userId).updateData(data)
    }
    
}
