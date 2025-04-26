import SwiftUI
import SwiftData
import PhotosUI

struct TransactionsListView: View {
    @Query(sort: [SortDescriptor(\Transaction.date)])
    var transactions: [Transaction]
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            List(transactions) { transaction in
                NavigationLink {
                    TransactionDetailsView().environmentObject(transaction)
                } label: {
                    TransactionCellView().environmentObject(transaction)
                        .onLongPressGesture {
                            viewModel.editingTransaction = transaction
                        }
                }
            }
            .overlay {
                if transactions.isEmpty {
                    VStack {
                        Text("oops! No transactions yet")
                        Button("Add transaction") {
                            viewModel.didTapAdd()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "arrow.up.arrow.down",
                                          title: "Transactions")
                }
                ToolbarItem(placement: .primaryAction) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        PhotosPicker(selection: $viewModel.photosItem) {
                            Image(systemName: "camera")
                                .foregroundColor(.brand)
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: viewModel.didTapAdd) {
                        Image(systemName: "plus")
                            .foregroundColor(.brand)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingEdit) {
            EditTransactionView(viewModel: .init())
        }
        .sheet(item: $viewModel.editingTransaction) {
            EditTransactionView(viewModel: .init(transaction: $0))
        }
        .sheet(item: $viewModel.photosItem) {
            EditTransactionView(viewModel: .init(item: $0))
        }
    }
}

#Preview {
    NavigationStack {
        TransactionsListView()
            .modelContainer(DataController.previewContainer)
    }
}
