import SwiftUI
import SwiftData

struct AccountDetailsView: View {
    @EnvironmentObject var account: Account
    @State var isShowingEdit: Bool = false
    
    var body: some View {
        List {
            Section {
                if account.transactions.count > 0 {
                    ForEach(account.transactions) { transaction in
                        NavigationLink(destination: {
                            TransactionDetailsView().environmentObject(transaction)
                        }) {
                            TransactionCellView().environmentObject(transaction)
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
                    if let icon = account.icon {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                    } else {
                        LettersIconView(text: account.name.firstLetters(),
                                        color: Color(hex: account.color))
                    }
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
    let account = try! ModelContainer.preview.mainContext
        .fetch(FetchDescriptor<Account>())[0]
    
    NavigationStack {
        AccountDetailsView()
            .environmentObject(account)
    }
}
