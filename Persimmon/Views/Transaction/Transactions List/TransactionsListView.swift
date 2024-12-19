import SwiftUI
import SwiftData

struct TransactionsListView: View {
    @Query(sort: [SortDescriptor(\Transaction.date)])
    var transactions: [Transaction]
    
    @State var isShowindEdit: Bool = false
    @State var editingTransaction: Transaction?
    
    var body: some View {
        NavigationStack {
            List(transactions) { transaction in
                NavigationLink {
                    TransactionDetailsView().environmentObject(transaction)
                } label: {
                    TransactionCellView().environmentObject(transaction)
                        .onLongPressGesture {
                            editingTransaction = transaction
                        }
                }
            }
            .overlay {
                if transactions.isEmpty {
                    VStack {
                        Text("oops! No transactions yet")
                        Button("Add transaction") {
                            didTapAdd()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "arrow.up.arrow.down",
                                          title: "Transactions")
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
            EditTransactionView(transaction: editingTransaction)
        }
        .sheet(item: $editingTransaction) {
            EditTransactionView(transaction: $0)
        }
    }
    
    func didTapAdd() {
        editingTransaction = nil
        isShowindEdit = true
    }
}

#Preview {
    NavigationStack {
        TransactionsListView()
            .modelContainer(DataController.previewContainer)
    }
}
