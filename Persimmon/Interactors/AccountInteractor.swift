import Foundation
import Combine

protocol AccountInteractorProtocol {
    var accounts: AnyPublisher<[AccountModel], InteractorError> { get }
    func getAccount(with id: UUID) -> AnyPublisher<AccountModel, InteractorError>
    func fetchAccounts()
    func saveAccount(id: UUID?, name: String, color: String, currency: String) -> AnyPublisher<AccountModel, InteractorError>
}

class AccountInteractor: AccountInteractorProtocol {
    var accounts: AnyPublisher<[AccountModel], InteractorError>
    static let currentValue = CurrentValueSubject<[AccountModel], InteractorError>([])
    
    init() {
        accounts = Self.currentValue.eraseToAnyPublisher()
    }
    
    static let exampleAccounts = [
        AccountModel(name: "Maya Bank", color: NiceColor.red.rawValue, currency: "R$"),
        AccountModel(name: "Feijão Trust Me", color: NiceColor.orange2.rawValue, currency: "US$"),
        AccountModel(name: "Banco do Brasil", color: NiceColor.yellow2.rawValue, currency: "R$"),
        AccountModel(name: "Bankito de Cuba", color: NiceColor.green2.rawValue, currency: "R$"),
        AccountModel(name: "Maya Bank", color: NiceColor.red.rawValue, currency: "R$"),
        AccountModel(name: "Feijão Trust Me", color: NiceColor.orange2.rawValue, currency: "US$"),
        AccountModel(name: "Banco do Brasil", color: NiceColor.yellow2.rawValue, currency: "R$"),
        AccountModel(name: "Bankito de Cuba", color: NiceColor.green2.rawValue, currency: "R$"),
        AccountModel(name: "Maya Bank", color: NiceColor.red.rawValue, currency: "R$"),
        AccountModel(name: "Feijão Trust Me", color: NiceColor.orange2.rawValue, currency: "US$"),
        AccountModel(name: "Banco do Brasil", color: NiceColor.yellow2.rawValue, currency: "R$"),
        AccountModel(name: "Bankito de Cuba", color: NiceColor.green2.rawValue, currency: "R$"),
    ]
    
    func fetchAccounts() {
        Self.currentValue.value = Self.exampleAccounts
    }
    
    func getAccount(with id: UUID) -> AnyPublisher<AccountModel, InteractorError> {
        guard let account = Self.currentValue.value.first(where: { item in item.id == id }) else {
            let error = InteractorError.getAccountError(errorDescription: "Account with id: \(id) not found")
            return Fail<AccountModel, InteractorError>(error: error)
                .eraseToAnyPublisher()
        }
        return Just(account)
            .setFailureType(to: InteractorError.self)
            .eraseToAnyPublisher()
    }
    
    func saveAccount(id: UUID?, name: String, color: String, currency: String) -> AnyPublisher<AccountModel, InteractorError> {
        guard let id = id else {
            let newAccount = AccountModel(name: name, color: color, currency: currency)
            Self.currentValue.send(Self.currentValue.value + [newAccount])
            return Just(newAccount)
                .setFailureType(to: InteractorError.self)
                .eraseToAnyPublisher()
        }

        return getAccount(with: id)
            .flatMap { account in
                var updatedAccount = account
                updatedAccount.name = name
                updatedAccount.color = color
                updatedAccount.currency = currency
                Self.currentValue.send(Self.currentValue.value.map { $0.id == id ? updatedAccount : $0 })
                return Just(updatedAccount)
                    .setFailureType(to: InteractorError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
