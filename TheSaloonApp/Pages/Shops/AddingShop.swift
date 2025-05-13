//
//  AddingShop.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 2025-05-09.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct AddingShop: View {
    @State private var name = ""
    @State private var address = ""
    @State private var location = ""
    @State private var contactNumber = ""
    @State private var imageUrl = ""
    @State private var ownerId = "demoOwnerId" // Replace with actual user ID
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Shop Info")) {
                    TextField("Shop Name", text: $name)
                    TextField("Address", text: $address)
                    TextField("Location", text: $location)
                    TextField("Contact Number", text: $contactNumber)
                    TextField("Image URL", text: $imageUrl)
                }

                Button("Add Shop") {
                    addShop()
                }
            }
            .navigationTitle("Add Shop")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Success"), message: Text("Shop added successfully"), dismissButton: .default(Text("OK")))
            }
        }
    }

    func addShop() {
        let newShop = Shop(
                    id: UUID().uuidString,
                    name: name,
                    address: address,
                    location: location.isEmpty ? nil : location,
                    imageUrl: imageUrl.isEmpty ? nil : imageUrl,
                    contactNumber: contactNumber.isEmpty ? nil : contactNumber,
                    ownerId: ownerId,
                    createdAt: Date()
                )
        shopsManager.shared.createShop(shop: newShop)
        showAlert = true
    }
}

#Preview {
    AddingShop()
}
