import Foundation

struct SavingsItem: Identifiable {
    let id = UUID()
    let name: String
    let color: NiceColor
    let amount: Double
    let currency: String
}

protocol SavingsViewModelProtocol: ObservableObject {
    var savings: [SavingsItem] { get }
    func fetchSavings()
}

class SavingsViewModelMock: SavingsViewModelProtocol {
    static let availableSavings = [
        SavingsItem(name: "Poupança", color: .pink, amount: 345.19, currency: "R$"),
        SavingsItem(name: "Stocks", color: .red, amount: 982.87, currency: "US$"),
        SavingsItem(name: "National Trust", color: .yellowGreen, amount: 121.87, currency: "R$"),
        SavingsItem(name: "Savings", color: .blue, amount: 212.11, currency: "R$"),
    ]
    
    @Published var savings: [SavingsItem] = []

    init() {
        fetchSavings()
    }

    func fetchSavings() {
        savings = Self.availableSavings
    }
}
