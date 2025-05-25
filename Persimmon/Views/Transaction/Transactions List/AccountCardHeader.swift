//
//  AccountCardHeader.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 25/05/25.
//

import SwiftUI
import SwiftData
import UIKit

struct AccountCardHeader: View {
    @Query var accounts: [Account]
    @Query var cards: [CreditCard]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(makeArray(accounts: accounts, cards: cards), id: \.self) { item in
                    HStack {
                        if let icon = item.icon {
                            Image(icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24)
                        } else {
                            
                        }
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.caption)
                            Text(item.value.toCurrency(with: item.currency))
                                .font(.caption)
                                .foregroundStyle((item.value < 0) ? Color(.systemRed) : .primary)
                        }
                    }
                    .padding(.spacingMedium)
//                    .background(color)
                }
            }
        }
    }
    
    private func makeArray(accounts: [Account], cards: [CreditCard]) -> [HeaderItem] {
        (cards.map { HeaderItem(
            id: $0.id.uuidString,
            name: $0.name,
            icon: $0.icon,
            lastUsed: $0.lastTransaction?.date,
            value: $0.currentBill?.total ?? .zero,
            currency: $0.currency)
        } + accounts.map {
            HeaderItem(
                id: $0.id.uuidString,
                name: $0.name,
                icon: $0.icon,
                lastUsed: $0.lastTransaction?.date,
                value: $0.balance,
                currency: $0.currency)
        }).sorted { $0.lastUsed ?? Date.distantPast > $1.lastUsed ?? Date.distantPast }
    }
    
    struct HeaderItem: Hashable {
        let id: String
        let name: String
        let icon: String?
        let lastUsed: Date?
        let value: Double
        let currency: String
    }
}

#Preview {
    AccountCardHeader()
}
