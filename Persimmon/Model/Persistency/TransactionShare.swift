//
//  TransactionShare.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 21/12/24.
//

import SwiftData
import Foundation

@Model class TransactionShare: ObservableObject {
    @Relationship(deleteRule: .noAction)
    var transaction: Transaction
    
    @Attribute(.unique) var id: UUID
    
    var date: Date
    var value: Double
    
    init(id: UUID, date: Date, transaction: Transaction, value: Double) {
        self.id = id
        self.date = date
        self.transaction = transaction
        self.value = value
    }
}
