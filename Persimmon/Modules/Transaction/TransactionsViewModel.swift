import Foundation
import Combine

protocol HomeViewModelProtocol: ObservableObject {
    var buys: [TransactionModel] { get }
    func didAppear()
}

class HomeViewModelMock: HomeViewModelProtocol {
    @Published var buys: [TransactionModel] = []
    let interactor: TransactionInteractorProtocol
    var cancellables: [AnyCancellable] = []
    
    init(interactor: TransactionInteractor = .init()) {
        self.interactor = interactor
        interactor.transactions
            .replaceError(with: [])
            .assign(to: \.buys, on: self)
            .store(in: &cancellables)
    }

    func didAppear() {
        interactor.fetchTransactions()
    }
}
