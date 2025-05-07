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
    
    @Relationship(deleteRule: .cascade)
    var card: CreditCard
    
    @Relationship(deleteRule: .cascade)
    var installments: [Installment] = []
    
    var payed = false
    var dueDate: Date
    
    init(id: UUID, card: CreditCard, dueDate: Date) {
        self.id = id
        self.card = card
        self.dueDate = dueDate
    }
}
