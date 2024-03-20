import Foundation
import Combine

protocol AccountsViewModelProtocol: ObservableObject {
    init(accountsInteractor: AccountInteractorProtocol)
    
    var isShowingEditingView: Bool { get }
    var accounts: [AccountModel] { get }
    var isFetching: Bool { get }
    
    func didTapAdd()
    func didAppear()
    func didTapAccount(account: AccountModel)
}

class AccountsViewModelMock: AccountsViewModelProtocol {
    @Published var accounts: [AccountModel] = []
    @Published var isShowingEditingView = false
    @Published var isFetching = false
    @Published var editingAccount: AccountModel? {
        didSet {
            isShowingEditingView = false
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private let accountsInteractor: AccountInteractorProtocol
    
    required init(accountsInteractor: AccountInteractorProtocol = AccountInteractor()) {
        self.accountsInteractor = accountsInteractor
        accountsInteractor.accounts
            .replaceError(with: [])
            .assign(to: \.accounts, on: self)
            .store(in: &cancellables)
    }
    
    func didTapAdd() {
        isShowingEditingView = true
    }
    
    func didAppear() {
        accountsInteractor.fetchAccounts()
    }
    
    func didTapAccount(account: AccountModel) {
        editingAccount = account
        isShowingEditingView = true
    }
}
