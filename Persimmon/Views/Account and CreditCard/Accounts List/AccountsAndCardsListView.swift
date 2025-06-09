import SwiftUI
import SwiftData

struct AccountsAndCardsListView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\Account.name)])
    var accounts: [Account]
    
    @Query(sort: [SortDescriptor(\CreditCard.name)])
    var cards: [CreditCard]
    
    @StateObject var navigation = AccountsAndCardsNavigation()
     
    var body: some View {
        NavigationStack(path: $navigation.path) {
            List {
                Section("Accounts") {
                    ForEach(accounts) { account in
                        NavigationLink(value: account) {
                            AccountCellView()
                                .environmentObject(account)
                        }
                    }
                }
                Section("Credit Cards") {
                    ForEach(cards) { card in
                        NavigationLink(value: card) {
                            CreditCardCellView()
                                .environmentObject(card)
                        }
                    }
                }
            }
            .sheet(isPresented: $navigation.newAccount) {
                EditAccountView(account: nil)
                    .environmentObject(navigation)
            }
            .sheet(isPresented: $navigation.newCard) {
                EditCreditCardView(creditCard: nil, context: modelContext)
                    .environmentObject(navigation)
            }
            .navigationDestination(for: Account.self) {
                AccountDetailsView()
                    .environmentObject($0)
                    .environmentObject(navigation)
            }
            .navigationDestination(for: CreditCard.self) {
                CardDetailsView()
                    .environmentObject($0)
                    .environmentObject(navigation)
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "creditcard", title: "Accounts and Cards")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        Button(action: didTapAddAccount) {
                            Label("Add Account", systemImage: "dollarsign.bank.building")
                        }
                        Button(action: didTapAddCreditCard) {
                            Label("Add Credit Card", systemImage: "creditcard")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    func didTapAddAccount() {
        navigation.newAccount = true
    }
    
    func didTapAddCreditCard() {
        navigation.newCard = true
    }
}

#Preview {
    AccountsAndCardsListView()
        .modelContainer(.preview)
}
