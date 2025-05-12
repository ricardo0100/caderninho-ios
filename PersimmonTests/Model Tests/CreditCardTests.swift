//
//  CreditCardTests.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 11/05/25.
//

import Foundation
import Testing
import SwiftData
@testable import Persimmon

@MainActor
struct CreditCardTests {
    
    var container: ModelContainer
    var card: CreditCard!
    
    init() throws {
        container = .createTestContainer()
        card = createCardWith(closing: 3, dueDay: 10)
    }
    
    @Test("Current Bill With Clear Database Should Be Nil")
    func noBills() {
        #expect(card.currentBill == nil)
    }
    
    @Test("Current Bill With Only Payed Old Bills Should Be Nil")
    func onlyOldBills() async throws {
        let lastMonth = Date().dateAddingMonths(-1)
        let bill = Bill(id: UUID(), card: card, month: lastMonth.month, year: lastMonth.year)
        bill.payedDate = Date()
        container.mainContext.insert(bill)
        try! container.mainContext.save()
        #expect(card.currentBill == nil)
    }
    
    @Test("Current Bill With One Old Unpaid Bill")
    func oneUnpaid() async throws {
        let lastMonth = Date().dateAddingMonths(-1)
        let bill = Bill(id: UUID(), card: card, month: lastMonth.month, year: lastMonth.year)
        container.mainContext.insert(bill)
        try! container.mainContext.save()
        #expect(card.currentBill == bill)
    }
    
    private func createCardWith(closing: Int, dueDay: Int) -> CreditCard {
        CreditCard(id: UUID(),
                   name: "Test Card",
                   color: "#000000",
                   currency: "$",
                   closingCycleDay: closing,
                   dueDay: dueDay)
    }
}
