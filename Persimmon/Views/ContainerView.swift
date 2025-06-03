import SwiftUI

struct ContainerView: View {
    
    var body: some View {
        TabView {
            TransactionsListView()
                .tabItem {
                    Label("Transactions", systemImage: "book.pages")
                }
            AccountsAndCardsListView()
                .tabItem {
                    Label("Accounts and Cards", systemImage: "creditcard")
                }
            CategoriesListView()
                .tabItem {
                    Label("Categories", systemImage: "briefcase")
                }
        }
    }
}

#Preview {
    ContainerView()
        .modelContainer(.preview)
}
