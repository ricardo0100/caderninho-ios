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
    
    func fetchCards() throws -> [CreditCard] {
        return try context.fetch(FetchDescriptor<CreditCard>())
    }
    
    fileprivate func transactionData(_ transaction: Transaction, currency: String) -> TransactionData {
        var categoryData: CategoryData?
        if let category = transaction.category {
            categoryData = CategoryData(name: category.name, color: category.color, icon: category.icon)
        }
        let value = transaction.value.toCurrency(with: currency)
        return TransactionData(
            name: transaction.name,
            date: transaction.date,
            value: value,
            category: categoryData,
            operationIcon: transaction.operationDetails.icon
        )
    }
    
    func updateWidgetInfo() {
        do {
            let accountWidgetDataList = try fetchAccounts().map { account in
                var transactionData: TransactionData?
                if let transaction = account.lastTransaction {
                    transactionData = self.transactionData(transaction, currency: account.currency)
                }
                
                return AccountOrCardData(
                    id: account.id.uuidString,
                    name: account.name,
                    currency: account.currency,
                    balance: account.balance,
                    color: account.color,
                    lastTransaction: transactionData)
            }
            let cardWidgetDataList = try fetchCards().map { card in
                var transactionData: TransactionData?
                if let transaction = card.lastTransaction {
                    transactionData = self.transactionData(transaction, currency: card.currency)
                }
                return AccountOrCardData(
                    id: card.id.uuidString,
                    name: card.name,
                    currency: card.currency,
                    balance: card.currentBill?.total ?? .zero,
                    color: card.color,
                    lastTransaction: transactionData)
            }
            let data = try JSONEncoder().encode(accountWidgetDataList + cardWidgetDataList)
            userDefaults.set(data, forKey: "widgetData")
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print(error.localizedDescription)
        }
    }
}
