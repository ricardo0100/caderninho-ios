import SwiftUI
import SwiftData

struct AccountDetailsView: View {
    @State var account: Account
    @State var isShowingEdit: Bool = false
    
    var body: some View {
        List {
            Section {
                if account.transactions.count > 0 {
                    ForEach(account.transactions) { transaction in
                        NavigationLink(destination: {
                            TransactionDetailsView(transaction: transaction)
                        }) {
                            TransactionCellView(transaction: transaction)
                        }
                    }
                } else {
                    Text("No transactions yet!").foregroundColor(.gray)
                }
            } header: {
                Text("Total: \(account.balance.toCurrency(with: account.currency))")
                    .font(.subheadline)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    LettersIconView(text: account.name.firstLetters(),
                                    color: Color(hex: account.color))
                    Text(account.name)
                        .font(.headline)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit", action: didTapEdit)
            }
        }
        .sheet(isPresented: $isShowingEdit) {
            NavigationStack {
                EditAccountView(account: account)
            }
        }
    }
    
    func didTapEdit() {
        isShowingEdit = true
    }
}

#Preview {
    NavigationStack {
        AccountDetailsView(account: DataController.createRandomAccount())
    }
}
