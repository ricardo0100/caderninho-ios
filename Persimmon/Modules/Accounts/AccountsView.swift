import SwiftUI

struct AccountsView: View {
    @ObservedObject var viewModel = AccountsViewModelMock()
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.accounts) { account in
                    AccountCell(account: account)
                }
            } header: {
                AccountsHeaderView()
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.grouped)
    }
}

struct AccountCell: View {
    let account: AccountItem
    
    var body: some View {
        HStack {
            LettersIconView(
                text: account.name.firstLetters(),
                color: account.color.color)
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
