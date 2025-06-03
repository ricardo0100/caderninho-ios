import SwiftUI

struct ContainerView: View {
    
    var body: some View {
        TabView {
            TransactionsListView()
                .tabItem {
                    Label("Transactions", systemImage: "book.pages")
                }
            CategoriesListView()
                .tabItem {
                    Label("Categories", systemImage: "chart.pie")
                }
            AccountsAndCardsListView()
                .tabItem {
                    Label("Accounts and Cards", systemImage: "creditcard")
                }
        }
    }
}

#Preview {
    ContainerView()
        .modelContainer(.preview)
}
