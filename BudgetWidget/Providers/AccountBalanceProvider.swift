//
//  AccountBalanceProvider.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 31/12/24.
//

import WidgetKit

struct MainAccountBalanceEntry: TimelineEntry {
    let date: Date
    let accountData: AccountData?
}

struct MainAccountBalanceProvider: TimelineProvider {
    func placeholder(in context: Context) -> MainAccountBalanceEntry {
        MainAccountBalanceEntry(date: Date(), accountData: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping @Sendable (MainAccountBalanceEntry) -> Void) {
        let entry = MainAccountBalanceEntry(
            date: Date(),
            accountData: AccountData(name: "Bank", color: .blue, currency: "R$", balance: 1234.56))
        completion(entry)
    }
    
    func getTimeline(in context: Context,
                     completion: @escaping @Sendable (Timeline<MainAccountBalanceEntry>) -> Void) {
        var entries: [MainAccountBalanceEntry] = []
        entries.append(MainAccountBalanceEntry(
            date: Date(),
            accountData: AccountData(name: "Bank", color: .blue, currency: "R$", balance: 1234.56)))

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
