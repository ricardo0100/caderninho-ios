//
//  Navigation.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 07/06/25.
//

import SwiftUI

class TransactionsNavigation: ObservableObject {
    @Published var path = NavigationPath()
    @Published var editingTransaction: Transaction?
    @Published var newTransaction = false
}

class CategoriesNavigation: ObservableObject {
    @Published var path = NavigationPath()
    @Published var editingCategory: Category?
    @Published var newCategory = false
}
