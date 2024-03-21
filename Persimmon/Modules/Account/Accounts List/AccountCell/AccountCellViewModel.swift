import Foundation
import Combine

class AccountCellViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var balance: Double = .zero
    @Published var currency: String = ""
    @Published var color: String = ""
    
    var cancellables: [AnyCancellable] = []
    
    init(accountId: UUID,
         accountInteractor: AccountInteractorProtocol,
         transactionInteractor: TransactionInteractorProtocol) {
        accountInteractor
            .getAccount(with: accountId)
            .flatMap { account in
                self.name = account.name
                self.color = account.color
                self.currency = account.currency
                return transactionInteractor.sumOfAllTransactions(of: account)
            }.sink { completion in
            } receiveValue: { balance in
                self.balance = balance
            }.store(in: &cancellables)
    }
}
