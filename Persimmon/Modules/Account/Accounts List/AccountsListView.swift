import SwiftUI

struct AccountsListView: View {
    @ObservedObject var viewModel = AccountsListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.accounts, id: \.self) { account in
                    NavigationLink(destination: {
                        AccountDetailsView(viewModel: AccountDetailsViewModel(
                            accountId: account.id,
                            accountInteractor: AccountInteractorMock(),
                            transactionInteractor: TransactionInteractorMock()))
                    }, label: {
                        AccountCellView(viewModel: AccountCellViewModel(
                            accountId: account.id,
                            accountInteractor: AccountInteractorMock(),
                            transactionInteractor: TransactionInteractorMock()))
                            .onLongPressGesture {
                                viewModel.didLongPress(account: account)
                            }
                            .swipeActions {
                                Button("Delete") {
                                    viewModel.didTapDelete(account: account)
                                }.tint(.red)
                                Button("Edit") {
                                    viewModel.didTapEdit(account: account)
                                }.tint(.blue)
                            }
                    })
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "creditcard", title: "Accounts")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: viewModel.didTapAdd) {
                        Image(systemName: "plus")
                            .foregroundColor(.brand)
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingEditingView) {
                let viewModel = EditAccountViewModel(accountId: viewModel.editingAccount?.id)
                NavigationStack {
                    EditAccountItemView(viewModel: viewModel)
                }
            }
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

struct AccountsListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsListView(viewModel: AccountsListViewModel())
    }
}
