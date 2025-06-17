import Foundation
import SwiftData

@Model
class Account: ObservableObject {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String
    var icon: String?
    var currency: String
    
    @Relationship(deleteRule: .cascade, inverse: \Transaction.account)
    var transactions: [Transaction] = []
    
    @Transient
    var balance: Double {
        transactions.map { $0.operation == Transaction.Operation.transferOut.rawValue ? -$0.value : $0.value }.reduce(.zero, +)
    }
    
    var lastTransaction: Transaction? {
        transactions.sorted { $0.date < $1.date }.last
    }
    
    var balanceWithCurrency: String {
        balance.toCurrency(with: currency)
    }
    
    init(id: UUID, name: String, color: String, icon: String?, currency: String) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
        self.currency = currency
    }
    
    func toAccountOrCardData() -> AccountOrCardData {
        AccountOrCardData(
            id: self.id.uuidString,
            name: self.name,
            currency: self.currency,
            balance: self.balance,
            color: self.color,
            icon: self.icon,
            lastTransaction: nil)
    }
}
