import WidgetKit
import SwiftUI
import AppIntents
import UIKit

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
                        .widgetURL(URL(string: "caderninho://open?id=\(account.id)"))
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
        let backgroundColor = UIImage(named: account.icon ?? "")?
            .predominantColor() ?? Color(.systemBackground)
        let foregroundColor = backgroundColor.bestContrastingColor()
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
                    .foregroundStyle(foregroundColor)
            }
            .padding(.top)
            Text(account.balance.toCurrency(with: account.currency))
                .foregroundStyle(foregroundColor)
                .bold()

            if let transaction = account.lastTransaction {
                Spacer().frame(height: .spacingMedium)
//                Text("Last transaction")
//                    .foregroundStyle(foregroundColor)
//                    .font(.system(size: 9))
//                Spacer().frame(height: .spacingNano)
                VStack(alignment: .leading, spacing: .spacingNano) {
                    HStack(alignment: .center, spacing: .spacingSmall) {
                        Image(systemName: transaction.operationIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 6)
                            .foregroundStyle(foregroundColor)
                        Text(transaction.name)
                            .font(.system(size: 10))
                            .foregroundStyle(foregroundColor)
                    }
                    
                    HStack(spacing: .spacingSmall) {
                        if let category = transaction.category {
                            Image(systemName: category.icon ?? "")
                                .symbolRenderingMode(.monochrome)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color(hex: category.color))
                                .frame(width: 10, height: 10)
                        }
                        Text(transaction.value)
                            .font(.caption2)
                            .foregroundStyle(foregroundColor)
                    }
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
                    backgroundColor.opacity(0.65),
                    backgroundColor
                ]),
                startPoint: .top,
                endPoint: .bottom
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
            icon: "itau",
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
            icon: "luiza",
            lastTransaction:
                TransactionData(
                    name: "Buy in Supermarket",
                    date: Date(),
                    value: "R$ 123,45",
                    category:
                        CategoryData(
                            name: "Food",
                            color: "#7807FF",
                            icon: NiceIcon.brain.rawValue
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
            icon: "nubank",
            lastTransaction: nil)
        )
}
