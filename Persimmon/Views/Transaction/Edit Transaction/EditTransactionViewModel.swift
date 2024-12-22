//
//  EditTransactionViewModel.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 22/12/24.
//
import SwiftUI
import SwiftData

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
        
        init(transaction: Transaction?) {
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
        
        func didTapCancel() {
            dismiss()
        }
        
        func didTapSave(using modelContext: ModelContext) {
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
                saveTransaction(using: modelContext)
            }
        }
        
        private func clearErrors() {
            nameError = nil
            accountError = nil
        }
        
        private func saveTransaction(using modelContext: ModelContext) {
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
                modelContext.insert(transaction)
            }
            do {
                try modelContext.save()
            } catch {
                print(error.localizedDescription)
            }
            
            dismiss()
        }
        
        func dismiss() {
            
        }
    }
}
