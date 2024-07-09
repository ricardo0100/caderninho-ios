//import SwiftUI
//
//struct TransactionsListView: View {
//    @ObservedObject var viewModel = TransactionsListViewModel()
//    
//    func createEditTransactionViewModel() -> EditTransactionViewModel {
//        if let transaction = viewModel.editingTransaction {
//            return EditTransactionViewModel(transactionId: transaction.id)
//        }
//        return EditTransactionViewModel()
//    }
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                Section {
//                    ForEach(viewModel.transactions) { transaction in
//                        NavigationLink {
//                            TransactionDetailsView(viewModel: TransactionDetailsViewModel(transactionId: transaction.id))
//                        } label: {
//                            TransactionCellView(transactionID: transaction.id)
//                            .swipeActions {
//                                Button("Delete") {
//                                    viewModel.didTapDelete(transaction: transaction)
//                                }.tint(.red)
//                                Button("Edit") {
//                                    viewModel.didTapEdit(transaction: transaction)
//                                }.tint(.blue)
//                            }
//                        }
//                    }
//                } header: {
//                    BudgetPanel().padding(.vertical)
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigation) {
//                    NavigationToolbarView(
//                        imageName: "arrow.up.arrow.down",
//                        title: "Transactions")
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button {
//                        viewModel.didTapAdd()
//                    } label: {
//                        HStack {
//                            Image(systemName: "plus")
//                                .foregroundColor(.brand)
//                        }
//                    }
//                }
//            }
//            .sheet(isPresented: $viewModel.isShowingEditingView) {
//                NavigationStack {
//                    EditTransactionView()
//                }
//            }
//            .alert("Delete?", isPresented: $viewModel.isShowingDeleteAlert) {
//                Button(role: .destructive) {
//                    withAnimation {
//                        viewModel.didConfirmDelete()
//                    }
//                } label: {
//                    Text("Delete")
//                }
//            }
//        }
//    }
//}
//
//struct TransactionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            TransactionsListView(viewModel: TransactionsListViewModel())
//        }
//    }
//}
