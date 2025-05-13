import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUSer() async throws {
        print("using load current user")
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await userManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func togglePremiumStatus() async throws {
        guard let user = user else {return }
        let currentValue = user.isPremium ?? false
        Task {
            try await userManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
            self.user = try await userManager.shared.getUser(userId: user.userId)
        }
    }
}

struct profileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        NavigationStack {
            List {
                if let user = viewModel.user {
                    Text("UserId: \(user.userId)")
                    
                    if let isAnonymous = user.isAnonymous {
                        Text("is Anonymous: \(isAnonymous.description.capitalized)")
                    }
                    
                    Button {
                        Task {
                            try await viewModel.togglePremiumStatus()
                        }
                        
                    } label: {
                        Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                    }
                }
                    NavigationLink {
                        AddServiceView()
                                     }label:{
                       Text("Add New Service")
                }
                
                NavigationLink {
                    ShopListView()
                                 }label:{
                   Text("View Shops")
            }
                NavigationLink {
                    AddingShop()
                                 }label:{
                   Text("View Service")
            }
            }
        }.onAppear {
            Task{
                    try? await viewModel.loadCurrentUSer()
                }
        }
        .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView(showSignInView: $showSignInView)  
                                     }label:{
                        Image(systemName: "gear")
                            .font(.headline)
                }
            }
        }
    }
}

#Preview {
    
        profileView(showSignInView: .constant(false))
    
}
