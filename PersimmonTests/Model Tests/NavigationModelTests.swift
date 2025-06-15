//
//  NavigationModelTests.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 14/06/25.
//

import Testing
import Foundation
import SwiftUI

@testable import Persimmon

struct NavigationModelTests {
    
    var model: NavigationModel!
    
    init() {
        model = NavigationModel()
    }
    
    func createDummyAccount() -> Account {
        Account(id: UUID(), name: "", color: "", icon: nil, currency: "")
    }
    
    @Test
    func testInitialState() {
        #expect(model.selectedTab == .transactions)
        #expect(model.transactionsPath.isEmpty)
        #expect(model.categoriesPath.isEmpty)
        #expect(model.accountsPath.isEmpty)
        #expect(model.editingTransaction == nil)
        #expect(model.editingCategory == nil)
        #expect(model.editingAccount == nil)
        #expect(model.editingCard == nil)
        #expect(model.newTransaction == false)
        #expect(model.newCategory == false)
        #expect(model.newAccount == false)
        #expect(model.newCard == false)
    }
    
    @Test
    func testPresentAccount() {
        model.presentAccount(createDummyAccount())
        
        #expect(model.selectedTab == .accountsAndCards)
        #expect(model.accountsPath.count == 1)
    }
    
    @Test
    func testPresentCard() {
        let card = CreditCard(id: UUID(), name: "", color: "", icon: nil, currency: "R$", closingCycleDay: 3, dueDay: 10)
        model.presentCard(card)
        
        #expect(model.selectedTab == .accountsAndCards)
        #expect(model.accountsPath.count == 1)
    }

    @Test
    func testDismissDeletedTransaction_onTransactionsTab() {
        model.selectedTab = .transactions
        model.transactionsPath.append("Dummy")
        model.editingTransaction = Transaction(
            name: .init(),
            date: .init(),
            editOperation: .transferIn(account: createDummyAccount(), value: .init()),
            category: nil,
            place: nil)

        model.dismissDeletedTransaction()

        #expect(model.editingTransaction == nil)
        #expect(model.transactionsPath.isEmpty)
    }
    
    @Test
    func testDismissDeletedTransaction_onCategoriesTab() {
        model.selectedTab = .categories
        model.categoriesPath.append("Dummy")
        model.editingTransaction = Transaction(
            name: .init(),
            date: .init(),
            editOperation: .transferIn(account: createDummyAccount(), value: .init()),
            category: nil,
            place: nil)

        model.dismissDeletedTransaction()

        #expect(model.editingTransaction == nil)
        #expect(model.categoriesPath.isEmpty)
    }
    
    @Test
    func testDismissDeletedTransaction_onAccountsTab() {
        model.selectedTab = .accountsAndCards
        model.accountsPath.append("Dummy")
        model.editingTransaction = Transaction(
            name: .init(),
            date: .init(),
            editOperation: .transferIn(account: createDummyAccount(), value: .init()),
            category: nil,
            place: nil)

        model.dismissDeletedTransaction()

        #expect(model.editingTransaction == nil)
        #expect(model.accountsPath.isEmpty)
    }
}
