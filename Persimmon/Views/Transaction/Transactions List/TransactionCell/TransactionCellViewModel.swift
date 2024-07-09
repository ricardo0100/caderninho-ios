//import Foundation
//import Combine
//
//class TransactionCellViewModel: ObservableObject {
//    @Published var account: AccountModel?
//    @Published var transaction: TransactionModel?
//    
//    var cancellables: [AnyCancellable] = []
//
//    init(transactionId: UUID) {
//        TransactionInteractorFactory.newInstance()
//            .fetchedObjects
//            .map { $0.first }
//            .sink { _ in
//                
//            } receiveValue: {
//                self.transaction = $0
//                AccountInteractorFactory.newInstance(accountID: $0?.accountId)
//                    .fetchedObjects
//                    .map { $0.first }
//                    .sink(receiveCompletion: { _ in },
//                          receiveValue: { account in
//                        self.account = account
//                    })
//                    .store(in: &self.cancellables)
//            }.store(in: &cancellables)
//    }
//}
