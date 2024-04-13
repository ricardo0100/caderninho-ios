import Foundation

struct TransactionModel: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var value: Double
    var accountId: UUID
    var date: Date
    var type: TransactionType
    var place: PlaceModel?
}

enum TransactionType: String, CaseIterable, Identifiable {
    var id: Self { self }
    
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
        case .transferOut: return "Transfer Out"
        case .adjustment: return "Adjustment"
        }
    }
    
    var iconName: String {
        switch self {
        case .buyCredit:
            return "creditcard"
        case .buyDebit:
            return "banknote"
        case .transferIn:
            return "arrow.down.to.line.circle"
        case .transferOut:
            return "arrow.up.to.line.circle"
        case .adjustment:
            return "plus.forwardslash.minus"
        }
    }
}
