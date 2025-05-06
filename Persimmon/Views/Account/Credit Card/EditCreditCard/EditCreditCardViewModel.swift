//
//  EditCreditCardViewModel.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 04/05/25.
//

import SwiftUI
import SwiftData

extension EditCreditCardView {
    class ViewModel: ObservableObject {
        let creditCard: CreditCard?
        
        @Published var name: String
        @Published var nameError: String?
        @Published var niceColor: NiceColor
        @Published var currency: String
        @Published var currencyError: String?
        @Published var closingCycleDay: Int
        @Published var dueDay: Int
        
        @Published var shouldDismiss = false
        @Published var showDeleteAlert = false
        @Published var isShowingColorPicker = false
        
        init(creditCard: CreditCard? = nil) {
            self.creditCard = creditCard
            _name = Published(initialValue: creditCard?.name ?? "")
            _niceColor = Published(initialValue: NiceColor(rawValue: creditCard?.color ?? "") ?? .gray)
            _currency = Published(initialValue: creditCard?.currency ?? "")
            _closingCycleDay = Published(initialValue: creditCard?.closingCycleDay ?? 3)
            _dueDay = Published(initialValue: creditCard?.dueDay ?? 10)
        }
        
        @MainActor
        func didTapSave() {
            clearErrors()
            if name.isEmpty {
                nameError = "Choose a name for this card"
                return
            }
            if currency.isEmpty {
                currencyError = "Choose a currency for this card"
                return
            }
            let context = ModelContainer.shared.mainContext
            if let card = creditCard {
                card.name = name
                card.color = niceColor.rawValue
                card.currency = currency
                card.closingCycleDay = closingCycleDay
                card.dueDay = dueDay
            } else {
                let card =  CreditCard(id: UUID(),
                                      name: name,
                                      color: niceColor.rawValue,
                                      currency: currency,
                                      closingCycleDay: closingCycleDay,
                                      dueDay: dueDay)
                
                context.insert(card)
            }
            do {
                try context.save()
                shouldDismiss = true
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func didConfirmDelete() {
            shouldDismiss = true
        }
        
        private func clearErrors() {
            nameError = nil
            currencyError = nil
        }
    }
}
