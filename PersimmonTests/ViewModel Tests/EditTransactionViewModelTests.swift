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
        context.insert(Account(id: UUID(), name: "Bank of Maya", color: "#F00FFF", icon: nil, currency: "R$"))
        context.insert(CreditCard(id: UUID(), name: "Bank of Maya", color: "#F00FFF", icon: nil, currency: "R$", closingCycleDay: 3, dueDay: 10))
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
    
    var getCard: CreditCard {
        try! container.mainContext.fetch(FetchDescriptor<CreditCard>())[0]
    }
    
    var getBills: [Bill] {
        try! container.mainContext.fetch(FetchDescriptor<Bill>())
    }
    
    var getInstalments: [Installment] {
        try! container.mainContext.fetch(FetchDescriptor<Installment>())
    }
    
    func createTransactionInContext() throws -> Transaction {
        let place = Transaction.Place(name: "Market")
        let transaction = Transaction(
            name: "Test Name",
            date: Date(timeIntervalSince1970: 10),
            editOperation: .transferOut(account: getAccounts[0], value: 123),
            category: getCategories.first!,
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
        #expect(sut.operation == .transferOut)
        #expect(sut.date == Date(timeIntervalSince1970: 10))
        #expect(sut.place?.name == "Market")
    }
    
    @Test("Save new transaction")
    func saveNewTransaction() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test Name"
        sut.account = getAccounts.first!
        sut.operation = .transferIn
        sut.value = 1.99
        sut.didTapSave()
        #expect(getTransactions.first!.name == "Test Name")
    }
    
    @Test("Update existing transaction")
    func updateTransaction() async throws {
        let sut = EditTransactionView.ViewModel(transaction: try createTransactionInContext(), modelContainer: container)
        sut.name = "Changed Name"
        sut.operation = .transferIn
        sut.didTapSave()
        
        #expect(getTransactions.first!.name == "Changed Name")
        #expect(sut.operation == .transferIn)
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
        sut.operation = .transferIn
        sut.didTapSave()
        #expect(sut.accountError == "Select an account")
        #expect(getTransactions.isEmpty)
    }
    
    @Test("Show Card Error Message")
    func showCardErrorMessage() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.operation = .installments
        sut.didTapSave()
        #expect(sut.cardError == "Select a card")
        #expect(getTransactions.isEmpty)
    }
    
    @Test("Clear Card Error Message")
    func clearCardErrorMessage() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.operation = .installments
        sut.didTapSave()
        #expect(sut.cardError == "Select a card")
        sut.card = getCard
        sut.didTapSave()
        #expect(sut.cardError == nil)
    }
    
    @Test("Show Account Field")
    func showAccountField() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.operation = .transferIn
        #expect(sut.showAccountField)
        #expect(!sut.showCardField)
    }
    
    @Test("Show Card Field")
    func showCardField() async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.operation = .installments
        #expect(!sut.showAccountField)
        #expect(sut.showCardField)
    }
    
    
    @Test("Create Installments", arguments: 1...12)
    func createInstallments(_ numberOfInstallments: Int) async throws {
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.card = getCard
        sut.operation = .installments
        sut.value = 100
        sut.numberOfInstallments = numberOfInstallments
        sut.didTapSave()
        #expect(getInstalments.count == numberOfInstallments)
        #expect(getTransactions.first!.name == "Test")
        #expect(getTransactions.first!.installments.count == numberOfInstallments)
        #expect(getTransactions.first!.installments.first!.value == 100 / Double(numberOfInstallments))
    }
    
    @Test("Create installments based on transaction date")
    func createInstallmentsBasedOnTransactionDate() async throws {
        let transactionDate = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 12))!
        
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.card = getCard
        sut.operation = .installments
        sut.value = 120
        sut.numberOfInstallments = 3
        sut.date = transactionDate
        sut.didTapSave()
        #expect(getInstalments.count == 3)
        #expect(getInstalments.sorted()[0].bill.dueMonth == 2)
        #expect(getInstalments.sorted()[1].bill.dueMonth == 3)
        #expect(getInstalments.sorted()[2].bill.dueMonth == 4)
    }
    
    @Test("Recreate installments after date transaction change")
    func recreateInstallmentsAfterDateTransactionChange() async throws {
        let transactionDate = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 12))!
        var sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.card = getCard
        sut.operation = .installments
        sut.value = 120
        sut.numberOfInstallments = 3
        sut.date = transactionDate
        sut.didTapSave()
        
        sut = EditTransactionView.ViewModel(transaction: getTransactions[0], modelContainer: container)
        
        let newDate = Calendar.current.date(from: DateComponents(year: 2000, month: 2, day: 12))!
        sut.date = newDate
        sut.didTapSave()
        #expect(getInstalments.count == 3)
        #expect(getInstalments.sorted()[0].bill.dueMonth == 3)
        #expect(getInstalments.sorted()[1].bill.dueMonth == 4)
        #expect(getInstalments.sorted()[2].bill.dueMonth == 5)
    }
    
    @Test("Create installments in current month if before closing date")
    func createInstallmentsInCurrentMonthIfBeforeClosingDate() async throws {
        let transactionDate = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 1))!
        let sut = EditTransactionView.ViewModel(transaction: nil, modelContainer: container)
        sut.name = "Test"
        sut.card = getCard
        sut.operation = .installments
        sut.value = 120
        sut.numberOfInstallments = 3
        sut.date = transactionDate
        sut.didTapSave()
        
        #expect(getInstalments.count == 3)
        #expect(getInstalments.sorted()[0].bill.dueMonth == 1)
        #expect(getInstalments.sorted()[1].bill.dueMonth == 2)
        #expect(getInstalments.sorted()[2].bill.dueMonth == 3)
    }
}
