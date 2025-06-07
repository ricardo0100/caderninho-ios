//
//  CurrencySelectorView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 07/06/25.
//

import SwiftUI
import SwiftData

struct CurrencySelectorView: View {
    @Query var accounts: [Account]
    @Query var cards: [CreditCard]
    
    @Binding var selectedCurrency: String?
    
    var allCurrencies: [String] {
        Set(accounts.map(\.currency) + cards.map(\.currency)).sorted()
    }
    
    var body: some View {
        Menu {
            ForEach(allCurrencies, id: \.self) { currency in
                Button(currency) {
                    withAnimation {
                        selectedCurrency = currency
                    }
                }
            }
        } label: {
            Text(selectedCurrency ?? allCurrencies.first ?? "")
        }
        .onAppear {
            if selectedCurrency == nil || !allCurrencies.contains(selectedCurrency ?? "") {
                selectedCurrency = allCurrencies.first
            }
        }
    }
}

#Preview {
    @Previewable @State var currency: String?
    
    CurrencySelectorView(selectedCurrency: $currency)
        .modelContext(.preview)
}
