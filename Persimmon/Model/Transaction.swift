import Foundation
import CoreLocation
import SwiftData

@Model
class Transaction: ObservableObject {
    @Attribute(.unique) var id: UUID
    
    @Relationship(deleteRule: .noAction, inverse: \Account.transactions)
    var account: Account?
    
    @Relationship(deleteRule: .noAction, inverse: \Category.transactions)
    var category: Category?
    
    @Relationship(deleteRule: .cascade)
    var installments: [Installment] = []
    
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
    
    init(id: UUID,
         name: String,
         value: Double,
         category: Category?,
         date: Date,
         place: Place?) {
        self.id = id
        self.name = name
        self.value = value
        self.category = category
        self.date = date
        self.type = .installments
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
    
    var currency: String? {
        type == .installments ? installments.first?.bill.card.currency : account?.currency
    }
    
    var accountOrCardName: String? {
        account?.name ?? installments.first?.bill.card.name
    }
    
    var accountOrCardColor: String? {
        account?.color ?? installments.first?.bill.card.color
    }

    enum TransactionType: Codable, CaseIterable, Identifiable {
        var id: Int { hashValue }
        
        case installments
        case `in`
        case out
        
        var text: String {
            switch self {
            case .installments: return "Installments"
            case .in: return "Transfer In"
            case .out: return "Transfer Out"
            }
        }
        
        var iconName: String {
            switch self {
            case .installments:
                return "creditcard"
            case .in:
                return "arrow.down.to.line.circle"
            case .out:
                return "arrow.up.to.line.circle"
            }
        }
    }
}
