import Foundation
import SwiftData

@Model class Category: ObservableObject {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String
    var icon: String?
    
    @Relationship(deleteRule: .nullify)
    var transactions: [Transaction] = []
    
    func expensesSum(for currency: String) -> Double {
        transactions
            .filter { $0.value > .zero && $0.account.currency == currency }
            .map { $0.value }
            .reduce(.zero, +)
    }
    
    init(id: UUID, name: String, color: String, icon: String?) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
    }
}
