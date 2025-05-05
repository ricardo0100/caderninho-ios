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
    @Relationship(deleteRule: .noAction)
    var transaction: Transaction
    
    @Relationship(deleteRule: .noAction, inverse: \Bill.installments)
    var bill: Bill
    
    @Attribute(.unique)
    var id: UUID
    
    var date: Date
    var value: Double
    
    init(id: UUID, date: Date, transaction: Transaction, bill: Bill, value: Double) {
        self.id = id
        self.date = date
        self.transaction = transaction
        self.bill = bill
        self.value = value
    }
}
