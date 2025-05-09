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
    typealias TestTrasactionInfo = (type: Transaction.TransactionType, value: Double)
    
    var container: ModelContainer
    
    init() throws {
        container = .createTestContainer()
        let context = container.mainContext
        context.insert(Account(id: UUID(), name: "Bank of Maya", color: "#F00FFF", currency: "R$"))
        try context.save()
    }
    
    var getAccount: Account {
        try! container.mainContext.fetch(FetchDescriptor<Account>()).first!
    }
    
    func createTransaction(with infos: [TestTrasactionInfo]) throws {
        infos.forEach { (type: Transaction.TransactionType, value: Double) in
            container.mainContext.insert(Transaction(
                id: UUID(),
                name: "Test",
                value: value,
                account: getAccount,
                category: nil,
                date: Date(),
                type: type,
                place: nil
            ))
        }
        try container.mainContext.save()
    }
    
    @Test("Test Account balance")
    func testAccountBalance() async throws {
        try createTransaction(with: [
            TestTrasactionInfo(.in, 100.0),
            TestTrasactionInfo(.in, 100.0),
        ])
        #expect(getAccount.balance == 200.0)
    }
    
    @Test("Test Account balance with transfer out")
    func testAccountBalanceWithTransferOut() async throws {
        try createTransaction(with: [
            TestTrasactionInfo(.in, 100.0),
            TestTrasactionInfo(.out, 100.0),
        ])
        #expect(getAccount.balance == 0)
    }
}
