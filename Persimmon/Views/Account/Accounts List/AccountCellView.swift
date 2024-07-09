import SwiftUI
import SwiftData

struct AccountCellView: View {
    @Binding var account: Account
    
    init(account: Binding<Account>) {
        _account = account
    }
    
    var body: some View {
        HStack {
            LettersIconView(
                text: account.name.firstLetters(),
                color: Color(hex: account.color),
                size: 32)
            VStack(alignment: .leading) {
                Text(account.name)
                    .font(.headline)
                Text(account.balance.toCurrency(with: account.currency))
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    List {
        AccountCellView(account: .constant(DataController.createRandomAccount()))
        AccountCellView(account: .constant(DataController.createRandomAccount()))
        AccountCellView(account: .constant(DataController.createRandomAccount()))
    }
}
