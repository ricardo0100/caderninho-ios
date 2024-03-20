import SwiftUI

struct AccountsView: View {
    @ObservedObject var viewModel = AccountsViewModelMock()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.accounts, id: \.self) { account in
                        AccountCell(account: account)
                            .onTapGesture {
                                viewModel.didTapAccount(account: account)
                            }
                    }
                } header: {
                    AccountsHeaderView(addAction: viewModel.didTapAdd)
                        .textCase(nil)
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
            .onAppear(perform: viewModel.didAppear)
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
