//
//  CategoryExpensesView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 21/12/24.
//


import SwiftUI
import SwiftData

struct CategoryExpensesView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query var categories: [Category]
    
    var body: some View {
        let categoryItems = categories.map {
            let value = $0.expensesSum(for: "R$")
            let titleStr = "**\($0.name)** \(value.toCurrency(with: "R$"))"
            let title = try! AttributedString(markdown: titleStr)
            return GraphItem(title: title, value: value, color: Color(hex: $0.color))
        }
        HStack {
            PizzaGraphView(values: categoryItems)
                .frame(width: 120, height: 120)
            VStack(alignment: .leading) {
                ForEach(categoryItems) { item in
                    Text(item.title)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    CategoryExpensesView()
        .modelContainer(DataController.previewContainer)
}
