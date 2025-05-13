//
//  ShopListView.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 2025-05-09.
//

import SwiftUI
import FirebaseFirestore
import Firebase

class ShopListViewModel : ObservableObject {
    @Published var shops: [Shop] = []
    @Published var selectedShops : Shop = Shop(id: "S123", name: "hj", address: "s", ownerId: "s", createdAt: Date())

    func fetchShops () {
        Firestore.firestore().collection("shops")
            .getDocuments { snapshot , error in
                guard let documents = snapshot?.documents else {return}
                self.shops = documents.compactMap { doc in
                    try? doc.data(as: Shop.self)
                }
            }
    }
    
//    guard let documents = snaps
    
}

struct ShopListView: View {
    
    @StateObject var vm = ShopListViewModel()
    
    var body: some View {
        List (vm.shops) { shop in
            NavigationLink(destination: ServicesView(shop:shop)) {
                HStack {
                    VStack (alignment: .leading){
                        Text(shop.name)
                        Text(shop.address)
                    }
                }
            }
            
        }.onAppear {
            vm.fetchShops()
        }
    }
}

#Preview {
    ShopListView(vm: ShopListViewModel())
}
