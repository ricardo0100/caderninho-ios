//
//  AccountOrCardData.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 23/05/25.
//

struct AccountOrCardData: Codable {
    let id: String
    let name: String
    let currency: String
    let balance: Double
    let color: String
    let icon: String?
    let lastTransaction: TransactionData?
    
    var balanceString: String {
        balance.toCurrency(with: currency)
    }
}
