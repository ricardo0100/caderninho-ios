//
//  TransactionData.swift
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
