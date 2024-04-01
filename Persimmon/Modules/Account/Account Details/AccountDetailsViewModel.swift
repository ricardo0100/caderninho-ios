import Foundation
import Combine

class AccountDetailsViewModel: ObservableObject {
    @Published var account: AccountModel?
    @Published var balance: Double = .zero
    @Published var transactions: [TransactionModel] = []
    @Published var isShowingEdit = false
    
    var cancellables: [AnyCancellable] = []
    
    required init(accountId: UUID, accountInteractor: AccountInteractorProtocol, transactionInteractor: TransactionInteractorProtocol) {
        let accountShare = accountInteractor.getAccount(with: accountId)
        
        accountShare.flatMap {
            self.account = $0
            return transactionInteractor.sumOfAllTransactions(of: $0)
        }
        .sink(receiveCompletion: { _ in }, receiveValue: {
            self.balance = $0
        })
        .store(in: &cancellables)
        
        accountShare.flatMap {
            transactionInteractor.allTransactions(of: $0)
        }
        .sink { _ in } receiveValue: { transactions in
            self.transactions = transactions
        }.store(in: &cancellables)
    }
    
    func didTapEdit() {
        isShowingEdit = true
    }
}
