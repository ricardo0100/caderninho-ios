import SwiftUI
import SwiftData

extension ModelContainer {
    static let shared = try!
    ModelContainer(
        for:
        Account.self,
        Category.self,
        Transaction.self,
        Installment.self,
        Bill.self,
        CreditCard.self
    )
}

@main
struct PersimmonApp: App {
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .modelContainer(.shared)
        }
    }
}
