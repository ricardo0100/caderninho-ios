//
//  AccountsDistributionGraphView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 16/06/25.
//

import SwiftUI
import SwiftData
import Charts

struct AccountsDistributionGraphView: View {
    @Query var accounts: [Account]
    
    var values: [GraphItem] {
        accounts.filter { $0.balance > .zero }.map {
            GraphItem(
                title: $0.name,
                value: $0.balance,
                color: Color(hex: $0.color))
        }
    }
    
    var total: Double {
        values.map { $0.value }.reduce(0, +)
    }
    
    var body: some View {
        Chart(values) { item in
            SectorMark(angle: .value(item.title, item.value),
                       angularInset: 0.5)
                .foregroundStyle(by: .value("Name", item.title))
                .annotation(position: .overlay, alignment: .center) {
                                    let percent = Int((item.value / total) * 100)
                                    Text("\(percent)%")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
        }
        .frame(height: 120)
        .chartLegend(position: .bottom)
    }
}
