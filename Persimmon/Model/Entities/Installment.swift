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
    
    var transaction: Transaction?
    var bill: Bill?
    
    var number: Int
    
    var value: Double
    
    init(id: UUID, number: Int, value: Double) {
        self.id = id
        self.number = number
        self.value = value
    }
    
    var currencyValue: String {
        value.toCurrency(with: bill?.card?.currency ?? "")
    }
}

extension Installment: Comparable {
    static func < (lhs: Installment, rhs: Installment) -> Bool {
        lhs.number < rhs.number
    }
}
