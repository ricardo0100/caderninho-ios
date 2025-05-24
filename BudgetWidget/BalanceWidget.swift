import WidgetKit
import SwiftUI
import AppIntents

@main
struct BalanceWidget: Widget {
    var body: some WidgetConfiguration {
            AppIntentConfiguration(
                kind: "com.persimmon.balancewidget",
                intent: SelectAccountConfigIntent.self,
                provider: AccountDataProvider()
            ) { entry in
                if let account = entry.accountData {
                    AccountBalanceView(account: account)
                } else {
                    AccountBalancePlaceholderView()
                }
            }
        }
}

fileprivate struct AccountBalancePlaceholderView: View {
    var body: some View {
        Text("Edit this Widget to select an account or card!")
            .tint(Color.brand)
            .font(.caption2)
            .containerBackground(for: .widget) {}
    }
}

fileprivate struct AccountBalanceView: View {
    let account: AccountOrCardData
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacingZero) {
            HStack(spacing: .spacingSmall) {
                if let icon = account.icon {
                    Image(icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16)
                } else {
                    LettersIconView(text: account.name.firstLetters(),
                                    color: Color(hex: account.color))
                }
                Text(account.name)
                    .font(.caption)
                    .shadow(color: .white.opacity(0.2), radius: 0, x: 0.5, y: 0.5)
            }
            .padding(.top)
            Text(account.balance.toCurrency(with: account.currency))
                .bold()

            if let transaction = account.lastTransaction {
                Spacer()
                Text("Last transaction")
                    .font(.system(size: 9))
                Spacer().frame(height: .spacingNano)
                HStack {
                    VStack(alignment: .leading, spacing: .spacingNano) {
                        HStack(alignment: .center, spacing: .spacingSmall) {
                            Image(systemName: transaction.operationIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 6)
                            Text(transaction.name)
                                .font(.system(size: 10))
                        }
                        
                        HStack(spacing: .spacingSmall) {
                            if let icon = transaction.category?.icon {
                                Image(systemName: icon)
                                    .symbolRenderingMode(.multicolor)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 10, height: 10)
                            }
                            Text(transaction.value)
                                .font(.caption2)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.spacingSmall)
                .background(
                    Color(.systemBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(color: Color(.systemBackground), radius: 0, x: 1, y: 1)
                        .opacity(0.15)
                )
            }
        }
        .containerBackground(for: .widget) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: account.color).opacity(0.6),
                    Color(hex: account.color).opacity(0.8),
                    Color(hex: account.color)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomLeading
            )
        }
    }
}

#Preview(as: .systemSmall) {
    BalanceWidget()
} timeline: {
    AccountOrCardDataEntry(date: Date(), accountData: nil)
    AccountOrCardDataEntry(
        date: Date(),
        accountData: AccountOrCardData(
            id: "",
            name: "Test Bank",
            currency: "R$",
            balance: 12345.67,
            color: "#0089FF",
            icon: "bb",
            lastTransaction:
                TransactionData(
                    name: "Buy in Supermarket",
                    date: Date(),
                    value: "R$ 123,45",
                    category:
                        CategoryData(
                            name: "Food",
                            color: "#0807FF",
                            icon: NiceIcon.dog.rawValue
                        ),
                    operationIcon: "arrow.up"
                )
        )
    )
    AccountOrCardDataEntry(
        date: Date(),
        accountData: AccountOrCardData(
            id: "",
            name: "Test Bank",
            currency: "R$",
            balance: 12345.67,
            color: "#F089FF",
            icon: "bb",
            lastTransaction:
                TransactionData(
                    name: "Buy in Supermarket",
                    date: Date(),
                    value: "R$ 123,45",
                    category:
                        CategoryData(
                            name: "Food",
                            color: "#F807FF",
                            icon: nil
                        ),
                    operationIcon: "arrow.up"
                )
        )
    )
    AccountOrCardDataEntry(
        date: Date(),
        accountData: AccountOrCardData(
            id: "",
            name: "Test Bank",
            currency: "R$",
            balance: 12345.67,
            color: "#00F9FF",
            icon: "bb",
            lastTransaction:
                TransactionData(
                    name: "Buy in Supermarket",
                    date: Date(),
                    value: "R$ 123,45",
                    category: nil,
                    operationIcon: "arrow.up")
        )
    )
    AccountOrCardDataEntry(
        date: Date(),
        accountData: AccountOrCardData(
            id: "",
            name: "Test Bank",
            currency: "R$",
            balance: 12345.67,
            color: "#0089FF",
            icon: "bb",
            lastTransaction: nil)
        )
}
