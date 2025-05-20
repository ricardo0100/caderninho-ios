//
//  AccountBalanceProvider.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 31/12/24.
//

import WidgetKit

struct AccountDataEntry: TimelineEntry {
    let date: Date
    let accountData: AccountBalanceData?
}

struct AccountDataProvider: AppIntentTimelineProvider {
    static let userDefaults = UserDefaults(suiteName: "group.br.com.rrghkf.test.group")
    
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
        var entries: [AccountDataEntry] = []
//        entries.append(AccountDataEntry(
//            date: Date(),
//            accountData: configuration.account))
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        return timeline
    }
}
