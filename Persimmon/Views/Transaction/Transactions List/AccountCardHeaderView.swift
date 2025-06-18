//
//  AccountCardHeader.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 25/05/25.
//

import SwiftUI
import SwiftData
import UIKit

struct AccountCardHeaderView: View {
    @Query var accounts: [Account]
    @Query var cards: [CreditCard]
    @Binding var selectedId: UUID?
    
    let rows = [
        GridItem(.adaptive(minimum: 100, maximum: 200)),
        GridItem(.adaptive(minimum: 100, maximum: 200)),
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows) {
                ForEach(makeArray(accounts: accounts, cards: cards), id: \.self) { item in
                    HStack {
                        if let icon = item.icon {
                            Image(icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 44)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.caption)
                            Text(item.value.toCurrency(with: item.currency))
                                .font(.caption2)
                                .foregroundStyle((item.value < 0) ? Color(.systemRed) : .primary)
                        }
                        Spacer()
                    }
                    .background(selectedId == item.id ? Color.gray.opacity(0.3) : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.spacingSmall)
                    .onTapGesture {
                        withAnimation {
                            if selectedId == item.id {
                                selectedId = nil
                            } else {
                                selectedId = item.id
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func makeArray(accounts: [Account], cards: [CreditCard]) -> [HeaderItem] {
        (cards.map { HeaderItem(
            id: $0.id,
            name: $0.name,
            icon: $0.icon,
            lastUsed: $0.lastTransaction?.date,
            value: $0.currentBill?.total ?? .zero,
            currency: $0.currency,
            account: nil,
            card: $0)
        } + accounts.map {
            HeaderItem(
                id: $0.id,
                name: $0.name,
                icon: $0.icon,
                lastUsed: $0.lastTransaction?.date,
                value: $0.balance,
                currency: $0.currency,
                account: $0,
                card: nil)
        }).sorted { $0.lastUsed ?? Date.distantPast > $1.lastUsed ?? Date.distantPast }
    }
    
    struct HeaderItem: Hashable {
        let id: UUID
        let name: String
        let icon: String?
        let lastUsed: Date?
        let value: Double
        let currency: String
        let account: Account?
        let card: CreditCard?
    }
}

#Preview {
    @Previewable @State var selectedId: UUID?
    AccountCardHeaderView(selectedId: $selectedId)
        .modelContainer(.preview)
}
