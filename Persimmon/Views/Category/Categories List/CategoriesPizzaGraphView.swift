//
//  CategoriesPizzaGraphView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 07/06/25.
//
import SwiftUI
import SwiftData
import Charts

struct CategoriesPizzaGraphView: View {
    @Query var categories: [Category]
    
    let startDate: Date
    let endDate: Date
    let currency: String?
    
    init(startDate: Date, endDate: Date, currency: String?) {
        self.startDate = startDate
        self.endDate = endDate
        self.currency = currency
    }
    
    func getSum() -> Double {
        do {
            return try categories.reduce(Double.zero) { total, category in
                let transactions = try category.getExpensesTransactions(
                    startDate: startDate,
                    endDate: endDate,
                    currency: currency
                )
                let categorySum = transactions.reduce(Double.zero) { $0 + $1.value }
                return total + categorySum
            }
        } catch {
            return .zero
        }
    }
    
    func getItems() -> [GraphItem] {
        let sum = getSum()
        guard sum > .zero else {
            return []
        }
        do {
            return try categories.map { category in
                let value = try category.getExpensesTransactions(
                    startDate: startDate,
                    endDate: endDate,
                    currency: currency).reduce(Double.zero) { $0 + $1.value } / sum
                return GraphItem(
                    title: category.name,
                    value: value,
                    color: Color(hex: category.color))
            }
        } catch {
            return []
        }
    }
    
    var body: some View {
        let items = getItems()
        if items.isEmpty {
            Text("No expenses for this period")
                .frame(maxWidth: .infinity)
                .foregroundStyle(.secondary)
        } else {
            Chart(items.filter { $0.value > .zero }) { item in
                SectorMark(angle: .value(item.title, item.value),
                           angularInset: 0.5)
                    .foregroundStyle(by: .value("Name", item.title))
            }
            .frame(height: 120)
            .chartLegend(position: .bottom)
        }
    }
}

#Preview {
    List {
        Section {
            CategoriesPizzaGraphView(
                startDate: .distantPast,
                endDate: .distantFuture,
                currency: "R$")
        }
    }
    .modelContext(.preview)
}
