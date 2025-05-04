import SwiftUI
import SwiftData

struct AccountsListView: View {
    @Query(sort: [SortDescriptor(\Account.name)]) var accounts: [Account]
    
    @State var isShowindEdit: Bool = false
    @State var editingAccount: Account?

    var body: some View {
        NavigationStack {
            List(accounts) { account in
                NavigationLink(destination: AccountDetailsView().environmentObject(account)) {
                    AccountCellView()
                        .environmentObject(account)
                        .onLongPressGesture {
                            self.editingAccount = account
                            isShowindEdit = true
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "creditcard", title: "Accounts")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Menu("Add") {
                        Button(action: didTapAddAccount) {
                            Label("Add Account", systemImage: "dollarsign.bank.building")
                        }
                        Button(action: didTapAddCreditCard) {
                            Label("Add Credit Card", systemImage: "creditcard")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isShowindEdit) {
            EditAccountView(account: editingAccount)
        }
    }

    func didTapAddAccount() {
        editingAccount = nil
        isShowindEdit = true
    }
    
    func didTapAddCreditCard() {
        
    }
}

#Preview {
    AccountsListView()
        .modelContainer(DataController.previewContainer)
}
