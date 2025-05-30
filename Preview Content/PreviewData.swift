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
    
    static func createRandomAccount(withIcon: Bool = true) -> Account {
        Account(id: UUID(),
                name: accountNameExamples.randomElement()!,
                color: NiceColor.allCases.randomElement()!.rawValue,
                icon: withIcon ? BankIcon.allCases.randomElement()!.rawValue : nil,
                currency: accountCurrencyExamples.randomElement()!)
    }
    
    private static func createRandomTransaction(using container: ModelContainer, operation: Transaction.EditOperation) {
        let name = transactionNameExamples.randomElement()!
        let category = try! container.mainContext.fetch(FetchDescriptor<Category>()).randomElement()!
        try! ModelManager(context: container.mainContext)
            .createTransaction(
                name: name,
                date: Date().dateAddingDays((-40 ... 0).randomElement()!),
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
    
    static func createPreviewContainerWithExampleData() -> ModelContainer {
        do {
            let container = try ModelContainer(
                for: ModelContainer.schema,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            
            let context = container.mainContext
            let accounts = accountNameExamples.map {
                Account(
                    id: UUID(),
                    name: $0,
                    color: NiceColor.allCases.randomElement()!.rawValue,
                    icon: BankIcon.allCases.randomElement()!.rawValue,
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
                icon: BankIcon.caixa.rawValue,
                currency: accountCurrencyExamples.randomElement()!,
                closingCycleDay: 3,
                dueDay: 10)
            context.insert(card)
            try! container.mainContext.save()
            
            createRandomTransaction(
                using: container,
                operation: .installments(card: card, numberOfInstallments: 7,value: 199.9))
            createRandomTransaction(
                using: container,
                operation: .transferIn(account: accounts.randomElement()!,value: 19.99))
            createRandomTransaction(
                using: container,
                operation: .installments(card: card, numberOfInstallments: 2,value: 1.999))
            createRandomTransaction(
                using: container,
                operation: .transferIn(account: accounts.randomElement()!,value: 1999))
            createRandomTransaction(
                using: container,
                operation: .installments(card: card, numberOfInstallments: 1,value: 1999))
            createRandomTransaction(
                using: container,
                operation: .transferIn(account: accounts.randomElement()!,value: 19.99))
            createRandomTransaction(
                using: container,
                operation: .transferOut(account: accounts.randomElement()!,value: 1999))
            
            try container.mainContext.save()
            
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }
}
