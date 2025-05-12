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
        context.insert(CreditCard(id: UUID(), name: "Bank of Maya", color: "#F00FFF", currency: "R$", closingCycleDay: 3, dueDay: 10))
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
    
    var getCards: [CreditCard] {
        try! container.mainContext.fetch(FetchDescriptor<Persimmon.CreditCard>())
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
                                      type: .out,
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
        #expect(sut.type == .out)
        #expect(sut.date == Date(timeIntervalSince1970: 10))
        #expect(sut.place?.name == "Market")
    }
    
    @Test("Save new transaction")
    func saveNewTransaction() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test Name"
        sut.account = getAccounts.first!
        sut.type = .out
        sut.value = 1.99
        sut.didTapSave()
        #expect(getTransactions.first!.name == "Test Name")
    }
    
    @Test("Update existing transaction")
    func updateTransaction() async throws {
        let sut = EditTransactionView.ViewModel(transaction: try createTransactionInContext(), modelContainer: container)
        sut.name = "Changed Name"
        sut.type = .out
        sut.didTapSave()
        
        #expect(getTransactions.first!.name == "Changed Name")
        #expect(sut.type == .out)
    }
    
    @Test("Show Name Error Message")
    func showNameErrorMessage() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.didTapSave()
        #expect(sut.nameError == "Mandatory field")
        #expect(getTransactions.isEmpty)
    }
    
    @Test("Show Account Error Message")
    func showAccountErrorMessage() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.type = .out
        sut.didTapSave()
        #expect(sut.accountError == "Select an account")
        #expect(getTransactions.isEmpty)
    }
    
    @Test("Show Card Error Message")
    func showCardErrorMessage() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.type = .installments
        sut.didTapSave()
        #expect(sut.cardError == "Select a card")
        #expect(getTransactions.isEmpty)
    }
    
    @Test("Clear Card Error Message")
    func clearCardErrorMessage() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.type = .installments
        sut.didTapSave()
        #expect(sut.cardError == "Select a card")
        sut.card = getCards.first!
        sut.didTapSave()
        #expect(sut.cardError == nil)
    }
    
    @Test("Show Account Field")
    func showAccountField() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.type = .out
        #expect(sut.showAccountField)
        #expect(!sut.showCardField)
    }
    
    @Test("Show Card Field")
    func showCardField() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.type = .installments
        #expect(!sut.showAccountField)
        #expect(sut.showCardField)
    }
    
    
    @Test("Create Installments", arguments: 1...12)
    func createInstallments(_ numberOfInstallments: Int) async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.card = getCards.first!
        sut.type = .installments
        sut.value = 100
        sut.numberOfInstallments = numberOfInstallments
        sut.didTapSave()
        
        #expect(getTransactions.first!.name == "Test")
        #expect(getTransactions.first!.installments.count == numberOfInstallments)
        #expect(getTransactions.first!.installments.first!.value == 100 / Double(numberOfInstallments))
    }
}
