import Foundation
import Combine

protocol TransactionInteractorProtocol {
    var transactions: AnyPublisher<[TransactionModel], InteractorError> { get }
    func getTransaction(with id: UUID) -> AnyPublisher<TransactionModel, InteractorError>
    func saveTransaction(
        id: UUID?,
        name: String,
        price: Double,
        account: AccountModel,
        date: Date,
        type: TransactionType,
        place: PlaceModel?) -> AnyPublisher<TransactionModel, InteractorError>
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
            name: "T-shirt", value: 19.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            date: Date(),
            type: TransactionType.allCases.randomElement()!,
            place: PlaceModel(title: "Restaurante Big Star", subtitle: "Anita Garibaldi - SC", latitude: -27.686319, longitude: -51.131922)),
        TransactionModel(
            name: "Shoes", value: 49.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            date: Date(),
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Jeans", value: 39.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            date: Date(),
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Sunglasses", value: 29.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            date: Date(),
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Backpack", value: 59.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            date: Date(),
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Hoodie", value: 29.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            date: Date(),
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Sweatpants", value: 34.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            date: Date(),
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Jacket", value: 79.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            date: Date(),
            type: TransactionType.allCases.randomElement()!),
        TransactionModel(
            name: "Hat", value: 14.99,
            accountId: AccountInteractorMock.exampleAccounts.randomElement()!.id,
            date: Date(),
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
    
    func saveTransaction(
        id: UUID?,
        name: String,
        price: Double,
        account: AccountModel,
        date: Date,
        type: TransactionType,
        place: PlaceModel?) -> AnyPublisher<TransactionModel, InteractorError> {
            guard let id = id else {
                let newTransaction = TransactionModel(
                    name: name,
                    value: price,
                    accountId: account.id,
                    date: date,
                    type: type,
                    place: place)
                Self.currentValue.value.insert(newTransaction)
                return Just(newTransaction)
                    .setFailureType(to: InteractorError.self)
                    .eraseToAnyPublisher()
            }
            return self.getTransaction(with: id)
                .flatMap { transaction in
                    var updatedTransaction = transaction
                    updatedTransaction.name = name
                    updatedTransaction.value = price
                    updatedTransaction.accountId = account.id
                    updatedTransaction.type = type
                    updatedTransaction.date = date
                    updatedTransaction.place = place
                    Self.currentValue.value.remove(transaction)
                    Self.currentValue.value.insert(updatedTransaction)
                    return Just(updatedTransaction)
                        .setFailureType(to: InteractorError.self)
                }.eraseToAnyPublisher()
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
                    .map { $0.value }
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
