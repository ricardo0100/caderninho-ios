//
//  AccountTests.swift
//  PersimmonTests
//
//  Created by Ricardo Gehrke Filho on 09/05/25.
//

import Foundation
import Testing
import SwiftData
@testable import Persimmon

@MainActor
struct AccountTests {
    var container: ModelContainer
    
    init() throws {
        container = .createTestContainer()
        let context = container.mainContext
        context.insert(Account(id: UUID(), name: "Bank of Maya", color: "#F00FFF", currency: "R$"))
        context.insert(CreditCard(id: UUID(), name: "FeijãoCard", color: "#F0FF1F", currency: "R$", closingCycleDay: 3, dueDay: 10))
        try context.save()
    }
    
    var getAccount: Account {
        try! container.mainContext.fetch(FetchDescriptor<Account>()).first!
    }
    
    func createTransactions(with operations: [(operation: Transaction.EditOperation, value: Double)]) throws {
        operations.forEach {
            container.mainContext.insert(Transaction(
                name: "Test",
                date: Date(),
                value: $0.value,
                editOperation: $0.operation,
                category: nil,
                place: nil))
        }
        try container.mainContext.save()
    }
    
    @Test("Test Account balance")
    func testAccountBalance() async throws {
        try createTransactions(with: [
            (.transferIn(account: getAccount), 100),
            (.transferIn(account: getAccount), 100)
        ])
        #expect(getAccount.balance == 200.0)
    }
    
    @Test("Test Account balance with transfer out")
    func testAccountBalanceWithTransferOut() async throws {
        try createTransactions(with: [
            (.transferIn(account: getAccount), 100),
            (.transferOut(account: getAccount), 100)
        ])
        #expect(getAccount.balance == 0)
    }
}
