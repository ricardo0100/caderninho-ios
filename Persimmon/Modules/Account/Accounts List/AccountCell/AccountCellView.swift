import SwiftUI

struct AccountCellView: View {
    let viewModel: AccountCellViewModel
    
    var body: some View {
        HStack {
            LettersIconView(
                text: viewModel.name.firstLetters(),
                color: Color(hex: viewModel.color),
                size: 38)
            .frame(width: 32)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.headline)
                Text(viewModel.balance.toCurrency(with: viewModel.currency))
                    .font(.subheadline)
            }
        }
    }
}

struct AccountCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            let account = AccountInteractorMock.exampleAccounts[0]
            AccountCellView(viewModel: AccountCellViewModel(
                accountId: account.id,
                accountInteractor: AccountInteractorMock(),
                transactionInteractor: TransactionInteractorMock()))
        }
    }
}
