//
//  Shortcuts.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 22/05/25.
//

import AppIntents

struct TransactionsShortcutsProvider: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: NewTransactionIntent(),
            phrases: [
                "Add transaction in \(.applicationName)"
            ],
            shortTitle: "Add Transaction",
            systemImageName: "pencil"
        )
    }
}
