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
    public class ViewModel: ObservableObject {
        let transaction: Transaction?
        
        // Model vars
        @Published var name: String
        @Published var account: Account?
        @Published var value: Double
        @Published var category: Category?
        @Published var type: Transaction.TransactionType
        @Published var date: Date
        @Published var place: Transaction.Place?
        @Published var shares: Int
        
        // UI only vars
        @Published var nameError: String? = ""
        @Published var accountError: String? = ""
        @Published var showDeleteAlert = false
        @Published var shouldDismiss: Bool = false
        @Published var isRecognizingImage: Bool = false
        
        init(transaction: Transaction? = nil) {
            self.transaction = transaction
            _name = Published(initialValue: transaction?.name ?? "")
            _account = Published(initialValue: transaction?.account)
            _value = Published(initialValue: transaction?.value ?? .zero)
            _category = Published(initialValue: transaction?.category)
            _type = Published(initialValue: transaction?.type ?? .buyCredit)
            _date = Published(initialValue: transaction?.date ?? Date())
            _place = Published(initialValue: transaction?.place)
            _shares = Published(initialValue: transaction?.shares.count ?? 1)
        }
        
        init(ticketData: TicketData) {
            self.transaction = nil
            _name = Published(initialValue: "")
            _account = Published(initialValue: nil)
            _value = Published(initialValue: ticketData.value ?? 0)
            _category = Published(initialValue: nil)
            _type = Published(initialValue: ticketData.type ?? .buyCredit)
            _date = Published(initialValue: ticketData.date ?? Date())
            _place = Published(initialValue: nil)
            _shares = Published(initialValue: 1)
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
        
        @MainActor func didConfirmDelete() {
            guard let transaction = transaction else { return }
            let context = ModelContainer.shared.mainContext
            context.delete(transaction)
            try? context.save()
            shouldDismiss = true
        }
        
        @MainActor func didTapSave() {
            withAnimation {
                clearErrors()
                guard !name.isEmpty else {
                    nameError = "Mandatory field"
                    return
                }
                guard account != nil else {
                    accountError = "Select an account"
                    return
                }
            }
            saveTransaction()
        }
        
        private func clearErrors() {
            nameError = nil
            accountError = nil
        }
        
        @MainActor private func saveTransaction() {
            let context = ModelContainer.shared.mainContext
            guard let account = account else {
                return
            }
            if let transaction = transaction {
                transaction.name = name
                transaction.account = account
                transaction.category = category
                transaction.value = value
                transaction.date = date
                transaction.place = place
            } else {
                let transaction = Transaction(
                    id: UUID(),
                    name: name,
                    value: value,
                    account: account,
                    category: category,
                    date: date,
                    type: type,
                    place: place)
                context.insert(transaction)
            }
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            shouldDismiss = true
        }
    }
}
