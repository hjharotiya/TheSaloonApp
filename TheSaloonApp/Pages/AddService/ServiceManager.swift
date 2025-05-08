
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreCombineSwift


struct Service: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name : String
    var description: String
    var price: Double
    var duration: Int // mins
}

class AddServiceViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    func addService(service: Service) async throws {
        try db.collection("services").document(service.id).setData(from: service)
    }
}
