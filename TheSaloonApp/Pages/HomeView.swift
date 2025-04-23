//
//  HomeView.swift
//  TheSaloonApp
//
//  Created by Harshit Jharotiya on 25/03/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                profileView(showSignInView: $showSignInView)
//                    TabView {
//                        AvailableTimeSlotsView()
//                            .tabItem {
//                                Label("Bookings", systemImage: "calendar")
//                            }
//                        StylistView()
//                            .tabItem {
//                                Label("Stylist", systemImage: "person.2.fill")
//                            }
//                        profileView(showSignInView: $showSignInView)
//                            .tabItem {
//                                Label("profile", systemImage: "person.crop.circle")
//                            }
//                    }
                
            }
            
        }.onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil

        }.fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
     
       
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
