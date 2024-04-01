import SwiftUI

struct TransactionDetailsView: View {
    @ObservedObject var viewModel:TransactionDetailsViewModel
    
    var body: some View {
        if let transaction = viewModel.transaction, let account = viewModel.account {
            List {
                HStack {
                    Text("Name:").font(.subheadline).bold()
                    Spacer()
                    Text(transaction.name)
                }
                HStack {
                    Text("Type:").font(.subheadline).bold()
                    Spacer()
                    HStack {
                        Image(systemName: transaction.type.iconName)
                            .frame(width: 22, height: 22)
                        Text(transaction.type.text)
                    }
                }
                HStack {
                    Text("Account:").font(.subheadline).bold()
                    Spacer()
                    HStack {
                        Circle()
                            .foregroundColor(Color(hex: account.color))
                            .frame(width: 22)
                        Text(account.name)
                    }
                }
                HStack {
                    Text("Value:").font(.subheadline).bold()
                    Spacer()
                    Text(transaction.price.toCurrency(with: account.currency))
                }
                HStack {
                    Text("Date and time:").font(.subheadline).bold()
                    Spacer()
                    Text("Today at 18:22")
                }
                HStack {
                    Text("Location:").font(.subheadline).bold()
                    Spacer()
                    Text("Florianópolis, Morro das Pedras")
                }
            }
            .navigationTitle("Transaction Details")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit", action: viewModel.didTapEdit)
                }
            }
            .sheet(isPresented: $viewModel.isShowingEdit) {
                NavigationStack {
                    EditTransactionView(viewModel: EditTransactionViewModel(transactionId: transaction.id))
                }
            }
        }
    }
}

struct TransactionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let transactionId = TransactionInteractorMock.exampleTransactions.randomElement()!.id
        NavigationStack {
            TransactionDetailsView(viewModel: TransactionDetailsViewModel(
                transactionId: transactionId,
                transactionInteractor: TransactionInteractorMock(),
            accountInteractor: AccountInteractorMock()))
        }
    }
}
