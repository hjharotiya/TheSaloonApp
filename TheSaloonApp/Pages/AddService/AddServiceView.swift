

import SwiftUI
struct AddServiceView: View {
    
    @StateObject private var vm = ServiceViewModel()
    
    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    @State private var duration = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private func addService () async {
        guard !name.isEmpty , !description.isEmpty ,let priceValue = Double(price), let durationValue = Int(duration) else {
            alertMessage = "Please fill all fields correctly."
            showAlert = true
            return
        }
        
        let newService = Service(name: name, description: description, price: priceValue, duration: durationValue)
        
        do {
            try await vm.addService(service: newService)
            alertMessage = "Service added successfully!"
            showAlert = true
            clearfields()
            
        } catch {
            alertMessage = "Failed to add service: .\(error.localizedDescription)"
            showAlert = true
        }
        
    }
    
    private func clearfields () {
        name = ""
        description = ""
        price = ""
        duration = ""
    }
    
    var body: some View {
        Form {
            TextField("Service Name", text: $name)
            TextField ("Decription", text:  $description)
            TextField("Price", text: $price).keyboardType(.numberPad)
            TextField("Duration", text: $duration).keyboardType(.numberPad)
            
            Button {
                Task {
                     await addService()
                }
            } label: {
                Text("Add Service")
            }

        }.navigationTitle("Add New Service")
            .alert("Message", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
                
            }message: {
                Text(alertMessage)
            }
    }
}



#Preview {
    NavigationStack {
        AddServiceView()
    }
}
