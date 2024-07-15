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
                    TransactionDetailsView(transaction: transaction)
                } label: {
                    TransactionCellView(transaction: transaction)
                        .onLongPressGesture {
                            editingTransaction = transaction
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
