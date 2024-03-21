import Foundation
import Combine

class AccountDetailsViewModel: ObservableObject {
    @Published var account: AccountModel?
    @Published var balance: Double?
    
    var cancellables: [AnyCancellable] = []
    
    required init(accountId: UUID, accountInteractor: AccountInteractorProtocol, transactionInteractor: TransactionInteractorProtocol) {
        accountInteractor.getAccount(with: accountId)
            .flatMap {
                self.account = $0
                return transactionInteractor.sumOfAllTransactions(of: $0)
            }
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: {
                self.balance = $0
            })
            .store(in: &cancellables)
    }
}
