import WidgetKit
import AppIntents
import SwiftUI

@main
struct AccountBalanceWidget: Widget {
    var body: some WidgetConfiguration {
            AppIntentConfiguration(
                kind: "com.persimmon.accountwidget",
                intent: SelectAccountConfigIntent.self,
                provider: AccountDataProvider()
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
        }
}

fileprivate struct AccountBalancePlaceholderView: View {
    var body: some View {
        Text("Edit this Widget to select an account!")
            .tint(Color.brand)
            .font(.caption)
    }
}

fileprivate struct AccountBalanceView: View {
    let account: AccountBalanceData
    
    var body: some View {
        VStack {
            HStack {
                LettersIconView(text: account.name, color: Color(hex: account.color))
                VStack(alignment: .leading) {
                    Text(account.name)
                    Text(account.balance)
                        .font(.footnote)
                        .bold()
                }
            }
            HStack {
//                Button("New", intent: NewTransactionIntent())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview(as: .systemSmall) {
    AccountBalanceWidget()
} timeline: {
    AccountDataEntry(date: Date(), accountData: nil)
    AccountDataEntry(
        date: Date(),
        accountData: AccountBalanceData(
            name: "Test Bank",
            balance: "R$ 1.234,56",
            color: "#0089FF"))
}
