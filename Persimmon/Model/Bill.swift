//
//  Bill.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 02/05/25.
//

import SwiftData
import Foundation

@Model
class Bill: ObservableObject {
    @Attribute(.unique)
    var id: UUID
    
    @Relationship(deleteRule: .cascade)
    var card: CreditCard
    
    @Relationship(deleteRule: .cascade)
    var installments: [Installment] = []
    
    @Transient
    var total: Double {
        installments.map(\.value).reduce(0, +)
    }
    
    var payedDate: Date?
    var dueMonth: Int
    var dueYear: Int
    
    var isDelayed: Bool {
        guard payedDate == nil else { return false }
        var dueDateComponents = DateComponents()
        dueDateComponents.year = dueYear
        dueDateComponents.month = dueMonth
        dueDateComponents.day = card.dueDay

        guard let dueDate = Calendar.current.date(from: dueDateComponents) else {
            return false
        }
        
        let now = Date()
        var nowComponents = DateComponents()
        nowComponents.year = now.year
        nowComponents.month = now.month
        nowComponents.day = now.day
        
        guard let nowDate = Calendar.current.date(from: nowComponents) else {
            return false
        }
        
        return nowDate > dueDate
    }
    
    var closingCycleDate: Date {
        let components = DateComponents(year: dueYear, month: dueMonth, day: card.closingCycleDay)
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var dueDate: Date {
        let components = DateComponents(year: dueYear, month: dueMonth, day: card.dueDay)
        return Calendar.current.date(from: components) ?? Date()
    }
    
    init(id: UUID, card: CreditCard, month: Int, year: Int) {
        self.id = id
        self.card = card
        self.dueMonth = month
        self.dueYear = year
    }
}

extension Bill: Comparable {
    static func < (lhs: Bill, rhs: Bill) -> Bool {
        if lhs.dueYear != rhs.dueYear {
            return lhs.dueYear < rhs.dueYear
        } else {
            return lhs.dueMonth < rhs.dueMonth
        }
    }
}
