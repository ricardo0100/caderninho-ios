import Foundation

enum TransactionType: String, CaseIterable {
    case buyDebit, buyCredit, transferIn, transferOut, adjustment
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

struct Transaction: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let account: AccountItem
    let type: TransactionType
    
    var currency: String {
        return "\(account.currency) \(price.formatted())"
    }
}

protocol HomeViewModelProtocol: ObservableObject {
    var buys: [Transaction] { get }
    func fetchTransactions()
}

class HomeViewModelMock: HomeViewModelProtocol {
    @Published var buys: [Transaction] = []

    init() {
        fetchTransactions()
    }

    func fetchTransactions() {
        buys = [
            Transaction(
                name: "T-shirt", price: 19.99,
                account: AccountsViewModelMock.availableAccounts.randomElement()!,
                type: TransactionType.allCases.randomElement()!),
            Transaction(
                name: "Shoes", price: 49.99,
                account: AccountsViewModelMock.availableAccounts.randomElement()!,
                type: TransactionType.allCases.randomElement()!),
            Transaction(
                name: "Jeans", price: 39.99,
                account: AccountsViewModelMock.availableAccounts.randomElement()!,
                type: TransactionType.allCases.randomElement()!),
            Transaction(
                name: "Sunglasses", price: 29.99,
                account: AccountsViewModelMock.availableAccounts.randomElement()!,
                type: TransactionType.allCases.randomElement()!),
            Transaction(
                name: "Backpack", price: 59.99,
                account: AccountsViewModelMock.availableAccounts.randomElement()!,
                type: TransactionType.allCases.randomElement()!),
            Transaction(
                name: "Hoodie", price: 29.99,
                account: AccountsViewModelMock.availableAccounts.randomElement()!,
                type: TransactionType.allCases.randomElement()!),
            Transaction(
                name: "Sweatpants", price: 34.99,
                account: AccountsViewModelMock.availableAccounts.randomElement()!,
                type: TransactionType.allCases.randomElement()!),
            Transaction(
                name: "Jacket", price: 79.99,
                account: AccountsViewModelMock.availableAccounts.randomElement()!,
                type: TransactionType.allCases.randomElement()!),
            Transaction(
                name: "Hat", price: 14.99,
                account: AccountsViewModelMock.availableAccounts.randomElement()!,
                type: TransactionType.allCases.randomElement()!),
        ]
    }
}
