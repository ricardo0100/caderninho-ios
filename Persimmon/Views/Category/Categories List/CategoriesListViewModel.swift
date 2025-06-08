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
        @Published var currency: String? {
            didSet {
                UserDefaults.standard.set(currency, forKey: "currency")
            }
        }
        
        @Published var currencyOptions: [String] = []
        @Published var startDate: Date = .distantPast
        @Published var endDate: Date = .distantFuture
        
        init() {
            currency = UserDefaults.standard.string(forKey: "currency")
        }
    }
}
