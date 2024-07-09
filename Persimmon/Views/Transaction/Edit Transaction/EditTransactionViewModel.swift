//import Foundation
//import Combine
//import MapKit
//
//class EditTransactionViewModel: ObservableObject {
//    @Published var name = ""
//    @Published var nameError: String?
//    @Published var type: TransactionType = .buyCredit
//    @Published var date = Date()
//    @Published var place: PlaceModel?
//    @Published var selectedAccount: AccountModel?
//    @Published var accountError: String?
//    @Published var value: Double = 0
//    @Published var shouldDismiss: Bool = false
//    
//    var transactionId: UUID? = nil
//    var cancellables: [AnyCancellable] = []
//    let transactionInteractor = TransactionInteractorFactory.newInstance()
//    
//    init(transactionId: UUID? = nil) {
//        self.transactionId = transactionId
//        
////        transactionInteractor.getTransaction(with: transactionId)
////            .flatMap { transaction in
////                self.transactionId = transaction.id
////                self.name = transaction.name
////                self.type = transaction.type
////                self.value = transaction.value
////                self.date = transaction.date
////                self.place = transaction.place
////                return Just(transaction)
////            }
////            .flatMap { transaction in
////                accountInteractor.getAccount(with: transaction.accountId)
////            }
////            .sink(receiveCompletion: { _ in }, receiveValue: { account in
////                self.selectedAccount = account
////            })
////            .store(in: &cancellables)
//    }
//    
//    func didAppear() {
//        clearErrors()
//    }
//    
//    func didTapSave() {
//        clearErrors()
//        guard name.count > .zero else {
//            nameError = "Give this a name"
//            return
//        }
//        guard let selectedAccount = selectedAccount else {
//            accountError = "Choone an account"
//            return
//        }
//        transactionInteractor.save(
//            id: transactionId,
//            name: name,
//            price: value,
//            accountId: selectedAccount.id,
//            date: date,
//            type: type,
//            place: place
//        ).sink { _ in } receiveValue: { _ in
//            self.shouldDismiss = true
//        }.store(in: &cancellables)
//    }
//    
//    func didTapCancel() {
//        shouldDismiss = true
//    }
//    
//    private func clearErrors() {
//        nameError = nil
//        accountError = nil
//    }
//}
