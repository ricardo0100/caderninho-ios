//
//  AccountBalanceProvider.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 31/12/24.
//

import WidgetKit

struct AccountDataEntry: TimelineEntry {
    let date: Date
    let accountData: AccountWidgetData?
}

struct AccountDataProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> AccountDataEntry {
        AccountDataEntry(date: Date(), accountData: nil)
    }
    
    func snapshot(for configuration: SelectAccountConfigIntent, in context: Context) async -> AccountDataEntry {
        let entry = AccountDataEntry(
            date: Date(),
            accountData: nil)
        return entry
    }
    
    func timeline(for configuration: SelectAccountConfigIntent, in context: Context) async -> Timeline<AccountDataEntry> {
        let userDefaults = UserDefaults.widgetsUserDefaults
        guard let data = userDefaults.data(forKey: "widgetData") else {
            return Timeline(entries: [], policy: .atEnd)
        }
        let entries = try? JSONDecoder().decode([AccountWidgetData].self, from: data).map { account in
            AccountDataEntry(date: Date(), accountData: account)
        }.filter { $0.accountData?.id == configuration.account?.id }
        
        let timeline = Timeline(entries: entries ?? [], policy: .atEnd)
        return timeline
    }
}
