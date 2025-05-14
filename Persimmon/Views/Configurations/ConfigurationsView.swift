import SwiftUI
import SwiftData

struct ConfigurationsView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var accounts: [Account]
    @AppStorage("home-currency") private var homeCurrency = Locale.current.currency?.identifier ?? ""
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Debug")) {
                    Button("Create Example Transaction") {
                        createExampleTransaction()
                    }
                    Button("Create Example Account") {
                        createExampleAccount()
                    }
                    Button("Create Example Category") {
                        createExampleCategory()
                    }
                    Button("Create Example Card") {
                        createExampleCard()
                    }
                    Button("Reset Database") {
                        // TODO: Implement
                    }
                }
                Section(header: Text("Home configuration")) {
                    let currencies = Array(Set(accounts.map(\.currency))).sorted()
                    Picker(selection: $homeCurrency, label: Text("Default currency")) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "gear", title: "Configurations")
                }
            }
        }
    }
    
    func createExampleTransaction() {
        
    }
    
    func createExampleAccount() {
        modelContext.insert(DataController.createRandomAccount())
        try? modelContext.save()
    }
    
    func createExampleCategory() {
        modelContext.insert(DataController.createRandomCategory())
        try? modelContext.save()
    }
    func createExampleCard() {
//        modelContext.insert(DataController.createRandomCreditCard())
        try? modelContext.save()
    }
}

#Preview {
    ConfigurationsView()
        .modelContainer(.preview)
        .tint(.brand)
}
