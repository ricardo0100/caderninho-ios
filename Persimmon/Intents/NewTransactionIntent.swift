//
//  Intents.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 17/05/25.
//

import AppIntents
import SwiftData

struct NewTransactionIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Transaction"
    var subtitle: String = "Creates a new Transaction"
    
    @Parameter(title: "Name", description: "Name of the transaction")
    var name: String
    
    @Parameter(title: "Value", description: "How much?")
    var value: Double
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
//        let transaction = Transaction(
//            name: name,
//            value: value,
//            category: nil,
//            account: <#Account#>,
//            date: Date(),
//            place: nil)
//        ModelContainer.main.mainContext.insert(transaction)
        try ModelContainer.main.mainContext.save()
        return .result(dialog: IntentDialog("Transação criada com sucesso!"))
    }
}
