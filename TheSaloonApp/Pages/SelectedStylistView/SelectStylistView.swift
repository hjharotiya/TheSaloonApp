//
//  SelectStylistView.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 2025-04-23.
//

import SwiftUI

struct SelectStylistView: View {
    let selectedServices: [Service]
    
    var body: some View {
        List {
            Text("Selected Services:")
                .font(.headline)
            
            ForEach(selectedServices) { service in
                Text("• \(service.name) - \(service.duration) mins")
            }
        }
        .navigationTitle("Select Stylist")
    }
}


#Preview {
    SelectStylistView(selectedServices: [Service(name: "he", description: "de", price: 300, duration: 30)])
}
