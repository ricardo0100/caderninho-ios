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
    
    // MARK: Transactions
    @discardableResult func createTransaction(
        name: String,
        date: Date,
        editOperation: Transaction.EditOperation,
        category: Category?,
        place: Transaction.Place?) throws -> Transaction {
            let transaction = Transaction(
                name: name,
                date: date,
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
        editOperation: Transaction.EditOperation,
        category: Category?,
        place: Transaction.Place?) throws {
            transaction.update(
                name: name,
                date: date,
                editOperation: editOperation,
                category: category,
                place: place)
            try context.save()
            updateWidgetInfo()
        }
    
    func deleteTransaction(transaction: Transaction) {
        let installments = transaction.installments
        transaction.installments = []
        installments.forEach { context.delete($0) }
        context.delete(transaction)
        try! context.save()
    }
    
    // MARK: Accounts
    func getAccount(with id: UUID) -> Account? {
        let predicate = #Predicate<Account> {
            $0.id == id
        }
        return try? context.fetch(FetchDescriptor(predicate: predicate)).first
    }
    
    // MARK: Credit Cards
    func getCard(with id: UUID) -> CreditCard? {
        let predicate = #Predicate<CreditCard> {
            $0.id == id
        }
        return try? context.fetch(FetchDescriptor(predicate: predicate)).first
    }
    
    func deleteCreditCard(_ card: CreditCard) throws {
        Set(card.bills.flatMap { $0.installments }.compactMap { $0.transaction }).forEach { transaction in
            deleteTransaction(transaction: transaction)
        }
        context.delete(card)
        try context.save()
    }
    
    // TODO: Move Widgets logic
    // MARK: Widgets
    
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
                    icon: account.icon,
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
                    icon: card.icon,
                    lastTransaction: transactionData)
            }
            let data = try JSONEncoder().encode(accountWidgetDataList + cardWidgetDataList)
            userDefaults.set(data, forKey: "widgetData")
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetchAccounts() throws -> [Account] {
        return try context.fetch(FetchDescriptor<Account>())
    }
    
    private func fetchCards() throws -> [CreditCard] {
        return try context.fetch(FetchDescriptor<CreditCard>())
    }
}
