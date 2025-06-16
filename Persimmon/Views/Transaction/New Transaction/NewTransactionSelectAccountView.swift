//
//  NewTransactionSelectAccountView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 27/05/25.
//


import SwiftUI
import SwiftData

struct NewTransactionSelectAccountView: View {
    @Query var accounts: [Account]
    @Query var cards: [CreditCard]
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        List {
            Section("Accounts") {
                ForEach(accounts) { account in
                    NavigationLink(value: account) {
                        HStack {
                            if let icon = account.icon {
                                Image(icon)
                            }
                            
                            Text(account.name)
                        }
                    }
                }
            }
            
            Section("Credit Cards") {
                ForEach(cards) { card in
                    NavigationLink(value: card) {
                        HStack {
                            if let icon = card.icon {
                                Image(icon)
                            }
                            
                            Text(card.name)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select an account or card")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    navigationModel.newTransaction = false
                    navigationModel.newTransactionWithAccount = nil
                    navigationModel.newTransactionWithCard = nil
                }
            }
        }
    }
}
