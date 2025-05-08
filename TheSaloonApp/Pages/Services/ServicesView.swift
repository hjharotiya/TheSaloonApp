
import SwiftUI

struct ServicesView: View {
    @StateObject private var vm = ServicesViewModel()
    @State private var navigate = false
    var body: some View {
        NavigationStack {
            VStack {
                List (vm.services) { service in
                    HStack {
                        VStack (alignment: .leading) {
                            Text(service.name).font(.headline)
                            Text("Rs. \(service.price) - \(service.duration) mins").font(.subheadline)
                            Text(service.description).font(.caption)
                        }
                        Spacer()
                        Button {
                            vm.toggleService(service)
                        }
                        label: {
                            Image(systemName: vm.selectedServices.contains(where: {$0.id == service.id }) ? "checkmark.circle.fill" : "plus.circle")
                        }

                    }
                    
                }
                NavigationLink(destination: SelectStylistView(selectedServices: vm.selectedServices), isActive: $navigate) {
                                    EmptyView()
                                }
                                
                                Button("Next: Choose Stylist") {
                                    navigate = true
                                }
                                .disabled(vm.selectedServices.isEmpty)
                                .padding()
                            
            }.navigationTitle("Choose Services")
                .onAppear {
                    vm.fetchServices()
                }
        }
    }
}

#Preview {
    ServicesView()
}
