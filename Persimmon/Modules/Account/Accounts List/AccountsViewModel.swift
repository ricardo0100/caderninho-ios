import Foundation
import Combine

protocol AccountsViewModelProtocol: ObservableObject {
    init(accountsInteractor: AccountInteractorProtocol)
    
    var isShowingEditingView: Bool { get }
    var isShowingDeleteAlert: Bool { get }
    var accounts: [AccountModel] { get }
    var isFetching: Bool { get }
    
    func didTapAdd()
    func didTapEdit(account: AccountModel)
    func didLongPress(account: AccountModel)
    func didTapDelete(account: AccountModel)
    func didConfirmDelete()
}

class AccountsViewModelMock: AccountsViewModelProtocol {
    @Published var accounts: [AccountModel] = []
    @Published var isShowingEditingView = false
    @Published var isShowingDeleteAlert = false
    @Published var isFetching = false
    var deletingAccount: AccountModel? {
        didSet {
            isShowingDeleteAlert = deletingAccount != nil
        }
    }
    @Published var editingAccount: AccountModel? {
        didSet {
            isShowingEditingView = false
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private let accountsInteractor: AccountInteractorProtocol
    
    required init(accountsInteractor: AccountInteractorProtocol = AccountInteractorMock()) {
        self.accountsInteractor = accountsInteractor
        accountsInteractor.accounts
            .replaceError(with: [])
            .assign(to: \.accounts, on: self)
            .store(in: &cancellables)
    }
    
    func didTapAdd() {
        isShowingEditingView = true
    }
    
    func didTapEdit(account: AccountModel) {
        editingAccount = account
        isShowingEditingView = true
    }

    func didLongPress(account: AccountModel) {
        editingAccount = account
        isShowingEditingView = true
    }
    
    func didTapDelete(account: AccountModel) {
        deletingAccount = account
        isShowingDeleteAlert = true
    }
    
    func didConfirmDelete() {
        Just(deletingAccount)
            .compactMap { $0 }
            .flatMap { self.accountsInteractor.deleteAccount(account: $0) }
            .sink(
                receiveCompletion: { _ in},
                receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
