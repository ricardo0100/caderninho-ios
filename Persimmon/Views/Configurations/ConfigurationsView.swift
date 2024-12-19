import SwiftUI

struct ConfigurationsView: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                Button("Create Example Data") {
                    createExampleData()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "gear", title: "Configurations")
                }
            }
        }
    }
    
    func createExampleData() {
        let transaction = DataController.createRandomTransaction()
        modelContext.insert(transaction)
        try? modelContext.save()
    }
}

#Preview {
    ConfigurationsView()
        .tint(.brand)
}
