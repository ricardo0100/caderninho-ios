//
//  Intents.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 17/05/25.
//

import AppIntents
import SwiftData
import WidgetKit

struct NewTransactionIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Transaction"
    var subtitle: String = "Creates a new Transaction"
    
    @Parameter(title: "Name", description: "Name of the transaction")
    var name: String?
    
    @Parameter(title: "Value", description: "How much?")
    var value: Double?
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        return .result(dialog: IntentDialog("\(name ?? "-") \((value ?? 0).toCurrency(with: "R$")) create"))
    }
}
