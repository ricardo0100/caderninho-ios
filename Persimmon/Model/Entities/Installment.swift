//
//  TransactionShare.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 21/12/24.
//

import SwiftData
import Foundation

@Model
class Installment: ObservableObject {
    @Attribute(.unique)
    var id: UUID
    
    @Relationship(deleteRule: .noAction)
    var transaction: Transaction
    
    @Relationship(deleteRule: .noAction, inverse: \Bill.installments)
    var bill: Bill
    
    var number: Int
    
    var value: Double
    
    init(id: UUID, transaction: Transaction, number: Int, bill: Bill, value: Double) {
        self.id = id
        self.transaction = transaction
        self.number = number
        self.bill = bill
        self.value = value
    }
    
    var currencyValue: String {
        value.toCurrency(with: bill.card.currency)
    }
}

extension Installment: Comparable {
    static func < (lhs: Installment, rhs: Installment) -> Bool {
        lhs.number < rhs.number
    }
}
