//
//  ModelManager.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 21/05/25.
//
import Foundation
import SwiftData
import WidgetKit

//TODO: Use ModelManager to fetch data for views
struct ModelManager {
    let context: ModelContext
    let userDefaults: UserDefaults = .widgetsUserDefaults
    
    @discardableResult func createTransaction(
        name: String,
        date: Date,
        value: Double,
        editOperation: Transaction.EditOperation,
        category: Category?,
        place: Transaction.Place?) throws -> Transaction {
            let transaction = Transaction(
                name: name,
                date: date,
                value: value,
                editOperation: editOperation,
                category: category,
                place: place)
            context.insert(transaction)
            try context.save()
            updateWidgetInfo()
            return transaction
        }
    
    func updateTransaction(
        transaction: Transaction,
        name: String,
        date: Date,
        value: Double,
        editOperation: Transaction.EditOperation,
        category: Category?,
        place: Transaction.Place?) throws {
            transaction.update(
                name: name,
                date: date,
                value: value,
                editOperation: editOperation,
                category: category,
                place: place)
            try context.save()
            updateWidgetInfo()
        }
    
    func fetchAccounts() throws -> [Account] {
        return try context.fetch(FetchDescriptor<Account>())
    }
    
    func updateWidgetInfo() {
        do {
            let accounts = try fetchAccounts()
            let accountWidgetDataList = accounts.map {
                AccountWidgetData(
                    id: $0.id.uuidString,
                    name: $0.name,
                    balance: $0.balance.toCurrency(with: $0.currency),
                    color: $0.color)
            }
            let data = try JSONEncoder().encode(accountWidgetDataList)
            userDefaults.set(data, forKey: "widgetData")
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print(error.localizedDescription)
        }
    }
}
