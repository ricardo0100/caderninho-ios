//
//  NewTransactionView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 25/05/25.
//
import SwiftUI
import SwiftData

struct NewTransactionView: View {
    @State var path = NavigationPath()
    @State var didPushAccountOrCard = false
    
    var account: Account? = nil
    var card: CreditCard? = nil
    
    init () {
    }
    
    init(with selectedAccount: Account) {
        self.account = selectedAccount
    }
    
    init(with selectedCard: CreditCard) {
        self.card = selectedCard
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            NewTransactionSelectAccountView()
                .navigationDestination(for: Account.self) { account in
                    NewTransactionValueView(account: account)
                }
                .navigationDestination(for: CreditCard.self) { card in
                    NewTransactionValueView(card: card)
                }
                .onAppear {
                    //TODO: improve nav logic
                    guard !didPushAccountOrCard else { return }
                    didPushAccountOrCard = true
                    if let account = account {
                        path.append(account)
                    } else if let card = card {
                        path.append(card)
                    }
                }
        }
    }
}

#Preview {
    NewTransactionView()
        .modelContainer(.preview)
}
