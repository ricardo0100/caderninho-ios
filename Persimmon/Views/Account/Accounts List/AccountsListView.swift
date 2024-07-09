import SwiftUI
import SwiftData

struct AccountsListView: View {
    @Query(sort: [SortDescriptor(\Account.name)])
    var accounts: [Account]
    
    @State var isShowindEdit: Bool = false
    @State var editingAccount: Account?

    var body: some View {
        NavigationStack {
            List {
                ForEach(accounts, id: \.self) { account in
                    NavigationLink(destination: AccountDetailsView(account: account)) {
                        HStack {
                            LettersIconView(
                                text: account.name.firstLetters(),
                                color: Color(hex: account.color),
                                size: 32)
                            VStack(alignment: .leading) {
                                Text(account.name)
                                    .font(.headline)
                                Text(account.balance.toCurrency(with: account.currency))
                                    .font(.subheadline)
                            }
                        }
                        .onLongPressGesture {
                            self.editingAccount = account
                            isShowindEdit = true
                        }
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
