import SwiftUI

struct ContainerView: View {
    @EnvironmentObject var navigation: NavigationModel
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        TabView(selection: $navigation.selectedTab) {
            TransactionsListView()
                .tabItem {
                    Label("Transactions", systemImage: "book.pages")
                }
                .tag(NavigationModel.Tabs.transactions)
            CategoriesListView()
                .tabItem {
                    Label("Categories", systemImage: "chart.pie")
                }
                .tag(NavigationModel.Tabs.categories)
            AccountsAndCardsListView()
                .tabItem {
                    Label("Accounts and Cards", systemImage: "creditcard")
                }
                .tag(NavigationModel.Tabs.accountsAndCards)
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
        .fullScreenCover(isPresented: $navigation.newTransaction) {
            NewTransactionView()
        }
        .fullScreenCover(item: $navigation.newTransactionWithCard) { card in
            NewTransactionView(with: card)
        }
        .fullScreenCover(item: $navigation.newTransactionWithAccount) { account in
            NewTransactionView(with: account)
        }
    }
}

#Preview {
    ContainerView()
        .modelContainer(.preview)
        .environmentObject(NavigationModel())
}
