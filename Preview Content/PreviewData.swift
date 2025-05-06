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
    
    static func createRandomCreditCard() -> CreditCard {
        CreditCard(id: UUID(),
                   name: cardNameExamples.randomElement()!,
                   color: NiceColor.allCases.randomElement()!.rawValue,
                   currency: accountCurrencyExamples.randomElement()!,
                   closingCycleDay: 3,
                   dueDay: 10)
    }
    
    static func createRandomTransaction(using context: ModelContext? = nil) -> Transaction {
        let account = (try? context?.fetch(FetchDescriptor<Account>()).randomElement()) ?? createRandomAccount()
        let category = (try? context?.fetch(FetchDescriptor<Category>()).randomElement()) ?? createRandomCategory(withIcon: true)
        let date = Date().dateAddingDays((-100..<0).randomElement() ?? 0)
        return Transaction(id: UUID(),
                           name: transactionNameExamples.randomElement()!,
                           value: Double((1...999).randomElement()!),
                           account: account,
                           category: category,
                           date: date,
                           type: .buyDebit,
                           place: Transaction.Place(
                            name: "Trem de Minas",
                            title: "Restaurante",
                            subtitle: "Florianópolis SC",
                            latitude: -27.707511,
                            longitude: -48.510450))
    }
    
    static func createRandomInstallment() -> Installment {
        let transaction = createRandomTransaction()
        transaction.type = .buyCredit
        let bill = Bill(id: UUID(), dueDate: Date().dateAddingDays(30))
        return Installment(id: UUID(), date: Date().dateAddingDays(30), transaction: transaction, bill: bill, value: transaction.value)
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
                for: Account.self,
                Category.self,
                Transaction.self,
                Installment.self,
                Bill.self,
                CreditCard.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            
            let accounts = accountNameExamples.map {
                Account(
                    id: UUID(),
                    name: $0,
                    color: NiceColor.allCases.randomElement()!.rawValue,
                    currency: accountCurrencyExamples.randomElement()!)
            }
            accounts.forEach { container.mainContext.insert($0) }
            
            let categories = categoryNameExamples.map {
                Category(id: UUID(),
                         name: $0,
                         color: NiceColor.allCases.randomElement()!.rawValue,
                         icon: NiceIcon.allCases.randomElement()!.rawValue)
            }
            categories.forEach { container.mainContext.insert($0) }
            
            let cards = cardNameExamples.map {
                CreditCard(id: UUID(),
                           name: $0,
                           color: NiceColor.allCases.randomElement()!.rawValue,
                           currency: accountCurrencyExamples.randomElement()!,
                           closingCycleDay: 3,
                           dueDay: 10)
            }
            cards.forEach { container.mainContext.insert($0) }
            
            
            
            try container.mainContext.save()
            transactionNameExamples.forEach {
                let transaction = Transaction(
                    id: .init(),
                    name: $0,
                    value: Double((0...99999).randomElement()!) / 100,
                    account: accounts.randomElement()!,
                    category: categories.randomElement()!,
                    date: Date().dateAddingDays((-100..<0).randomElement() ?? 0),
                    type: .buyCredit,
                    place: nil)
                container.mainContext.insert(transaction)
            }

            try container.mainContext.save()
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }
}
