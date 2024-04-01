import Foundation
import SwiftUI
import Combine

class EditAccountViewModel: ObservableObject {
    @Published var name = ""
    @Published var nameErroMessage: String?
    @Published var currency = ""
    @Published var currencyErroMessage: String?
    @Published var color = NiceColor.gray.color
    @Published var niceColor = NiceColor.gray {
        didSet {
            color = niceColor.color
        }
    }
    @Published var shouldDismiss: Bool = false
    
    var cancelables: [AnyCancellable] = []
    var accountId: UUID?
    let interactor = AccountInteractorMock()
    
    init(accountId: UUID?, accountInteractor: AccountInteractorProtocol = AccountInteractorMock()) {
        guard let accountId = accountId else { return }
        self.accountId = accountId
        
        accountInteractor
            .getAccount(with: accountId)
            .sink { _ in } receiveValue: { account in
                self.name = account.name
                self.color = Color(hex: account.color)
                self.currency = account.currency
            }
            .store(in: &cancelables)
    }
    
    func didTapSave() {
        nameErroMessage = name.isEmpty ? "Campo obrigatório" : nil
        currencyErroMessage = currency.isEmpty ? "Campo obrigatório" : nil
        guard nameErroMessage == nil && currencyErroMessage == nil else { return }
        interactor.saveAccount(
            id: self.accountId,
            name: name,
            color: color.hex,
            currency: currency
        ).sink { completion in
            switch completion {
            case .finished:
                self.shouldDismiss = true
            default: break
            }
        } receiveValue: { _ in }.store(in: &cancelables)
    }
}
