import Foundation
import Combine

protocol AccountInteractorProtocol {
    var accounts: AnyPublisher<[AccountModel], InteractorError> { get }
    func getAccount(with id: UUID) -> AnyPublisher<AccountModel, InteractorError>
    func saveAccount(id: UUID?, name: String, color: String, currency: String) -> AnyPublisher<AccountModel, InteractorError>
    func deleteAccount(account: AccountModel) -> AnyPublisher<Void, InteractorError>
}

class AccountInteractor: AccountInteractorProtocol {
    var accounts: AnyPublisher<[AccountModel], InteractorError>
    private static let sharedAccountsSubject = CurrentValueSubject<Set<AccountModel>, InteractorError>(Set(exampleAccounts))
    
    init() {
        accounts = Self.sharedAccountsSubject.map{ $0.sorted(by: { $0.name > $1.name }) }.eraseToAnyPublisher()
    }
    
    static let exampleAccounts = [
        AccountModel(name: "Maya Bank", color: NiceColor.red.rawValue, currency: "R$"),
        AccountModel(name: "Feijão Trust Me", color: NiceColor.orange2.rawValue, currency: "US$"),
        AccountModel(name: "Banco do Brasil", color: NiceColor.yellow2.rawValue, currency: "R$"),
        AccountModel(name: "Bankito de Cuba", color: NiceColor.green2.rawValue, currency: "R$"),
    ]
    
    func getAccount(with id: UUID) -> AnyPublisher<AccountModel, InteractorError> {
        guard let account = Self.sharedAccountsSubject.value.first(where: { item in item.id == id }) else {
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
            Self.sharedAccountsSubject.value.insert(newAccount)
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
                Self.sharedAccountsSubject.value.remove(account)
                Self.sharedAccountsSubject.value.insert(updatedAccount)
                return Just(updatedAccount)
                    .setFailureType(to: InteractorError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func deleteAccount(account: AccountModel) -> AnyPublisher<Void, InteractorError> {
        Deferred {
            if Self.sharedAccountsSubject.value.remove(account) == nil {
                return Fail<Void, InteractorError>(error: InteractorError.deleteAccountError(errorDescription: "")).eraseToAnyPublisher()
            } else {
                return Just(()).setFailureType(to: InteractorError.self).eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
}
