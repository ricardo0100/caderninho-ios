import SwiftUI

struct AccountDetailsView: View {
    @ObservedObject var viewModel: AccountDetailsViewModel
    
    var body: some View {
        if let account = viewModel.account {
            VStack {
                Text(account.name)
                    .foregroundColor(Color(hex: account.color))
                Text(viewModel.balance?.formatted() ?? "")
            }
        } else {
            Text("⚠️")
        }
    }
}

struct AccountDetails_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailsView(viewModel: .init(
            accountId: AccountInteractorMock.exampleAccounts[0].id,
            accountInteractor: AccountInteractorMock(),
            transactionInteractor: TransactionInteractorMock()))
    }
}
