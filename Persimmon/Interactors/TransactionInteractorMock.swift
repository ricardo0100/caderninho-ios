import Foundation
import Combine

protocol TransactionInteractorProtocol {
    var transactions: AnyPublisher<[TransactionModel], InteractorError> { get }
    func getTransaction(with id: UUID) -> AnyPublisher<TransactionModel, InteractorError>
    func saveTransaction(id: UUID?, name: String, price: Double, account: AccountModel, type: TransactionType) -> AnyPublisher<TransactionModel, InteractorError>
    func allTransactions(of account: AccountModel) -> AnyPublisher<[TransactionModel], InteractorError>
    func sumOfAllTransactions(of account: AccountModel) -> AnyPublisher<Double, InteractorError>
    func deleteTransaction(transaction: TransactionModel) -> AnyPublisher<Void, InteractorError>
}

class TransactionInteractorMock: TransactionInteractorProtocol {
    var transactions: AnyPublisher<[TransactionModel], InteractorError>
    static let currentValue = CurrentValueSubject<Set<TransactionModel>, InteractorError>(Set(exampleTransactions))
    
    init() {
        transactions = Self.currentValue.map{ $0.sorted(by: { $0.name > $1.name }) }.eraseToAnyPublisher()
    }
    
    static let exampleTransactions = [
        TransactionModel(
            name: "T-shirt", price: 19.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Shoes", price: 49.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Jeans", price: 39.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Sunglasses", price: 29.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Backpack", price: 59.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Hoodie", price: 29.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Sweatpants", price: 34.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Jacket", price: 79.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Hat", price: 14.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            type: TransactionType.allCases.randomElement()!),
    ]
    
    func getTransaction(with id: UUID) -> AnyPublisher<TransactionModel, InteractorError> {
        guard let account = Self.currentValue.value.first(where: { item in item.id == id }) else {
            let error = InteractorError.getTransactionError(errorDescription: "Transaction with id: \(id) not found")
            return Fail<TransactionModel, InteractorError>(error: error)
                .eraseToAnyPublisher()
        }
        return Just(account)
            .setFailureType(to: InteractorError.self)
            .eraseToAnyPublisher()
    }
    
    func saveTransaction(id: UUID?, name: String, price: Double, account: AccountModel, type: TransactionType) -> AnyPublisher<TransactionModel, InteractorError> {
        Deferred {
            guard let id = id else {
                let newTransaction = TransactionModel(name: name, price: price, accountId: account.id, type: type)
                Self.currentValue.value.insert(newTransaction)
                return Just(newTransaction)
                    .setFailureType(to: InteractorError.self)
                    .eraseToAnyPublisher()
            }
            return self.getTransaction(with: id)
        }.flatMap { transaction in
            var updatedTransaction = transaction
            updatedTransaction.name = name
            updatedTransaction.price = price
            updatedTransaction.accountId = account.id
            updatedTransaction.type = type
            Self.currentValue.value.remove(transaction)
            Self.currentValue.value.insert(updatedTransaction)
            return Just(updatedTransaction)
                .setFailureType(to: InteractorError.self)
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func allTransactions(of account: AccountModel) -> AnyPublisher<[TransactionModel], InteractorError> {
        Self.currentValue
            .replaceError(with: [])
            .map {
                $0.filter { $0.accountId == account.id }
            }
            .setFailureType(to: InteractorError.self)
            .eraseToAnyPublisher()
    }
    
    func sumOfAllTransactions(of account: AccountModel) -> AnyPublisher<Double, InteractorError> {
        Self.currentValue
            .replaceError(with: [])
            .flatMap {
                return Just($0.filter { $0.accountId == account.id }
                    .map { $0.price }
                    .reduce(.zero, +))
            }
            .setFailureType(to: InteractorError.self)
            .eraseToAnyPublisher()
    }
    
    func deleteTransaction(transaction: TransactionModel) -> AnyPublisher<Void, InteractorError> {
        Deferred {
            if Self.currentValue.value.remove(transaction) == nil {
                return Fail<Void, InteractorError>(error: InteractorError.deleteTransactionsError(errorDescription: "")).eraseToAnyPublisher()
            } else {
                AccountInteractorMock.sendUpdateSignal()
                return Just(()).setFailureType(to: InteractorError.self).eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
    static func sendUpdateSignal() {
        currentValue.send(currentValue.value)
    }
}
