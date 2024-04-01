import Foundation
import Combine

class TransactionCellViewModel: ObservableObject {
    @Published var account: AccountModel?
    @Published var transaction: TransactionModel?
    
    var cancellables: [AnyCancellable] = []
    
    init(transactionId: UUID, transactionInteractor: TransactionInteractorProtocol, accountInteractor: AccountInteractorProtocol) {
        transactionInteractor.getTransaction(with: transactionId)
            .map {
                self.transaction = $0
                return $0
            }
            .compactMap { $0 }
            .flatMap { accountInteractor.getAccount(with: $0.accountId) }
            .sink { _ in } receiveValue: {
                self.account = $0
            }
            .store(in: &cancellables)
    }
}
