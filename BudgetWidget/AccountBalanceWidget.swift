import WidgetKit
import SwiftUI

@main
struct AccountBalanceWidget: Widget {
    var body: some WidgetConfiguration {
            StaticConfiguration(
                kind: "com.persimmon.widget",
                provider: MainAccountBalanceProvider()
            ) { entry in
                ViewThatFits {
                    if let account = entry.accountData {
                        AccountBalanceView(account: account)
                    } else {
                        AccountBalancePlaceholderView()
                    }
                }
                .containerBackground(for: .widget) {
                    
                }
            }
            .configurationDisplayName("Account Ballance")
            .description("Shows the balance of the selected account")
            .supportedFamilies([.systemSmall])
        }
}

fileprivate struct AccountBalancePlaceholderView: View {
    var body: some View {
        Text("Select an account to show the balance.")
            .tint(Color.brand)
            .font(.caption)
    }
}

fileprivate struct AccountBalanceView: View {
    let account: AccountData
    
    var body: some View {
        VStack {
            HStack {
                LettersIconView(text: account.name, color: account.color)
                VStack(alignment: .leading) {
                    Text(account.name)
                    Text(account.balance.toCurrency(with: account.currency))
                        .font(.footnote)
                        .bold()
                }
            }
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "camera")
                }
                .buttonStyle(.borderedProminent)
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview(as: .systemSmall) {
    AccountBalanceWidget()
} timeline: {
    MainAccountBalanceEntry(date: Date(), accountData: nil)
    MainAccountBalanceEntry(
        date: Date(),
        accountData: AccountData(name: "Bank", color: .blue, currency: "R$", balance: 1234.56))
}
