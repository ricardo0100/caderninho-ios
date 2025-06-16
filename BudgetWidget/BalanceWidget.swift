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
                    AccountBalanceView(accountOrCard: account)
                        .widgetURL(URL(string: "caderninho://open?id=\(account.id)"))
                } else {
                    AccountBalancePlaceholderView()
                }
            }
        }
}

fileprivate struct AccountBalancePlaceholderView: View {
    var body: some View {
        Text("Tap and hold to select an account or card!")
            .tint(Color.brand)
            .font(.caption2)
            .containerBackground(for: .widget) {}
    }
}

fileprivate struct AccountBalanceView: View {
    let accountOrCard: AccountOrCardData
    
    var body: some View {
        let backgroundColor = UIImage(named: accountOrCard.icon ?? "")?
            .predominantColor() ?? Color(.systemBackground)
        
        VStack {
            Spacer()
            HStack {
                if let icon = accountOrCard.icon {
                    Image(icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                }
                Text(accountOrCard.name)
                    .font(.caption)
                Spacer()
            }
            
            HStack {
                Text(accountOrCard.balanceString)
                    .font(.caption2)
                    .bold()
                Spacer()
            }
            
            if let transaction = accountOrCard.lastTransaction {
                HStack {
                    VStack(alignment: .leading, spacing: .zero) {
                        HStack {
                            Text(transaction.name)
                                .font(.caption2)
                            Spacer()
                        }
                        HStack(spacing: .spacingSmall) {
                            Image(systemName: transaction.operationIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.primary)
                                .frame(width: 6)
                            Text(transaction.value)
                                .font(.caption2)
                        }
                    }
                    .padding(.spacingSmall)
                    .background(Color.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Link(destination: URL(string: "caderninho://new?id=\(accountOrCard.id)")!) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundStyle(.primary.opacity(0.7))
                            .frame(width: 16, height: 16)
                    }
                }
            }
            
            Spacer()
        }
        .overlay(alignment: .topTrailing) {
            if accountOrCard.lastTransaction == nil {
                Link(destination: URL(string: "caderninho://new?id=\(accountOrCard.id)")!) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundStyle(.primary.opacity(0.7))
                        .frame(width: 16, height: 16)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .containerBackground(for: .widget) {
            LinearGradient(
                gradient: Gradient(colors: [
                    backgroundColor.opacity(0.4),
                    backgroundColor.opacity(0.5),
                    backgroundColor.opacity(0.4),
                    backgroundColor.opacity(0.7),
                    backgroundColor.opacity(0.6),
                    backgroundColor.opacity(0.8),
                    backgroundColor.opacity(0.9),
                    backgroundColor.opacity(1.0)
                ]),
                startPoint: .top,
                endPoint: .bottomTrailing
            )
        }
    }
}

#Preview(as: .systemSmall) {
    BalanceWidget()
} timeline: {
    AccountOrCardDataEntry(
        date: Date(),
        accountData: AccountOrCardData(
            id: "",
            name: "Banco do Brasil",
            currency: "R$",
            balance: 12345.67,
            color: "#0089FF",
            icon: "bb",
            lastTransaction:
                TransactionData(
                    name: "Dinner",
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
    AccountOrCardDataEntry(date: Date(), accountData: nil)
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
            icon: "itau",
            lastTransaction: nil)
        )
}
