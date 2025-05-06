import SwiftUI
import SwiftData

struct AccountsAndCardsListView: View {
    @Query(sort: [SortDescriptor(\Account.name)])
    var accounts: [Account]
    
    @Query(sort: [SortDescriptor(\CreditCard.name)])
    var cards: [CreditCard]
    
    @State var isShowindEditAccount: Bool = false
    @State var isShowindEditCreditCard: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Accounts") {
                    ForEach(accounts) { account in
                        NavigationLink(destination: AccountDetailsView().environmentObject(account)) {
                            AccountCellView().environmentObject(account)
                        }
                    }
                }
                Section("Credit Cards") {
                    ForEach(cards) { card in
                        NavigationLink(destination: CardDetailsView().environmentObject(card)) {
                            CreditCardCellView().environmentObject(card)
                        }
                    }
                }
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
            .sheet(isPresented: $isShowindEditAccount) {
                EditAccountView(account: nil)
            }
            .sheet(isPresented: $isShowindEditCreditCard) {
                EditCreditCardView(creditCard: nil)
            }
        }
    }

    func didTapAddAccount() {
        isShowindEditAccount = true
    }
    
    func didTapAddCreditCard() {
        isShowindEditCreditCard = true
    }
}

#Preview {
    AccountsAndCardsListView()
        .modelContainer(DataController.previewContainer)
}
