//
//  EditTransactionViewModel.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 22/12/24.
//

import SwiftUI
import SwiftData
import Vision
import PhotosUI
import NaturalLanguage

extension EditTransactionView {
    @MainActor
    public class ViewModel: ObservableObject {
        private let transaction: Transaction?
        private let modelContainer: ModelContainer
        
        // Model vars
        @Published var name: String
        @Published var type: Transaction.TransactionType {
            didSet {
                updateVisibleFields()
            }
        }
        @Published var account: Account?
        @Published var card: CreditCard?
        @Published var value: Double
        @Published var category: Category?
        @Published var date: Date
        @Published var place: Transaction.Place?
        @Published var numberOfInstallments: Int
        
        // UI state vars
        @Published var nameError: String? = ""
        @Published var accountError: String? = ""
        @Published var cardError: String? = ""
        @Published var showDeleteAlert = false
        @Published var shouldDismiss: Bool = false
        @Published var isRecognizingImage: Bool = false
        @Published var showAccountField: Bool = false
        @Published var showCardField: Bool = false
        
        init(transaction: Transaction? = nil, modelContainer: ModelContainer) {
            self.transaction = transaction
            self.modelContainer = modelContainer
            _name = Published(initialValue: transaction?.name ?? "")
            _account = Published(initialValue: transaction?.account)
            _card = Published(initialValue: transaction?.installments.first?.bill.card)
            _value = Published(initialValue: transaction?.value ?? .zero)
            _category = Published(initialValue: transaction?.category)
            _type = Published(initialValue: transaction?.type ?? .installments)
            _date = Published(initialValue: transaction?.date ?? Date())
            _place = Published(initialValue: transaction?.place)
            _numberOfInstallments = Published(initialValue: transaction?.installments.count ?? 1)
            updateVisibleFields()
        }
        
        init(ticketData: TicketData, modelContainer: ModelContainer) {
            self.transaction = nil
            self.modelContainer = modelContainer
            _name = Published(initialValue: "")
            _account = Published(initialValue: nil)
            _value = Published(initialValue: ticketData.value ?? 0)
            _category = Published(initialValue: nil)
            _type = Published(initialValue: ticketData.type ?? .installments)
            _date = Published(initialValue: ticketData.date ?? Date())
            _place = Published(initialValue: nil)
            _numberOfInstallments = Published(initialValue: 1)
            updateVisibleFields()
        }
        
        var showDeleteButton: Bool {
            transaction != nil
        }
        
        private var currency: String {
            (type == .installments ? card?.currency : account?.currency) ?? ""
        }
        
        var installmentsDescription: String {
            "\(numberOfInstallments) x \((value / Double(numberOfInstallments)).toCurrency(with: currency))"
        }
        
        @MainActor
        func viewDidAppear() {
            if transaction == nil, account == nil {
                account = fetchLastUsedAccount()
                category = fetchLastUsedCategory()
            }
        }
        
        private func updateVisibleFields() {
            showCardField = type == .installments
            showAccountField = type != .installments
        }
        
        func didTapCancel() {
            shouldDismiss = true
        }
        
        func didTapDelete() {
            showDeleteAlert = true
        }
        
        func didTapCancelDelete() {
            showDeleteAlert = false
        }
        
        func didConfirmDelete() {
            guard let transaction = transaction else { return }
            let context = modelContainer.mainContext
            context.delete(transaction)
            try? context.save()
            shouldDismiss = true
        }
        
        func didTapSave() {
            clearErrors()
            if name.isEmpty {
                nameError = "Mandatory field"
                return
            }
            if type != .installments, account == nil {
                accountError = "Select an account"
                return
            }
            if type == .installments, card == nil {
                cardError = "Select a card"
                return
            }
            
            saveTransaction()
        }
        
        private func clearErrors() {
            nameError = nil
            accountError = nil
            cardError = nil
        }
        
        private func fetchLastUsedAccount() -> Account? {
            try? modelContainer.mainContext.fetch(FetchDescriptor<Transaction>(
                sortBy: [SortDescriptor(\.date, order: .reverse)])).first?.account
        }
        
        private func fetchLastUsedCategory() -> Category? {
            try? modelContainer.mainContext.fetch(FetchDescriptor<Transaction>(
                sortBy: [SortDescriptor(\.date, order: .reverse)])).first?.category
        }
        
        private func saveTransaction() {
            if let transaction = transaction {
                updateExistingTransaction(transaction)
            } else {
                createNewTransaction()
            }
            do {
                try modelContainer.mainContext.save()
                shouldDismiss = true
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func updateExistingTransaction(_ transaction: Transaction) {
            transaction.name = name
            transaction.category = category
            transaction.value = value
            transaction.date = date
            transaction.place = place
            
            if type == .installments, let card = card {
                transaction.account = nil
                transaction.installments.forEach {
                    modelContainer.mainContext.delete($0)
                }
                transaction.installments = createInstallments(in: card,
                                                              transaction: transaction,
                                                              numberOfInstallments: numberOfInstallments)
            } else if let account = account {
                transaction.account = account
                transaction.installments.removeAll()
            }
        }
        
        private func createInstallments(in card: CreditCard, transaction: Transaction, numberOfInstallments: Int) -> [Installment] {
            let date = transaction.date
            var monthsRange = (1...numberOfInstallments)
            if transaction.date.day < card.dueDay {
                monthsRange = (0...numberOfInstallments - 1)
            }
            return monthsRange.map { i in
                let month = Calendar.current.component(.month, from: date.dateAddingMonths(i))
                let year = Calendar.current.component(.year, from: date.dateAddingMonths(i))
                
                let bill = card.bills.first { $0.dueYear == year && $0.dueMonth == month } ??
                    .init(id: UUID(), card: card, month: month, year: year)
                
                return Installment(id: UUID(),
                                   transaction: transaction,
                                   number: transaction.date.day < card.dueDay ? i + 1 : i,
                                   bill: bill,
                                   value: transaction.value / Double(numberOfInstallments))
            }
        }
        
        func createNewTransaction() {
            let transaction: Transaction
            if type == .installments {
                transaction = Transaction(
                    id: UUID(),
                    name: name,
                    value: value,
                    category: category,
                    date: date,
                    place: place)
                transaction.installments = createInstallments(in: card!,
                                                              transaction: transaction,
                                                              numberOfInstallments: numberOfInstallments)
            } else {
                transaction = Transaction(
                    id: UUID(),
                    name: name,
                    value: value,
                    account: account!,
                    category: category,
                    date: date,
                    type: type,
                    place: place)
            }
            modelContainer.mainContext.insert(transaction)
        }
    }
}
