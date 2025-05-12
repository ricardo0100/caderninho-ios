//
//  CreditCard.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 02/05/25.
//

import Foundation
import SwiftData

@Model
class CreditCard: ObservableObject {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String
    var currency: String
    var dueDay: Int
    var closingCycleDay: Int
    
    @Relationship(deleteRule: .cascade)
    var bills: [Bill] = []
    
    init(id: UUID, name: String, color: String, currency: String, closingCycleDay: Int, dueDay: Int,) {
        self.id = id
        self.name = name
        self.color = color
        self.currency = currency
        self.dueDay = dueDay
        self.closingCycleDay = closingCycleDay
    }
    
    var currentBill: Bill? {
        let nextMonthDate = Date().dateAddingMonths(1)
        let month = nextMonthDate.month
        let year = nextMonthDate.year
        return bills.first { $0.dueYear == year && $0.dueMonth == month } ?? bills.sorted().last { $0.payedDate == nil }
    }
    
    @Transient var totalDebit: Double {
        bills.filter { $0.payedDate == nil }.reduce(0) { $0 + $1.total }
    }
}
