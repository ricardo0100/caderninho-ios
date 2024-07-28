import Foundation
import SwiftData

@Model class Account {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String
    var currency: String
    
    @Relationship(deleteRule: .cascade) var transactions: [Transaction] = []
    @Attribute(.ephemeral) var balance: Double {
        transactions.map { $0.value }.reduce(0, +)
    }
    
    init(id: UUID, name: String, color: String, currency: String) {
        self.id = id
        self.name = name
        self.color = color
        self.currency = currency
    }
}
