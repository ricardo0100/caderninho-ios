import Foundation
import SwiftData

@Model
class Category: ObservableObject {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String
    var icon: String?
    
    @Relationship(deleteRule: .nullify, inverse: \Transaction.category)
    var transactions: [Transaction] = []
    
    init(id: UUID, name: String, color: String, icon: String?) {
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
    }
    
    func getExpensesTransactions(startDate: Date, endDate: Date, currency: String?) throws -> [Transaction] {
        let id = self.id
        let transferOut = Transaction.Operation.transferOut.rawValue
        let installments = Transaction.Operation.installments.rawValue
        
        let isCategory = #Expression<Transaction, Bool> { transaction in
            transaction.category?.id == id &&
            (transaction.operation == transferOut || transaction.operation == installments)
        }
        
        let predicate = #Predicate<Transaction> { transaction in
            isCategory.evaluate(transaction) &&
            transaction.date >= startDate &&
            transaction.date <= endDate
        }
        
        guard let context = modelContext else {
            throw ModelError.noModelContext
        }
        
        return try context.fetch(FetchDescriptor(predicate: predicate)).filter {
            $0.currency == currency
        }
    }
}
