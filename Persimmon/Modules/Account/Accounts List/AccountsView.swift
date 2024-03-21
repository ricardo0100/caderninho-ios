import SwiftUI

struct AccountsView: View {
    @ObservedObject var viewModel = AccountsViewModelMock()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
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
                } header: {
                    AccountsHeaderView(addAction: viewModel.didTapAdd)
                        .textCase(nil)
                        .listRowInsets(EdgeInsets(
                            top: .spacingMedium,
                            leading: .zero,
                            bottom: .spacingLarge,
                            trailing: .zero))
                }
            }
            .sheet(isPresented: $viewModel.isShowingEditingView) {
                let viewModel = EditAccountViewModel(accountBinding: $viewModel.editingAccount)
                NavigationStack {
                    EditAccountItemView(viewModel: viewModel)
                }
            }
            .overlay(content: {
                if viewModel.isFetching {
                    ProgressView()
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "creditcard", title: "Accounts")
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

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountsView(viewModel: AccountsViewModelMock())
        }
    }
}
