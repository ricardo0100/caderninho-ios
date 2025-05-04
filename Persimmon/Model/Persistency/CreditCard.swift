//
//  CreditCard.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 02/05/25.
//

import Foundation
import SwiftData

@Model class CreditCard: ObservableObject {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String
    var currency: String
    var dueDay: Int
    
    @Relationship(deleteRule: .cascade)
    var bills: [Bill] = []
    
    init(id: UUID, name: String, color: String, currency: String, dueDay: Int) {
        self.id = id
        self.name = name
        self.color = color
        self.currency = currency
        self.dueDay = dueDay
    }
}
