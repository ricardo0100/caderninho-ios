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
        context.insert(Account(id: UUID(), name: "Bank of Maya", color: "#F00FFF", icon: nil, currency: "R$"))
        context.insert(CreditCard(id: UUID(), name: "FeijãoCard", color: "#F0FF1F", icon: nil, currency: "R$", closingCycleDay: 3, dueDay: 10))
        try context.save()
    }
    
    var getAccount: Account {
        try! container.mainContext.fetch(FetchDescriptor<Account>()).first!
    }
    
    func createTransactions(with operations: [Transaction.EditOperation]) throws {
        operations.forEach {
            container.mainContext.insert(Transaction(
                name: "Test",
                date: Date(),
                editOperation: $0,
                category: nil,
                place: nil))
        }
        try container.mainContext.save()
    }
    
    @Test("Test Account balance")
    func testAccountBalance() async throws {
        try createTransactions(with: [
            (.transferIn(account: getAccount, value: 100)),
            (.transferIn(account: getAccount, value: 100))
        ])
        #expect(getAccount.balance == 200.0)
    }
    
    @Test("Test Account balance with transfer out")
    func testAccountBalanceWithTransferOut() async throws {
        try createTransactions(with: [
            (.transferIn(account: getAccount, value: 100)),
            (.transferOut(account: getAccount, value: 100))
        ])
        #expect(getAccount.balance == 0)
    }
}
