import Foundation
import SwiftData

@Model
class Account: ObservableObject {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String
    var icon: String?
    var currency: String
    
    @Relationship(deleteRule: .cascade)
    var transactions: [Transaction] = []
    
    @Transient
    var balance: Double {
        transactions.map { $0.operation == .transferOut ? -$0.value : $0.value }.reduce(.zero, +)
    }
    
    var lastTransaction: Transaction? {
        transactions.sorted(by: { $0.date > $1.date }).first
    }
    
    init(id: UUID, name: String, color: String, icon: String?, currency: String) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
        self.currency = currency
    }
}
