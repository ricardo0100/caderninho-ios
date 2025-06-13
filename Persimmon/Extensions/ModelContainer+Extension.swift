import SwiftUI
import SwiftData

extension ModelContainer {
    static let schema = Schema([Account.self,
                                Category.self,
                                Transaction.self,
                                Installment.self,
                                Bill.self,
                                CreditCard.self])
    
    static let main = try! ModelContainer(for: schema)
    
    #if DEBUG
    static func createTestContainer() -> ModelContainer {
        try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }
    
    @MainActor static let preview: ModelContainer = PreviewData.createPreviewContainerWithExampleData()
    #endif
}
