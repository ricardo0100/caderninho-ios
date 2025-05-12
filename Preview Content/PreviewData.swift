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
    
    static func createCreditCardWithInstallments(in context: ModelContext, card: CreditCard, name: String, value: Double, numberOfInstallments: Int) {
        let transaction = Transaction(
            id: UUID(),
            name: name,
            value: value,
            category: createRandomCategory(),
            date: Date(),
            place: nil)
        context.insert(transaction)
        (1...numberOfInstallments).forEach { month in
            let bill = getBill(card: card, month: month, year: 2025, in: context) ?? Bill(id: UUID(), card: card, month: month, year: 2025)
            context.insert(bill)
            let value = value / Double(numberOfInstallments)
            context.insert(Installment(id: UUID(), transaction: transaction, number: month, bill: bill, value: value))
        }
    }
    
    static func getBill(card: CreditCard, month: Int, year: Int, in context: ModelContext) -> Bill? {
        let id = card.id
        let predicate = #Predicate<Bill> { bill in
            bill.card.id == id &&
            bill.month == month &&
            bill.year == year
        }
        return try! context.fetch(FetchDescriptor(predicate: predicate)).first
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
                           type: .out,
                           place: Transaction.Place(
                            name: "Trem de Minas",
                            title: "Restaurante",
                            subtitle: "Florianópolis SC",
                            latitude: -27.707511,
                            longitude: -48.510450))
    }
    
    static func createRandomCategory(withIcon: Bool = false) -> Category {
        Category(id: UUID(),
                 name: categoryNameExamples.randomElement()!,
                 color: NiceColor.allCases.randomElement()!.rawValue,
                 icon: withIcon ? NiceIcon.allCases.randomElement()!.rawValue : nil)
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
            createCreditCardWithInstallments(in: context, card: card, name: "Carro", value: 129000, numberOfInstallments: 10)
            createCreditCardWithInstallments(in: context, card: card, name: "Xícara Caríssima", value: 1000, numberOfInstallments: 5)
            card.bills.sorted().prefix(4).forEach { $0.payedDate = Date() }
            transactionNameExamples.forEach {
                let transaction = Transaction(
                    id: .init(),
                    name: $0,
                    value: Double((0...99999).randomElement()!) / 100,
                    account: accounts.randomElement()!,
                    category: categories.randomElement()!,
                    date: Date().dateAddingDays((-100..<0).randomElement() ?? 0),
                    type: .installments,
                    place: nil)
                context.insert(transaction)
            }

            try context.save()
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }
}
