import Foundation
import Combine

class TransactionDetailsViewModel: ObservableObject {
    @Published var transaction: TransactionModel?
    @Published var account: AccountModel?
    @Published var isShowingEdit = false
    
    var cancellables: [AnyCancellable] = []
    
    init(transactionId: UUID, transactionInteractor: TransactionInteractorProtocol, accountInteractor: AccountInteractorProtocol) {
        let transactionPublisher = transactionInteractor.getTransaction(with: transactionId)
        
        transactionPublisher
            .sink {
                if case .failure = $0 {
                    self.transaction = nil
                }
            } receiveValue: {
                self.transaction = $0
            }
            .store(in: &cancellables)
        
        transactionPublisher
            .flatMap {
                accountInteractor.getAccount(with: $0.accountId)
            }
            .sink {
                if case .failure = $0 {
                    self.account = nil
                }
            } receiveValue: {
                self.account = $0
            }.store(in: &cancellables)
    }
    
    func didTapEdit() {
        isShowingEdit = true
    }
}
