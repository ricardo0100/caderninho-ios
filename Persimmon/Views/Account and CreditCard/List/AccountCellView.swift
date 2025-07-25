import SwiftUI
import SwiftData

struct AccountCellView: View {
    @EnvironmentObject var account: Account
    
    var body: some View {
        HStack {
            if let icon = account.icon {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32)
            } else {
                LettersIconView(
                    text: account.name.firstLetters(),
                    color: Color(hex: account.color),
                    size: 32)
            }
            VStack(alignment: .leading) {
                Text(account.name)
                    .font(.headline)
                Text(account.balance.toCurrency(with: account.currency))
                    .font(.subheadline)
                    .foregroundStyle(account.balance < .zero ? Color(.systemRed) : .primary)
            }
        }
    }
}

#Preview {
    let accounts = try? ModelContainer.preview.mainContext.fetch(FetchDescriptor<Account>())
    
    List(accounts ?? [], id: \.self) {
        AccountCellView().environmentObject($0)
    }.modelContainer(.preview)
}
