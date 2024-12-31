import SwiftUI
import SwiftData

extension ModelContainer {
    static let shared = try! ModelContainer(
        for:
            Account.self,
            Category.self,
            Transaction.self,
            TransactionShare.self
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
