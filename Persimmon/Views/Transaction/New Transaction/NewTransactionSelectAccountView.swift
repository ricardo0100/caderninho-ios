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
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 48)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            VStack(alignment: .leading) {
                                Text(account.name)
                                    .font(.headline)
                                Text(account.balanceWithCurrency)
                                    .foregroundStyle(account.balance < 0 ? Color.red : .primary)
                                    .font(.subheadline)
                            }
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
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 48)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            VStack(alignment: .leading) {
                                Text(card.name)
                                    .font(.headline)
                                if let bill = card.currentBill {
                                    Text("Current bill: ")
                                        .font(.caption)
                                    Text(bill.totalWithCurrency)
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("New transaction")
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
