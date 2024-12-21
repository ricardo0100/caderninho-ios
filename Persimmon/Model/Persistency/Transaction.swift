import Foundation
import CoreLocation
import SwiftData

@Model class Transaction: ObservableObject {
    @Attribute(.unique) var id: UUID
    
    @Relationship(deleteRule: .noAction, inverse: \Account.transactions)
    var account: Account

    @Relationship(deleteRule: .noAction, inverse: \Category.transactions)
    var category: Category?
    
    var name: String
    var value: Double
    var date: Date
    var type: TransactionType
    var place: Place?
    
    init(id: UUID,
         name: String,
         value: Double,
         account: Account,
         category: Category?,
         date: Date,
         type: TransactionType,
         place: Place?) {
        self.id = id
        self.name = name
        self.value = value
        self.account = account
        self.category = category
        self.date = date
        self.type = type
        self.place = place
    }
    
    struct Place: Codable, Identifiable, Hashable {
        var id: Int {
            hashValue
        }
        var name: String?
        var title: String?
        var subtitle: String?
        var latitude: CLLocationDegrees?
        var longitude: CLLocationDegrees?
        
        var location: CLLocation? {
            guard let latitude = latitude, let longitude = longitude else { return nil }
            return CLLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    enum TransactionType: String, Codable, CaseIterable, Identifiable {
        var id: Int { hashValue }
        
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
