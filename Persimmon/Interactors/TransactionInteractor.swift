import Foundation
import Combine

protocol TransactionInteractorProtocol {
    var transactions: AnyPublisher<[TransactionModel], InteractorError> { get }
    func getTransaction(with id: UUID) -> AnyPublisher<TransactionModel, InteractorError>
    func fetchTransactions()
    func saveTransaction(id: UUID?, name: String, price: Double, account: AccountModel, type: TransactionType) -> AnyPublisher<TransactionModel, InteractorError>
}

class TransactionInteractor: TransactionInteractorProtocol {
    var transactions: AnyPublisher<[TransactionModel], InteractorError>
    static let currentValue = CurrentValueSubject<[TransactionModel], InteractorError>([])
    
    init() {
        transactions = Self.currentValue.eraseToAnyPublisher()
    }
    
    static let exampleTransactions = [
        TransactionModel(
            name: "T-shirt", price: 19.99,
            account: AccountInteractor.exampleAccounts.randomElement()!,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Shoes", price: 49.99,
            account: AccountInteractor.exampleAccounts.randomElement()!,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Jeans", price: 39.99,
            account: AccountInteractor.exampleAccounts.randomElement()!,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Sunglasses", price: 29.99,
            account: AccountInteractor.exampleAccounts.randomElement()!,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Backpack", price: 59.99,
            account: AccountInteractor.exampleAccounts.randomElement()!,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Hoodie", price: 29.99,
            account: AccountInteractor.exampleAccounts.randomElement()!,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Sweatpants", price: 34.99,
            account: AccountInteractor.exampleAccounts.randomElement()!,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Jacket", price: 79.99,
            account: AccountInteractor.exampleAccounts.randomElement()!,
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Hat", price: 14.99,
            account: AccountInteractor.exampleAccounts.randomElement()!,
            type: TransactionType.allCases.randomElement()!),
    ]
    
    func fetchTransactions() {
        Self.currentValue.value = Self.exampleTransactions
    }
    
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
        guard let id = id else {
            let newTransaction = TransactionModel(name: name, price: price, account: account, type: type)
            Self.currentValue.send(Self.currentValue.value + [newTransaction])
            return Just(newTransaction)
                .setFailureType(to: InteractorError.self)
                .eraseToAnyPublisher()
        }

        return getTransaction(with: id)
            .flatMap { transaction in
                var updatedTransaction = transaction
                updatedTransaction.name = name
                updatedTransaction.price = price
                updatedTransaction.account = account
                updatedTransaction.type = type
                Self.currentValue.send(Self.currentValue.value.map { $0.id == id ? updatedTransaction : $0 })
                return Just(updatedTransaction)
                    .setFailureType(to: InteractorError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
