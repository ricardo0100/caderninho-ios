//
//  CategoriesListViewModel.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 01/06/25.
//

import SwiftUI
import SwiftData

extension CategoriesListView {
    
    class ViewModel: ObservableObject {
        struct CategoryItem: Identifiable {
            var id: ObjectIdentifier { category.id }
            let category: Category
            let total: Double
        }
        
        @Published var currency: String = "" {
            didSet {
                UserDefaults.standard.set(currency, forKey: "currency")
            }
        }
        
        @Published var currencyOptions: [String] = []
        @Published var isShowindEdit: Bool = false
        @Published var startDate: Date = .distantPast
        @Published var endDate: Date = .distantFuture
        @Published var items: [CategoryItem] = []
        
        var graphItems: [GraphItem] {
            let sum = items.reduce(0, { $0 + $1.total })
            
            return items.filter { $0.total > 0 }.map { item in
                let amount = String(format: "%.2f", Double(item.total / sum * 100))
                return GraphItem(title: "\(item.category.name) \(amount)%",
                                 value: item.total / sum,
                                 color: Color(hex: item.category.color))
            }
        }
        
        func didAppear(with context: ModelContext) {
            loadCategories(with: context)
        }
        
        func didChangeCurrency(with context: ModelContext) {
            loadCategories(with: context)
        }
        
        func didChangeDateRange(with context: ModelContext) {
            loadCategories(with: context)
        }
        
        func didTapAdd() {
            isShowindEdit = true
        }
        
        private func loadCategories(with modelContext: ModelContext) {
            do {
                currency = UserDefaults.standard.string(forKey: "currency") ?? ""
                
                var currencies = try modelContext.fetch(FetchDescriptor<Account>()).map { $0.currency }
                currencies += try modelContext.fetch(FetchDescriptor<CreditCard>()).map { $0.currency }
                currencyOptions = Array(Set(currencies))
                
                if !currencyOptions.contains(currency) {
                    currency = currencyOptions.first ?? ""
                }
                
                let categories = try modelContext.fetch(FetchDescriptor<Category>())
                items = try categories.map { category in
                    let startDate = self.startDate
                    let endDate = self.endDate
                    let predicate = #Predicate<Transaction> { transaction in
                        transaction.date >= startDate &&
                        transaction.date <= endDate
                    }
                    
                    let transactions = try modelContext.fetch(FetchDescriptor(predicate: predicate))
                        .filter {
                            $0.category == category &&
                            ($0.operation == .installments || $0.operation == .transferOut) &&
                            ($0.account?.currency == currency || $0.installments.first?.bill.card.currency == currency)
                        }
                    
                    return CategoryItem(
                        category: category,
                        total: transactions.reduce(Double(0), { $0 + $1.value })
                    )
                }
            } catch {
                items = []
            }
        }
    }
}
