//
//  Navigation.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 07/06/25.
//

import SwiftUI

class NavigationModel: ObservableObject {
    static let shared = NavigationModel()
    
    @Published var selectedTab = 0
    
    // Transactions
    @Published var transactionsPath = NavigationPath()
    @Published var editingTransaction: Transaction?
    @Published var newTransaction = false

    // Categories
    @Published var categoriesPath = NavigationPath()
    @Published var editingCategory: Category?
    @Published var newCategory = false

    // Accounts and Cards
    @Published var accountsPath = NavigationPath()
    @Published var editingAccount: Account?
    @Published var newAccount = false
    @Published var editingCard: CreditCard?
    @Published var newCard = false
}
