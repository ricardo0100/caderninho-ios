import Foundation

struct AccountItem: Identifiable {
    let id = UUID()
    let name: String
    let color: NiceColor
    let amount: Double
    let currency: String
}

protocol AccountsViewModelProtocol: ObservableObject {
    var accounts: [AccountItem] { get }
    func fetchAccounts()
}

class AccountsViewModelMock: AccountsViewModelProtocol {
    static let availableAccounts = [
        AccountItem(name: "Maya Bank", color: .red, amount: 345.19, currency: "R$"),
        AccountItem(name: "Feijão Trust Me", color: .gray, amount: 1982.87, currency: "US$"),
        AccountItem(name: "Banco do Brasil", color: .yellowGreen, amount: 121.87, currency: "R$"),
        AccountItem(name: "Bankito de Cuba", color: .blue, amount: 21.11, currency: "R$"),
    ]
    
    @Published var accounts: [AccountItem] = []

    init() {
        fetchAccounts()
    }

    func fetchAccounts() {
        accounts = Self.availableAccounts
    }
}
