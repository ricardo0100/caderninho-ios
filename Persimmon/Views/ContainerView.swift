import SwiftUI

struct ContainerView: View {
    @EnvironmentObject var navigation: NavigationModel
    @Environment(\.modelContext) var modelContext
    
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
        .sheet(item: $navigation.editingTransaction) { transaction in
            EditTransactionView(transaction: transaction)
        }
        .sheet(item: $navigation.editingTransaction) {
            EditTransactionView(transaction: $0)
        }
        .sheet(isPresented: $navigation.newAccount) {
            EditAccountView(account: nil)
        }
        .sheet(item: $navigation.editingAccount) { account in
            EditAccountView(account: account)
        }
        .sheet(isPresented: $navigation.newCard) {
            EditCreditCardView(creditCard: nil, context: modelContext, navigation: navigation)
        }
        .sheet(item: $navigation.editingCard) { card in
            EditCreditCardView(creditCard: card, context: modelContext, navigation: navigation)
        }
        .sheet(isPresented: $navigation.newCategory) {
            EditCategoryView()
        }
        .sheet(item: $navigation.editingCategory) {
            EditCategoryView(category: $0)
        }
    }
}

#Preview {
    ContainerView()
        .modelContainer(.preview)
}
