//
//  AccountsDistributionGraphView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 16/06/25.
//

import SwiftUI
import SwiftData

struct AccountsDistributionGraphView: View {
    @Query var accounts: [Account]
    
    func values() -> [GraphItem] {
        accounts.filter { $0.balance > .zero }.map {
            GraphItem(
                title: $0.name,
                value: $0.balance,
                color: Color(hex: $0.color))
        }
    }
    
    var body: some View {
        PizzaGraphView(values: values())
    }
}
