
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

final class shopsManager {
    
    static let shared = shopsManager()
    private init () {
        
    }
    
    private let shopsCollection = Firestore.firestore().collection("shops")
    
    func createShop (shop: Shop) {
        do {
              try shopsCollection.document(shop.id).setData(from: shop)
              print("Shop data created successfully.")
          } catch {
              print("Error adding shop: \(error.localizedDescription)")
          }
    }
    
    func addService(shopId: String, service: Service) {
        do {
            try shopsCollection.document(shopId)
                .collection("services")
                .document(service.id)
                .setData(from: service)
            print("Service Added successfully")
        
        }catch{
            print("error: \(error.localizedDescription)")
        }
    }
    
    
}
