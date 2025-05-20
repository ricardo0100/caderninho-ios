import Foundation
import SwiftUI
import SwiftData

@MainActor
class DataController {
    static let accountNameExamples = [
        "Banco do Brasil",
        "Maya Bank",
        "Feijão Trust"
    ]
    
    static let cardNameExamples = [
        "Vasa",
        "Mustacard",
        "Gehrke Card"
    ]
    
    static let transactionNameExamples = [
        "Almoço",
        "Jantar",
        "Mansão",
        "Supermercado",
        "Academia",
        "Cinema",
        "Viagem",
        "Café",
        "Barbearia",
        "Manicure",
        "Presente",
        "Hospedagem",
        "Curso Online",
        "Medicamentos",
        "Eletrônicos",
        "Pet Shop",
        "Doação",
        "Roupa",
        "Gasolina"
    ]
    
    static let accountCurrencyExamples = [
        "R$",
        "元",
        "US$"
    ]
    
    static let categoryNameExamples = [
        "Alimentação",
        "Transporte",
        "Aluguel",
        "Saúde",
        "Educação",
        "Lazer",
        "Compras",
        "Viagem",
        "Serviços",
        "Impostos",
        "Investimentos",
        "Entretenimento",
        "Doações"
    ]
    
    static func createRandomAccount() -> Account {
        Account(id: UUID(),
                name: accountNameExamples.randomElement()!,
                color: NiceColor.allCases.randomElement()!.rawValue,
                currency: accountCurrencyExamples.randomElement()!)
    }
    
    private static func createRandomTransaction(using container: ModelContainer, type: Transaction.TransactionType) {
        let context = container.mainContext
        let category = (try? context.fetch(FetchDescriptor<Category>()).randomElement()) ?? createRandomCategory(withIcon: true)
        let date = Date().dateAddingDays((-100..<0).randomElement() ?? 0)
        
//        let vm = EditTransactionView.ViewModel(modelContainer: container)
//        vm.name = transactionNameExamples.randomElement()!
//        vm.value = Double.random(in: 1...1000)
//        vm.date = date
//        vm.type = type
//        vm.category = category
//        if type == .installments {
//            let card = (try? context.fetch(FetchDescriptor<CreditCard>()).randomElement()) ?? createRandomCard()
//            vm.card = card
//            vm.numberOfInstallments = Int.random(in: 1...12)
//        } else {
//            let account = (try? context.fetch(FetchDescriptor<Account>()).randomElement()) ?? createRandomAccount()
//            vm.account = account
//        }
//        vm.didTapSave()
    }
    
    static func createRandomCategory(withIcon: Bool = false) -> Category {
        Category(id: UUID(),
                 name: categoryNameExamples.randomElement()!,
                 color: NiceColor.allCases.randomElement()!.rawValue,
                 icon: withIcon ? NiceIcon.allCases.randomElement()!.rawValue : nil)
    }
    
    static func createRandomCard() -> CreditCard {
        CreditCard(id: UUID(),
                   name: categoryNameExamples.randomElement()!,
                   color: NiceColor.allCases.randomElement()!.rawValue,
                   currency: "R$",
                   closingCycleDay: 3,
                   dueDay: 10)
    }
    
    static func createPreviewContainerWithExampleData() -> ModelContainer {
        do {
            let container = try ModelContainer(for: ModelContainer.schema,
                                               configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            
            let context = container.mainContext
            let accounts = accountNameExamples.map {
                Account(
                    id: UUID(),
                    name: $0,
                    color: NiceColor.allCases.randomElement()!.rawValue,
                    currency: accountCurrencyExamples.randomElement()!)
            }
            accounts.forEach { context.insert($0) }
            
            let categories = categoryNameExamples.map {
                Category(id: UUID(),
                         name: $0,
                         color: NiceColor.allCases.randomElement()!.rawValue,
                         icon: NiceIcon.allCases.randomElement()!.rawValue)
            }
            categories.forEach { context.insert($0) }
            let card = CreditCard(
                id: UUID(),
                name: cardNameExamples.randomElement()!,
                color: NiceColor.allCases.randomElement()!.rawValue,
                currency: accountCurrencyExamples.randomElement()!,
                closingCycleDay: 3,
                dueDay: 10)
            context.insert(card)
            
            createRandomTransaction(using: container, type: .installments)
            createRandomTransaction(using: container, type: .out)
            createRandomTransaction(using: container, type: .out)
            
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }
}
