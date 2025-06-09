import Foundation
import CoreLocation
import SwiftData
import SwiftUI

@Model
class Transaction: ObservableObject {
    @Attribute(.unique)
    var id: UUID
    
    var account: Account?
    var category: Category?
    var card: CreditCard?
    
    @Relationship(deleteRule: .nullify, inverse: \Installment.transaction)
    var installments: [Installment] = []
    
    var name: String
    var value: Double
    var date: Date
    var operation: Int
    var place: Place?
    
    init(
        name: String,
        date: Date,
        editOperation: EditOperation,
        category: Category?,
        place: Place?) {
            self.id = UUID()
            self.name = name
            self.date = date
            self.category = category
            self.place = place
            self.operation = editOperation.operation.rawValue
            
            switch editOperation {
            case .transferIn(let account, let value), .transferOut(account: let account, let value):
                self.card = nil
                self.account = account
                self.value = value
            case .installments(let card, let numberOfInstallments, let value):
                self.card = card
                self.value = value
                self.installments.forEach { modelContext?.delete($0) }
                self.installments = Self.createInstallments(
                    card: card,
                    transaction: self,
                    numberOfInstallments: numberOfInstallments,
                    date: date,
                    value: value)
            case .refund(_, _):
                fatalError()
            }
        }
    
    func update(
        name: String,
        date: Date,
        editOperation: EditOperation,
        category: Category?,
        place: Place?) {
            self.name = name
            self.date = date
            self.category = category
            self.place = place
            self.operation = editOperation.operation.rawValue

            switch editOperation {
            case .transferIn(let account, let value), .transferOut(account: let account, let value):
                self.card = nil
                self.account = account
                self.value = value
            case .installments(let card, let numberOfInstallments, let value):
                self.account = nil
                self.value = value
                self.installments.forEach { modelContext?.delete($0) }
                self.installments = Self.createInstallments(
                    card: card,
                    transaction: self,
                    numberOfInstallments: numberOfInstallments,
                    date: date,
                    value: value)
            case .refund(_, _):
                fatalError()
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
                let installment = Installment(id: UUID(),
                                   number: date.day < card.dueDay ? i + 1 : i,
                                   value: value / Double(numberOfInstallments))
                installment.bill = bill
                return installment
            }
        }
    
    var currency: String? {
        installments.first?.bill?.card?.currency ?? account?.currency
    }
    
    var accountOrCardName: String? {
        account?.name ?? installments.first?.bill?.card?.name
    }
    
    var accountOrCardColor: String? {
        account?.color ?? installments.first?.bill?.card?.color
    }
    
    var accountOrCardIcon: String? {
        account?.icon ?? installments.first?.bill?.card?.icon
    }
    
    var operationDetails: OperationDetails {
        switch Operation(rawValue: operation) {
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
        default:
            fatalError()
        }
    }
    
    enum Operation: Int, Codable, CaseIterable, Identifiable {
        case transferIn = 0
        case transferOut = 1
        case installments = 2
        case refund = 3
        
        var id: Int { hashValue }
        
        var text: LocalizedStringKey {
            switch self {
            case .transferOut:
                return "Transfer Out"
            case .transferIn:
                return "Transfer In"
            case .installments:
                return "Pay in installments"
            case .refund:
                return "Refund"
            }
        }
        
        var iconName: String {
            switch self {
            case .transferIn:
                return "arrowshape.down.circle"
            case .transferOut:
                return "arrowshape.up.circle"
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
        
        var icon: String {
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
    
    enum EditOperation: Identifiable {
        case transferIn(account: Account, value: Double)
        case transferOut(account: Account, value: Double)
        case installments(card: CreditCard, numberOfInstallments: Int, value: Double)
        case refund(bill: Bill, value: Double)
        
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
        
        var value: Double {
            switch self {
            case .transferIn(_, let value): return value
            case .transferOut(_, let value): return value
            case .installments(_, _, let value): return value
            case .refund(_, let value): return value
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
