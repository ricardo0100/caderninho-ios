import Foundation
import Combine
import SwiftUI

class SelectAccountViewModel: ObservableObject {
    @Published var accounts: [AccountModel] = []
    let account: Binding<AccountModel?>
    
    var cancellables: [AnyCancellable] = []
    
    init(selectedAccount: Binding<AccountModel?>, accountInteractor: AccountInteractorProtocol = AccountInteractorMock()) {
        account = selectedAccount
        accountInteractor
            .accounts
            .replaceError(with: [])
            .assign(to: \.accounts, on: self)
            .store(in: &cancellables)
    }
    
    func didSelect(account: AccountModel) {
        self.account.wrappedValue = account
    }
}
