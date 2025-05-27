//
//  ModelManagerTests.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 21/05/25.
//

import Foundation
import Testing
import SwiftData
@testable import Persimmon

struct ModelManagerTests {
    var container: ModelContainer
    var context: ModelContext
    var modelManager: ModelManager
    
    init() throws {
        container = .createTestContainer()
        context = ModelContext(container)
        modelManager = ModelManager(context: context)
        
        context.insert(Account(id: UUID(), name: "Bank of Maya", color: "#F00FFF", icon: nil, currency: "R$"))
        context.insert(CreditCard(id: UUID(), name: "Bank of Maya", color: "#F00FFF", icon: nil, currency: "R$", closingCycleDay: 3, dueDay: 10))
        context.insert(Category(id: UUID(), name: "Food", color: "#F7F8F9", icon: "carrot"))
        try context.save()
    }
    
    var getCards: [CreditCard] {
        try! context.fetch(FetchDescriptor<CreditCard>())
    }
    
    var getAccounts: [Account] {
        try! context.fetch(FetchDescriptor<Account>())
    }
    
    var getTransactions: [Transaction] {
        try! context.fetch(FetchDescriptor<Transaction>())
    }
    
    @Test
    func testDidCreateTransaction() throws {
        try modelManager.createTransaction(
            name: "Test",
            date: Date(),
            editOperation: .transferOut(account: getAccounts[0], value: 123),
            category: nil,
            place: nil)
        #expect(getTransactions.count == 1)
        #expect(getTransactions[0].name == "Test")
    }
    
    @Test
    func testDidUpdateTransaction() throws {
        let transaction = try modelManager.createTransaction(
            name: "Test",
            date: Date(),
            editOperation: .transferOut(account: getAccounts[0], value: 123),
            category: nil,
            place: nil)
        transaction.update(
            name: "Test Up",
            date: Date(),
            editOperation: .transferOut(account: getAccounts[0], value: 123),
            category: nil,
            place: nil)
        #expect(getTransactions.count == 1)
        #expect(getTransactions[0].name == "Test Up")
    }
    
    @Test
    func setAccountToNilWhenUpdatedToInstallments() async throws {
        let transaction = try modelManager.createTransaction(
            name: "Test",
            date: Date(),
            editOperation: .transferOut(account: getAccounts[0], value: 123),
            category: nil,
            place: nil)
        #expect(getTransactions[0].account != nil)
        transaction.update(
            name: "Test Up",
            date: Date(),
            editOperation: .installments(card: getCards[0], numberOfInstallments: 3, value: 123),
            category: nil,
            place: nil)
        #expect(getTransactions[0].account == nil)
        #expect(getTransactions.count == 1)
        #expect(getTransactions[0].name == "Test Up")
    }
}
