//
//  AccountsBalancesView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 21/12/24.
//


import SwiftUI
import SwiftData

struct AccountsBalancesView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("home-currency") private var homeCurrency = Locale.current.currency?.identifier ?? ""
    @Query var accounts: [Account]
    
    var body: some View {
        let items = accounts.filter { $0.currency == homeCurrency }.map {
            let balance = $0.balance
            let title = try! AttributedString(markdown: "**\($0.name)** \($0.balance.toCurrency(with: $0.currency))")
            return GraphItem(title: title, value: balance, color: Color(hex: $0.color))
        }
        
        HStack {
            BarsGraphView(values: items)
                .frame(width: 120, height: 120)
            VStack(alignment: .leading) {
                ForEach(items) { item in
                    Text(item.title)
                }
            }
        }
    }
}

#Preview {
    AccountsBalancesView()
        .modelContainer(.preview)
}
