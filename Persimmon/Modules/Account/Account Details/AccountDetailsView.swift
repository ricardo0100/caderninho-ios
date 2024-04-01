import SwiftUI

struct AccountDetailsView: View {
    @ObservedObject var viewModel: AccountDetailsViewModel
    
    var body: some View {
        if let account = viewModel.account {
            List {
                Section {
                    if viewModel.transactions.count > 0 {
                        ForEach(viewModel.transactions) { transaction in
                            NavigationLink(destination: {
                                TransactionDetailsView(viewModel: TransactionDetailsViewModel(
                                    transactionId: transaction.id,
                                    transactionInteractor: TransactionInteractorMock(),
                                    accountInteractor: AccountInteractorMock()))
                            }) {
                                TransactionCellView(viewModel: TransactionCellViewModel(
                                    transactionId: transaction.id,
                                    transactionInteractor: TransactionInteractorMock(),
                                    accountInteractor: AccountInteractorMock()))
                            }
                        }
                    } else {
                        Text("No transactions yet!").foregroundColor(.gray)
                    }
                } header: {
                    Text("Total: \(viewModel.balance.toCurrency(with: account.currency))")
                        .font(.subheadline)
                }
            }.toolbar {
                ToolbarItem(placement: .principal) {
                    if let account = viewModel.account {
                        HStack {
                            LettersIconView(text: account.name.firstLetters(), color: Color(hex: account.color)).frame(width: 24)
                            Text(account.name)
                                .font(.headline)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit", action: viewModel.didTapEdit)
                }
            }
            .sheet(isPresented: $viewModel.isShowingEdit) {
                NavigationStack {
                    EditAccountItemView(viewModel: EditAccountViewModel(accountId: account.id))
                }
            }
        }
    }
}

struct AccountDetails_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountDetailsView(viewModel: .init(
                accountId: AccountInteractorMock.exampleAccounts[0].id,
                accountInteractor: AccountInteractorMock(),
            transactionInteractor: TransactionInteractorMock()))
        }
    }
}
