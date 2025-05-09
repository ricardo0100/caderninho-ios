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
    @Attribute(.unique) var id: UUID
    
    @Relationship(deleteRule: .cascade, inverse: \CreditCard.bills)
    var card: CreditCard
    
    @Relationship(deleteRule: .cascade)
    var installments: [Installment] = []
    
//    @Transient
//    var total: Double {
//        installments.
//    }
    
    var payed = false
    var month: Int
    var year: Int
    
    init(id: UUID, card: CreditCard, month: Int, year: Int) {
        self.id = id
        self.card = card
        self.month = month
        self.year = year
    }
}
