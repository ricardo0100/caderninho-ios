import Foundation
import Combine

protocol HomeViewModelProtocol: ObservableObject {
    var buys: [TransactionModel] { get }
}

class HomeViewModelMock: HomeViewModelProtocol {
    @Published var buys: [TransactionModel] = []
    let interactor: TransactionInteractorProtocol
    var cancellables: [AnyCancellable] = []
    
    init(interactor: TransactionInteractorMock = .init()) {
        self.interactor = interactor
        interactor.transactions
            .replaceError(with: [])
            .assign(to: \.buys, on: self)
            .store(in: &cancellables)
    }
}
