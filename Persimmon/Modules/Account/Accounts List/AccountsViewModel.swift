import Foundation
import Combine

class AccountsListViewModel: ObservableObject {
    @Published var accounts: [AccountModel] = []
    @Published var isShowingEditingView = false
    @Published var isShowingDeleteAlert = false

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
                receiveCompletion: { _ in },
                receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
