import SwiftUI

struct ContainerView: View {
    @State private var selectedIndex = 1
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            TransactionsListView()
                .tabItem {
                    Label("Transactions", systemImage: "arrow.up.arrow.down")
                }
            AccountsListView()
                .tabItem {
                    Label("Accounts", systemImage: "creditcard")
                }
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }.tag(1)
            CategoriesListView()
                .tabItem {
                    Label("Categories", systemImage: "briefcase")
                }
            ConfigurationsView()
                .tabItem {
                    Label("Configuration", systemImage: "gear")
                }
        }.tint(Color.brand)
    }
}

#Preview {
    ContainerView()
        .modelContainer(DataController.previewContainer)
}
