import Foundation

enum TransactionType: String, CaseIterable {
    case buyDebit
    case buyCredit
    case transferIn
    case transferOut
    case adjustment
    
    var text: String {
        switch self {
        case .buyDebit: return "Buy in Debit"
        case .buyCredit: return "Buy in Credit"
        case .transferIn: return "Transfer In"
        case .transferOut: return "Transfer out"
        case .adjustment: return "Adjustment"
        }
    }
}

struct TransactionModel: Identifiable {
    let id = UUID()
    var name: String
    var price: Double
    var account: AccountModel
    var type: TransactionType
    
    var currency: String {
        return "\(account.currency) \(price.formatted())"
    }
}
