import SwiftUI

struct ContainerView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        TabView {
            TransactionsListView()
                .tabItem {
                    Label("Transactions", systemImage: "arrow.up.arrow.down")
                }
            AccountsListView()
                .tabItem {
                    Label("Accounts", systemImage: "creditcard")
                }
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

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
