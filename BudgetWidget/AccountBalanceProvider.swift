//
//  AccountBalanceProvider.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 31/12/24.
//

import WidgetKit

struct AccountOrCardDataEntry: TimelineEntry {
    let date: Date
    let accountData: AccountOrCardData?
}

struct AccountDataProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> AccountOrCardDataEntry {
        AccountOrCardDataEntry(date: Date(), accountData: nil)
    }
    
    func snapshot(for configuration: SelectAccountConfigIntent, in context: Context) async -> AccountOrCardDataEntry {
        let entry = AccountOrCardDataEntry(
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
        return entry
    }
    
    func timeline(for configuration: SelectAccountConfigIntent, in context: Context) async -> Timeline<AccountOrCardDataEntry> {
        let userDefaults = UserDefaults.widgetsUserDefaults
        guard let data = userDefaults.data(forKey: "widgetData") else {
            return Timeline(entries: [], policy: .atEnd)
        }
        let entries = try? JSONDecoder().decode([AccountOrCardData].self, from: data).map { account in
            AccountOrCardDataEntry(date: Date(), accountData: account)
        }.filter { $0.accountData?.id == configuration.account?.id }
        
        let timeline = Timeline(entries: entries ?? [AccountOrCardDataEntry(
            date: Date(),
            accountData: nil)], policy: .atEnd)
        return timeline
    }
}
