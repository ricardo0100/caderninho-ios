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
    var operation: Operation
    var place: Place?
    
    init(name: String,
         date: Date,
         value: Double,
         editOperation: EditOperation,
         category: Category?,
         place: Place?) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.category = category
        self.place = place
        self.value = value
        self.operation = editOperation.operation
        
        switch editOperation {
        case .transferIn(let account), .transferOut(account: let account):
            self.account = account
        case .installments(let card, let numberOfInstallments):
            self.installments.forEach { modelContext?.delete($0) }
            self.installments = Self.createInstallments(
                card: card,
                transaction: self,
                numberOfInstallments: numberOfInstallments,
                date: date,
                value: value)
        case .refund(_):
            fatalError()
        }
    }
    
    func update(
        name: String,
        date: Date,
        value: Double,
        editOperation: EditOperation,
        category: Category?,
        place: Place?) {
            self.id = UUID()
            self.name = name
            self.date = date
            self.category = category
            self.place = place
            self.operation = editOperation.operation
            self.value = value
            
            switch editOperation {
            case .transferIn(let account):
                self.account = account
            case .transferOut(account: let account):
                self.account = account
            case .installments(let card, let numberOfInstallments):
                self.installments.forEach { modelContext?.delete($0) }
                self.installments = Self.createInstallments(
                    card: card,
                    transaction: self,
                    numberOfInstallments: numberOfInstallments,
                    date: date,
                    value: value)
            case .refund(_):
                break
            }
        }
    
    static private func createInstallments(
        card: CreditCard,
        transaction: Transaction,
        numberOfInstallments: Int,
        date: Date,
        value: Double) -> [Installment] {
            let date = date
            var monthsRange = (1...numberOfInstallments)
            if date.day < card.dueDay {
                monthsRange = (0...numberOfInstallments - 1)
            }
            return monthsRange.map { i in
                let month = Calendar.current.component(.month, from: date.dateAddingMonths(i))
                let year = Calendar.current.component(.year, from: date.dateAddingMonths(i))
                
                let bill = card.bills.first { $0.dueYear == year && $0.dueMonth == month } ??
                    .init(id: UUID(), card: card, month: month, year: year)
                
                return Installment(id: UUID(),
                                   transaction: transaction,
                                   number: date.day < card.dueDay ? i + 1 : i,
                                   bill: bill,
                                   value: value / Double(numberOfInstallments))
            }
        }
    
    var currency: String? {
        installments.first?.bill.card.currency ?? account?.currency
    }
    
    var accountOrCardName: String? {
        account?.name ?? installments.first?.bill.card.name
    }
    
    var accountOrCardColor: String? {
        account?.color ?? installments.first?.bill.card.color
    }
    
    var operationDetails: OperationDetails {
        switch operation {
        case .transferIn:
            guard let account = account else { fatalError() }
            return .transferIn(account: account, value: value.toCurrency(with: account.currency))
        case .transferOut:
            guard let account = account else { fatalError() }
            return .transferOut(account: account, value: value.toCurrency(with: account.currency))
        case .installments:
            return .installments(installments: installments)
        case .refund:
            fatalError()
        }
    }
    
    enum Operation: Codable, CaseIterable, Identifiable {
        case transferIn
        case transferOut
        case installments
        case refund
        
        var id: Int { hashValue }
        
        var text: String {
            switch self {
            case .transferOut:
                return "Transfer Out"
            case .transferIn:
                return "Transfer In"
            case .installments:
                return "Installments"
            case .refund:
                return "Refund"
            }
        }
        
        var iconName: String {
            switch self {
            case .transferIn:
                return "arrowshape.down.circle"
            case .transferOut:
                return "banknote"
            case .installments:
                return "creditcard"
            case .refund:
                return "creditcard.trianglebadge.exclamationmark"
            }
        }
    }
    
    enum OperationDetails {
        case transferIn(account: Account, value: String)
        case transferOut(account: Account, value: String)
        case installments(installments: [Installment])
        case refund(bill: Bill, value: String)
    }
    
    enum EditOperation: Identifiable {
        case transferIn(account: Account)
        case transferOut(account: Account)
        case installments(card: CreditCard, numberOfInstallments: Int)
        case refund(bill: Bill)
        
        var id: Int {
            switch self {
            case .transferIn: return 0
            case .transferOut: return 1
            case .installments: return 2
            case .refund: return 3
            }
        }
        
        var operation: Operation {
            switch self {
            case .transferIn:
                return .transferIn
            case .transferOut:
                return .transferOut
            case .installments:
                return .installments
            case .refund:
                return .refund
            }
        }
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
}
