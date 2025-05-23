//
//  AccountWidgetData.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 20/05/25.
//
import Foundation

struct TransactionData: Codable {
    let name: String
    let date: Date
    let value: String
    let category: CategoryData?
    let operationIcon: String
}

struct CategoryData: Codable {
    let name: String
    let color: String
    let icon: String?
}

struct AccountOrCardData: Codable {
    let id: String
    let name: String
    let currency: String
    let balance: Double
    let color: String
    let lastTransaction: TransactionData?
}
