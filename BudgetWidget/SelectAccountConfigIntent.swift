//
//  SelectAccountConfigIntent.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 20/05/25.
//

import AppIntents

struct SelectAccountConfigIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Account"
    static var description = IntentDescription("Selects an account to show in the widget!")
    
    @Parameter(title: "Account")
    var account: SelectAccountEntity?
    
    init(account: SelectAccountEntity) {
        self.account = account
    }
    
    init() {
    }
}
