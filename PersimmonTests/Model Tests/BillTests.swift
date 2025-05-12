//
//  BillTests.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 11/05/25.
//

import Foundation
import Testing
import SwiftData
@testable import Persimmon

@MainActor
struct BillTests {
    
    var container: ModelContainer
    
    init() throws {
        container = .createTestContainer()
    }
    
    @Test("Test Bill Is Not Delayed")
    func testBillIsNotDelayed() async throws {
        let billDue = Date()
        let card = createCardWith(dueDay: billDue.day)
        let bill = Bill(id: UUID(),
                        card: card,
                        month: billDue.month,
                        year: billDue.year)
        #expect(!bill.isDelayed)
    }
    
    @Test("Test Bill Is Delayed")
    func testBillIsDelayed() async throws {
        let billDue = Date().dateAddingDays(-1)
        let card = createCardWith(dueDay: billDue.day)
        let bill = Bill(id: UUID(),
                        card: card,
                        month: billDue.month,
                        year: billDue.year)
        #expect(bill.isDelayed)
    }
    
    @Test("Test Bill Is Payed")
    func testBillIsPayed() async throws {
        let billDue = Date().dateAddingDays(-1)
        let card = createCardWith(dueDay: billDue.day)
        let bill = Bill(id: UUID(),
                        card: card,
                        month: billDue.month,
                        year: billDue.year)
        bill.payedDate = Date()
        #expect(!bill.isDelayed)
    }
    
    private func createCardWith(dueDay: Int) -> CreditCard {
        CreditCard(id: UUID(), name: "Test Card", color: "#000000", currency: "$", closingCycleDay: 3, dueDay: dueDay)
    }
}
