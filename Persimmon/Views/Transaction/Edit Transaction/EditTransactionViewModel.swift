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
        private let modelManager: ModelManager
        private let navigation: TransactionsNavigation
        private let context: ModelContext
        // Model vars
        @Published var name: String
        @Published var operation: Transaction.Operation {
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
        @Published var isRecognizingImage: Bool = false
        @Published var showAccountField: Bool = false
        @Published var showCardField: Bool = false
        
        init(transaction: Transaction? = nil, context: ModelContext, navigation: TransactionsNavigation) {
            self.transaction = transaction
            self.context = context
            self.navigation = navigation
            self.modelManager = ModelManager(context: context)
            _name = Published(initialValue: transaction?.name ?? "")
            _account = Published(initialValue: transaction?.account)
            _card = Published(initialValue: transaction?.installments.first?.bill?.card)
            _value = Published(initialValue: transaction?.value ?? .zero)
            _category = Published(initialValue: transaction?.category)
            _operation = Published(initialValue: Transaction.Operation(rawValue: transaction?.operation ?? 0)!)
            _date = Published(initialValue: transaction?.date ?? Date())
            _place = Published(initialValue: transaction?.place)
            _numberOfInstallments = Published(initialValue: transaction?.installments.count ?? 1)
            updateVisibleFields()
        }
        
        init(ticketData: TicketData, context: ModelContext) {
            self.transaction = nil
            self.navigation = TransactionsNavigation()
            self.context = context
            self.modelManager = ModelManager(context: context)
            _name = Published(initialValue: "")
            _account = Published(initialValue: nil)
            _value = Published(initialValue: ticketData.value ?? 0)
            _category = Published(initialValue: nil)
            _operation = Published(initialValue: ticketData.type ?? .installments)
            _date = Published(initialValue: ticketData.date ?? Date())
            _place = Published(initialValue: nil)
            _numberOfInstallments = Published(initialValue: 1)
            updateVisibleFields()
        }
        
        var showDeleteButton: Bool {
            transaction != nil
        }
        
        private var currency: String {
            (operation == .installments ? card?.currency : account?.currency) ?? ""
        }
        
        var installmentsDescription: String {
            "\(numberOfInstallments) x \((value / Double(numberOfInstallments)).toCurrency(with: currency))"
        }
        
        @MainActor
        func viewDidAppear() {
            if transaction == nil {
                category = fetchLastUsedCategory()
                if operation == .installments {
                    card = fetchLastUsedCard()
                } else {
                    account = fetchLastUsedAccount()
                }
            }
        }
        
        private func updateVisibleFields() {
            showCardField = operation == .installments
            showAccountField = operation != .installments
        }
        
        func didTapCancel() {
            navigation.editingTransaction = nil
        }
        
        func didTapDelete() {
            showDeleteAlert = true
        }
        
        func didTapCancelDelete() {
            showDeleteAlert = false
        }
        
        func didConfirmDelete() {
            guard let transaction = transaction else { return }
            modelManager.deleteTransaction(transaction: transaction)
            navigation.path.removeLast()
            navigation.editingTransaction = nil
        }
        
        func didTapSave() {
            clearErrors()
            if name.isEmpty {
                nameError = "Mandatory field"
                return
            }
            if operation != .installments, account == nil {
                accountError = "Select an account"
                return
            }
            if operation == .installments, card == nil {
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
            try? context.fetch(FetchDescriptor<Transaction>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]))
            .filter { $0.account != nil }.first?.account
        }
        
        func fetchLastUsedCard() -> CreditCard? {
            try? context.fetch(FetchDescriptor<Transaction>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]))
            .filter { $0.account == nil }.first?.installments.first?.bill?.card
        }
        
        func fetchLastUsedCategory() -> Category? {
            try? context.fetch(FetchDescriptor<Transaction>(
                sortBy: [SortDescriptor(\.date, order: .reverse)])).first?.category
        }
        
        private func saveTransaction() {
            if let transaction = self.transaction {
                try! modelManager.updateTransaction(
                    transaction: transaction,
                    name: name,
                    date: date,
                    editOperation: editOperation(),
                    category: category,
                    place: place
                )
            } else {
                try! modelManager.createTransaction(
                    name: name,
                    date: date,
                    editOperation: editOperation(),
                    category: category,
                    place: place
                )
            }
        }
        
        private func editOperation() -> Transaction.EditOperation {
            switch operation {
            case .transferOut:
                return .transferOut(account: account!, value: value)
            case .transferIn:
                return .transferIn(account: account!, value: value)
            case .installments:
                return .installments(card: card!, numberOfInstallments: numberOfInstallments, value: value)
            case .refund:
                fatalError()
            }
        }
    }
}
