import Foundation
import Combine

protocol AccountInteractorProtocol {
    var accounts: AnyPublisher<[AccountModel], InteractorError> { get }
    func getAccount(with id: UUID) -> AnyPublisher<AccountModel, InteractorError>
    func saveAccount(id: UUID?, name: String, color: String, currency: String) -> AnyPublisher<AccountModel, InteractorError>
    func deleteAccount(account: AccountModel) -> AnyPublisher<Void, InteractorError>
}

class AccountInteractorMock: AccountInteractorProtocol {
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
        Self.sharedAccountsSubject.map { accounts in
            accounts.first { $0.id == id}
        }
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }
    
    func saveAccount(id: UUID?, name: String, color: String, currency: String) -> AnyPublisher<AccountModel, InteractorError> {
        Deferred {
            var updatingAccount: AccountModel
            if let id = id, let account = Self.sharedAccountsSubject.value.first(where: { $0.id == id }) {
                updatingAccount = account
                updatingAccount.name = name
                updatingAccount.color = color
                updatingAccount.currency = currency
                var accounts = Self.sharedAccountsSubject.value
                accounts.remove(account)
                accounts.insert(updatingAccount)
                Self.sharedAccountsSubject.send(accounts)
                TransactionInteractorMock.sendUpdateSignal()
            } else {
                updatingAccount = AccountModel(name: name, color: color, currency: currency)
            }
            
            return Just(updatingAccount)
        }
        .setFailureType(to: InteractorError.self)
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
    
    static func sendUpdateSignal() {
        sharedAccountsSubject.send(sharedAccountsSubject.value)
    }
}
