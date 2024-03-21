import SwiftUI

struct AccountsView: View {
    @ObservedObject var viewModel = AccountsViewModelMock()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.accounts, id: \.self) { account in
                        NavigationLink(destination: {
                            AccountDetails(account: account)
                        }, label: {
                            AccountCell(account: account)
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
                    HStack {
                        Image(systemName: "creditcard")
                            .foregroundColor(.brand)
                        Text("Accounts")
                            .foregroundColor(.brand)
                            .font(.title)
                    }
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

struct AccountCell: View {
    let account: AccountModel
    
    var body: some View {
        HStack {
            LettersIconView(
                text: account.name.firstLetters(),
                color: Color(hex: account.color))
            VStack(alignment: .leading) {
                Text(account.name)
                    .font(.headline)
                Text("\(account.currency) \(account.amount.formatted())")
                    .font(.subheadline)
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
