import SwiftUI

struct ContainerView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        TabView {
            TransactionsListView(viewModel: TransactionsListViewModel())
                .tabItem {
                    Label("Transactions", systemImage: "arrow.up.arrow.down")
                }
            AccountsListView()
                .tabItem {
                    Label("Accounts", systemImage: "creditcard")
                }
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "briefcase")
                }
        }.tint(Color.brand)
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
