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
        @Published var type: Transaction.Operation {
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
            
            _type = Published(initialValue: transaction?.operation ?? .installments)
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
            if transaction == nil {
                category = fetchLastUsedCategory()
                if type == .installments {
                    card = fetchLastUsedCard()
                } else {
                    account = fetchLastUsedAccount()
                }
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
        
        func fetchLastUsedAccount() -> Account? {
            try? modelContainer.mainContext.fetch(FetchDescriptor<Transaction>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]))
            .filter { $0.account != nil }.first?.account
        }
        
        func fetchLastUsedCard() -> CreditCard? {
            try? modelContainer.mainContext.fetch(FetchDescriptor<Transaction>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]))
            .filter { $0.account == nil }.first?.installments.first?.bill.card
        }
        
        func fetchLastUsedCategory() -> Category? {
            try? modelContainer.mainContext.fetch(FetchDescriptor<Transaction>(
                sortBy: [SortDescriptor(\.date, order: .reverse)])).first?.category
        }
        
        private func saveTransaction() {
            if let transaction = self.transaction {
                transaction.update(
                    name: name,
                    date: date,
                    value: value,
                    editOperation: editOperation(),
                    category: category,
                    place: place)
            } else {
                let transaction = Transaction(
                    name: name,
                    date: date,
                    value: value,
                    editOperation: editOperation(),
                    category: category,
                    place: place)
                modelContainer.mainContext.insert(transaction)
            }
            do {
                try modelContainer.mainContext.save()
                shouldDismiss.toggle()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        private func editOperation() -> Transaction.EditOperation {
            switch type {
            case .transferOut:
                return .transferOut(account: account!)
            case .transferIn:
                return .transferIn(account: account!)
            case .installments:
                return .installments(card: card!, numberOfInstallments: numberOfInstallments)
            case .refund:
                fatalError()
            }
        }
    }
}
