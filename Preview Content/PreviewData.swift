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
    
    private static func createRandomTransaction(using container: ModelContainer, operation: Transaction.EditOperation) {
        let name = transactionNameExamples.randomElement()!
        let category = try! container.mainContext.fetch(FetchDescriptor<Category>()).randomElement()!
        let value = Double((1...100000).randomElement()!) / 100.0
        try! ModelManager(context: container.mainContext)
            .createTransaction(
                name: name,
                date: Date(),
                value: value,
                editOperation: operation,
                category: category,
                place: nil)
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
//            
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
            
            createRandomTransaction(using: container, operation: .installments(card: card, numberOfInstallments: 7))
            createRandomTransaction(using: container, operation: .transferIn(account: accounts.randomElement()!))
            createRandomTransaction(using: container, operation: .transferOut(account: accounts.randomElement()!))
            
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }
}
