import Foundation
import Combine

class EditTransactionViewModel: ObservableObject {
    @Published var name = ""
    @Published var type: TransactionType?
    @Published var datetime = ""
    @Published var location = ""
    @Published var selectedAccount: AccountModel?
    @Published var value: Double = 0
    @Published var shouldDismiss: Bool = false
    
    var transactionId: UUID? = nil
    var cancellables: [AnyCancellable] = []
    let transactionInteractor: TransactionInteractorProtocol
    
    init(transactionId: UUID,
         transactionInteractor: TransactionInteractorProtocol = TransactionInteractorMock(),
         accountInteractor: AccountInteractorProtocol = AccountInteractorMock()) {
        self.transactionInteractor = transactionInteractor
        self.transactionId = transactionId
        
        transactionInteractor.getTransaction(with: transactionId)
            .sink { _ in } receiveValue: { transaction in
                self.transactionId = transaction.id
                self.name = transaction.name
                self.type = transaction.type
                self.value = transaction.price
                self.datetime = "11/12/2013"
                self.location = "Florianópolis SC"
            }.store(in: &cancellables)
        
        transactionInteractor.getTransaction(with: transactionId)
            .flatMap {
                accountInteractor.getAccount(with: $0.accountId)
            }.sink { _ in } receiveValue: { account in
                self.selectedAccount = account
            }.store(in: &cancellables)
    }
    
    init(transactionInteractor: TransactionInteractorProtocol = TransactionInteractorMock(),
         accountInteractor: AccountInteractorProtocol = AccountInteractorMock()) {
        self.transactionInteractor = transactionInteractor
    }
    
    func didTapSave() {
        guard let selectedAccount = selectedAccount, let type = type else {
            return
        }
        transactionInteractor.saveTransaction(
            id: transactionId,
            name: name,
            price: value,
            account: selectedAccount,
            type: type
        ).sink { _ in } receiveValue: { _ in
            self.shouldDismiss = true
        }.store(in: &cancellables)
    }
}
