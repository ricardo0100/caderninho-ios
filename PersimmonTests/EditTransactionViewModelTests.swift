//
//  EditTransactionViewModel.swift
//  PersimmonTests
//
//  Created by Ricardo Gehrke Filho on 06/05/25.
//

import Foundation
import Testing
import SwiftData
@testable import Persimmon

@MainActor
@Suite("Test Edit Transaction ViewModel")
struct EditTransactionViewModelTests {
    var container: ModelContainer
    
    init() throws {
        container = .createTestContainer()
        let context = container.mainContext
        context.insert(Account(id: UUID(), name: "Bank of Maya", color: "#F00FFF", currency: "R$"))
        context.insert(Category(id: UUID(), name: "Food", color: "#F7F8F9", icon: "carrot"))
        try context.save()
    }
    
    var getTransactions: [Transaction] {
        try! container.mainContext.fetch(FetchDescriptor<Transaction>())
    }
    
    var getAccounts: [Account] {
        try! container.mainContext.fetch(FetchDescriptor<Account>())
    }
    
    var getCategories: [Persimmon.Category] {
        try! container.mainContext.fetch(FetchDescriptor<Persimmon.Category>())
    }
    
    var getBills: [Bill] {
        try! container.mainContext.fetch(FetchDescriptor<Persimmon.Bill>())
    }
    
    func createTransactionInContext() throws -> Transaction {
        let place = Transaction.Place(name: "Market")
        let transaction = Transaction(id: UUID(),
                                      name: "Test Name",
                                      value: 123,
                                      account: getAccounts.first!,
                                      category: getCategories.first!,
                                      date: Date(timeIntervalSince1970: 10),
                                      type: .buyDebit,
                                      place: place)
        container.mainContext.insert(transaction)
        try container.mainContext.save()
        return transaction
    }
    
    @Test("Load fields from existing transaction")
    func loadTransactionFields() throws {
        let transaction = try createTransactionInContext()
        let sut = EditTransactionView.ViewModel(transaction: transaction, modelContainer: container)
        #expect(sut.name == "Test Name")
        #expect(sut.value == 123)
        #expect(sut.account?.name == "Bank of Maya")
        #expect(sut.category?.name == "Food")
        #expect(sut.type == .buyDebit)
        #expect(sut.date == Date(timeIntervalSince1970: 10))
        #expect(sut.place?.name == "Market")
    }
    
    @Test("Save new transaction")
    func saveNewTransaction() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test Name"
        sut.account = getAccounts.first!
        sut.type = .buyDebit
        sut.value = 1.99
        sut.didTapSave()
        #expect(getTransactions.first!.name == "Test Name")
    }
    
    @Test("Update existing transaction")
    func updateTransaction() async throws {
        let sut = EditTransactionView.ViewModel(transaction: try createTransactionInContext(), modelContainer: container)
        sut.name = "Changed Name"
        sut.type = .transferOut
        sut.didTapSave()
        
        #expect(getTransactions.first!.name == "Changed Name")
        #expect(sut.type == .transferOut)
    }
    
    @Test("Show Name Error Message")
    func showNameErrorMessage() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.didTapSave()
        #expect(sut.nameError == "Mandatory field")
    }
    
    @Test("Show Account Error Message")
    func showAccountErrorMessage() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.didTapSave()
        #expect(sut.accountError == "Select an account")
    }
    
    @Test("Create Installments", arguments: 1...12)
    func createInstallments(_ numberOfInstallments: Int) async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.account = getAccounts.first!
        sut.type = .buyCredit
        sut.value = 100
        sut.numberOfInstallments = numberOfInstallments
        sut.didTapSave()
        
        #expect(getTransactions.first!.name == "Test")
        #expect(getTransactions.first!.installments.count == numberOfInstallments)
        
    }
}
