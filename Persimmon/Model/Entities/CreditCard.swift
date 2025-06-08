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
    
    @Attribute(.unique)
    var id: UUID
    
    var name: String
    var color: String
    var icon: String?
    var currency: String
    var dueDay: Int
    var closingCycleDay: Int
    
    @Relationship(deleteRule: .cascade, inverse: \Bill.card)
    var bills: [Bill] = []
    
    init(id: UUID, name: String, color: String, icon: String?, currency: String, closingCycleDay: Int, dueDay: Int,) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
        self.currency = currency
        self.dueDay = dueDay
        self.closingCycleDay = closingCycleDay
    }
    
    var currentBill: Bill? {
        let today = Date().lastSecondOfDay()
        
        let billDate = closingCycleDay <= today.day ? today : Date().dateAddingMonths(1)
        let month = billDate.month
        let year = billDate.year
        
        return bills.first { $0.dueYear == year && $0.dueMonth == month } ??
            bills.sorted().last { $0.payedDate == nil }
    }
    
    @Transient var totalDebit: Double {
        bills.filter { $0.payedDate == nil }.map{ $0.total }.reduce(0, +)
    }
    
    var lastTransaction: Transaction? {
        nil
//        currentBill?.installments.sorted { $0.transaction?.date < $1.transaction?.date }.last?.transaction
    }
    
    func toAccountOrCardData() -> AccountOrCardData {
        AccountOrCardData(
            id: self.id.uuidString,
            name: self.name,
            currency: self.currency,
            balance: self.currentBill?.total ?? .zero,
            color: self.color,
            icon: self.icon,
            lastTransaction: nil)
    }
}
