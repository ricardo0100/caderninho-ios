//
//  Navigation.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 07/06/25.
//

import SwiftUI

class NavigationModel: ObservableObject {
    static let shared = NavigationModel()
    
    enum Tabs {
        case transactions, categories, accountsAndCards
    }
    
    @Published var selectedTab: Tabs = .transactions
    
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
    
    func presentAccount(_ account: Account) {
        selectedTab = .accountsAndCards
        if !accountsPath.isEmpty {
            accountsPath.removeLast()
        }
        accountsPath.append(account)
    }
    
    func presentCard(_ card: CreditCard) {
        selectedTab = .accountsAndCards
        if !accountsPath.isEmpty {
            accountsPath.removeLast()
        }
        accountsPath.append(card)
    }
    
    func dismissDeletedTransaction() {
        editingTransaction = nil
        switch selectedTab {
        case .transactions:
            transactionsPath.removeLast()
        case .categories:
            categoriesPath.removeLast()
        case .accountsAndCards:
            accountsPath.removeLast()
        }
    }
}
