import SwiftUI

struct TransactionCellView: View {
    @ObservedObject var viewModel: TransactionCellViewModel

    var body: some View {
        if let account = viewModel.account, let transaction = viewModel.transaction {
            HStack(spacing: .spacingBig) {
                Image(systemName: transaction.type.iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.brand)
                    .frame(width: 32, height: 32)
                VStack(alignment: .leading, spacing: .spacingSmall) {
                    HStack {
                        Text(transaction.name)
                            .font(.headline)
                        Spacer()
                        Text(transaction.type.text)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("\(account.currency) \(transaction.price.formatted())")
                            .font(.subheadline)
                        Spacer()
                        HStack {
                            Text("\(account.name)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Circle()
                                .foregroundColor(Color(hex: account.color))
                                .frame(width: 12, height: 12)
                        }
                    }
                }
            }
        }
    }
}

struct TransactionCellView_Previews: PreviewProvider {
    static var previews: some View {
        let transaction = TransactionInteractorMock.exampleTransactions.randomElement()!
        TransactionCellView(
            viewModel: TransactionCellViewModel(
                transactionId: transaction.id,
                transactionInteractor: TransactionInteractorMock(),
                accountInteractor: AccountInteractorMock()))
    }
}
