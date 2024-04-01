import SwiftUI

struct TransactionsListView: View {
    @ObservedObject var viewModel: TransactionsListViewModel
    
    func createEditTransactionViewModel() -> EditTransactionViewModel {
        if let transaction = viewModel.editingTransaction {
            return .init(transactionId: transaction.id)
        }
        return .init()
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.transactions) { transaction in
                        NavigationLink(destination: {
                            TransactionDetailsView(
                                viewModel: TransactionDetailsViewModel(
                                    transactionId: transaction.id,
                                    transactionInteractor: TransactionInteractorMock(),
                                    accountInteractor: AccountInteractorMock()))
                        }) {
                            TransactionCellView(viewModel: TransactionCellViewModel(
                                transactionId: transaction.id,
                                transactionInteractor: TransactionInteractorMock(),
                                accountInteractor: AccountInteractorMock()))
                            .swipeActions {
                                Button("Delete") {
                                    viewModel.didTapDelete(transaction: transaction)
                                }.tint(.red)
                                Button("Edit") {
                                    viewModel.didTapEdit(transaction: transaction)
                                }.tint(.blue)
                            }
                        }
                    }
                } header: {
                    BudgetPanel().padding(.vertical)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(
                        imageName: "arrow.up.arrow.down",
                        title: "Transactions")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.didTapAdd()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(.brand)
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingEditingView) {
                NavigationStack {
                    EditTransactionView(viewModel: createEditTransactionViewModel())
                }
            }
            .sheet(isPresented: $viewModel.isShowingActionsPopover, content: {
                List {
                    Section {
                        ForEach(TransactionType.allCases) { type in
                            Button {
                                viewModel.didTapAdd(type: type)
                            } label: {
                                HStack {
                                    Image(systemName: type.iconName)
                                    Text(type.text)
                                }.foregroundColor(.brand)
                            }
                        }
                    } header: {
                        Text("Choose a type")
                    }
                }
                .presentationDetents([.medium])
            })
            .alert("Delete?", isPresented: $viewModel.isShowingDeleteAlert) {
                Button(role: .destructive) {
                    withAnimation {
                        viewModel.didConfirmDelete()
                    }
                } label: {
                    Text("Delete")
                }
            }
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TransactionsListView(viewModel: TransactionsListViewModel())
        }
    }
}
