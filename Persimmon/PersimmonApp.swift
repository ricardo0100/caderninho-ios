import SwiftUI
import SwiftData

@main
struct PersimmonApp: App {
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .modelContainer(for: [Account.self,
                                      Category.self,
                                      Transaction.self])
        }
    }
}
