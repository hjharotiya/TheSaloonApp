import Foundation
import FirebaseFirestore
import Firebase

class ServicesViewModel: ObservableObject {
    @Published var services: [Service] = []
    @Published var selectedServices : [Service] = []
    
    
    func fetchServices() {
        Firestore.firestore().collection("services").getDocuments { snapshot , error in
            guard let documents = snapshot?.documents else {return}
            self.services = documents.compactMap { doc in
                try? doc.data(as: Service.self)
            }
        }
    }
    
    func toggleService (_ service: Service) {
        if let index = selectedServices.firstIndex(where: {$0.id == service.id}) {
            selectedServices.remove(at: index)
        } else {
            selectedServices.append(service)
        }
    }
    
}

