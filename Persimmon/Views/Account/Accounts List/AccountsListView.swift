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
                    Button(action: didTapAdd) {
                        Image(systemName: "plus")
                            .foregroundColor(.brand)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowindEdit) {
            EditAccountView(account: editingAccount)
        }
    }

    func didTapAdd() {
        editingAccount = nil
        isShowindEdit = true
    }
}

#Preview {
    AccountsListView()
        .modelContainer(DataController.previewContainer)
}
