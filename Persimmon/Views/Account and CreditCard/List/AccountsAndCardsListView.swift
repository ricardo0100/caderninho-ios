import SwiftUI
import SwiftData

struct AccountsAndCardsListView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\Account.name)])
    var accounts: [Account]
    
    @Query(sort: [SortDescriptor(\CreditCard.name)])
    var cards: [CreditCard]
    
    @EnvironmentObject var navigation: NavigationModel
     
    var body: some View {
        NavigationStack(path: $navigation.accountsPath) {
            List {
                Section {
                    AccountsAndCardsHeaderView()
                }
                
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
            .navigationDestination(for: Account.self) {
                AccountDetailsView()
                    .environmentObject($0)
            }
            .navigationDestination(for: CreditCard.self) {
                CardDetailsView()
                    .environmentObject($0)
            }
            .navigationDestination(for: Transaction.self) {
                TransactionDetailsView()
                    .environmentObject($0)
            }
            .navigationTitle("Accounts and Cards")
            .toolbar {
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
        .environmentObject(NavigationModel())
        .modelContainer(.preview)
}
