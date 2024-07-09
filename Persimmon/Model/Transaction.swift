import Foundation
import CoreLocation
import SwiftData

@Model class Transaction {
    @Attribute(.unique) var id: UUID
    var name: String
    var value: Double
    @Relationship(deleteRule: .noAction, inverse: \Account.transactions) var account: Account
    var date: Date
    var type: TransactionType
    var place: PlaceModel?
    
    init(id: UUID, name: String, value: Double, account: Account, date: Date, type: TransactionType, place: PlaceModel?) {
        self.id = id
        self.name = name
        self.value = value
        self.account = account
        self.date = date
        self.type = type
        self.place = place
    }
    
    struct PlaceModel: Codable {
        var title: String
        var subtitle: String
        var latitude: CLLocationDegrees
        var longitude: CLLocationDegrees
    }
    
    enum TransactionType: String, Codable, CaseIterable {
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
}
