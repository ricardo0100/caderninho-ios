//import Foundation
//import Combine
//import MapKit
//
//class TransactionDetailsViewModel: ObservableObject {
//    @Published var transaction: TransactionModel?
//    @Published var account: AccountModel?
//    @Published var isShowingEdit = false
//    @Published var region: MKCoordinateRegion = .init()
//    
//    var cancellables: [AnyCancellable] = []
//    
//    init(transactionId: UUID) {
////        let transactionPublisher = transactionInteractor.getTransaction(with: transactionId)
////        
////        transactionPublisher
////            .sink {
////                if case .failure = $0 {
////                    self.transaction = nil
////                }
////            } receiveValue: {
////                self.transaction = $0
////                if let place = $0.place {
////                    self.region = .init(
////                        center: .init(latitude: place.latitude, longitude: place.longitude),
////                        latitudinalMeters: 50,
////                        longitudinalMeters: 50)
////                }
////            }
////            .store(in: &cancellables)
//        
////        transactionPublisher
////            .flatMap {
////                accountInteractor.getAccount(with: $0.accountId)
////            }
////            .sink {
////                if case .failure = $0 {
////                    self.account = nil
////                }
////            } receiveValue: {
////                self.account = $0
////            }.store(in: &cancellables)
//    }
//    
//    func didTapEdit() {
//        isShowingEdit = true
//    }
//}
