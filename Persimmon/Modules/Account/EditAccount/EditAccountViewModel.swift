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
    
    let accountBinding: Binding<AccountModel?>
    
    var cancelables: [AnyCancellable] = []

    let interactor = AccountInteractorMock()
    
    init(accountBinding: Binding<AccountModel?>) {
        self.accountBinding = accountBinding
        if let account = accountBinding.wrappedValue {
            self.name = account.name
            self.color = Color(hex: account.color)
            self.currency = account.currency
        }
    }
    
    func didTapSave() {
        nameErroMessage = name.isEmpty ? "Campo obrigatório" : nil
        currencyErroMessage = currency.isEmpty ? "Campo obrigatório" : nil
        guard nameErroMessage == nil && currencyErroMessage == nil else { return }
        interactor.saveAccount(
            id: accountBinding.wrappedValue?.id,
            name: name,
            color: color.hex,
            currency: currency
        ).sink { completion in
            switch completion {
            case .finished:
                self.accountBinding.wrappedValue = nil
            default: break
            }
        } receiveValue: { _ in }.store(in: &cancelables)
    }
}
