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
                .tag(0)
            CategoriesListView()
                .tabItem {
                    Label("Categories", systemImage: "chart.pie")
                }
                .tag(1)
            AccountsAndCardsListView()
                .tabItem {
                    Label("Accounts and Cards", systemImage: "creditcard")
                }
                .tag(2)
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
        .onOpenURL { url in
            open(url)
        }
    }
    
    private func open(_ url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let items = components.queryItems else {
            print("Could not open URL: \(url)")
            return
        }
        
        switch components.host {
        case "open":
            if let id = items.first(where: { $0.name == "id" })?.value {
                presentAccountOrCard(with: id)
            }
        default:
            print("Invalid URL scheme: \(url)")
        }
    }
    
    private func presentAccountOrCard(with id: String) {
        let modelManager = ModelManager(context: modelContext)
        guard let uuid = UUID(uuidString: id) else { return }
        
        navigation.selectedTab = 2
        if !navigation.accountsPath.isEmpty {
            navigation.accountsPath.removeLast()
        }
        if let account = modelManager.getAccount(with: uuid) {
            navigation.accountsPath.append(account)
        } else if let card = modelManager.getCard(with: uuid) {
            navigation.accountsPath.append(card)
        }
    }
}

#Preview {
    ContainerView()
        .modelContainer(.preview)
        .environmentObject(NavigationModel())
}
