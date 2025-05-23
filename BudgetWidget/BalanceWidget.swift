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
        let color = Color(hex: account.color)
        VStack(alignment: .leading, spacing: .spacingNano) {
            HStack(spacing: .spacingSmall) {
                LettersIconView(text: account.name, color: color, size: 16)
                    .shadow(color: .white.opacity(0.5), radius: 0, x: 0.5, y: 0.5)
                Text(account.name)
                    .font(.subheadline)
                    .shadow(color: .white.opacity(0.5), radius: 0, x: 0.5, y: 0.5)
            }
            Text(account.balance.toCurrency(with: account.currency))
                .bold()

            if let transaction = account.lastTransaction {
                Spacer().frame(height: .spacingSmall)
                HStack {
                    VStack(alignment: .leading, spacing: .spacingNano) {
                        HStack(spacing: .spacingSmall) {
                            Image(systemName: transaction.operationIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 8)
                            Text("Last transaction")
                                .font(.caption2)
                                .padding(.bottom, .spacingNano)
                        }
                        Text(transaction.name)
                            .font(.system(size: 10))
                        HStack(spacing: .spacingSmall) {
                            if let icon = transaction.category?.icon {
                                Image(systemName: icon)
                                    .resizable()
                                    .frame(width: 10, height: 10)
                            }
                            Text(transaction.value)
                                .font(.caption2)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, .spacingSmall)
                .padding(.vertical, .spacingSmall)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .background(
                    Color(.systemBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(color: Color(.systemBackground), radius: 5, x: 4, y: 4)
                        .opacity(0.25)
                )
                
                
            }
        }
        .containerBackground(for: .widget) {
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBackground),
                                            Color(hex: account.color).opacity(0.75)]),
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
            lastTransaction: nil)
        )
}
