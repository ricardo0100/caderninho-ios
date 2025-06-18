import SwiftUI
import SwiftData

struct CategoriesListView: View {
    @Query var categories: [Category]
    @EnvironmentObject var navigation: NavigationModel
    @StateObject var viewModel = ViewModel()
    
    func getTotal(category: Category) -> Double {
        do {
            return try category.getExpensesTransactions(
                startDate: viewModel.startDate,
                endDate: viewModel.endDate,
                currency: viewModel.currency)
            .reduce(0) { $0 + $1.value }
        } catch {
            return .zero
        }
    }
    
    func getCategoriesWithTotal() -> [(Category, String)] {
        categories.map { category in
            (category, getTotal(category: category).toCurrency(with: viewModel.currency ?? ""))
        }
        .sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        NavigationStack(path: $navigation.categoriesPath) {
            List {
                Section {
                    VStack {
                        HStack {
                            PeriodFilterView(
                                startDate: $viewModel.startDate,
                                endDate: $viewModel.endDate)
                            Spacer()
                            CurrencySelectorView(selectedCurrency: $viewModel.currency)
                            
                        }
                        CategoriesPizzaGraphView(
                            startDate: viewModel.startDate,
                            endDate: viewModel.endDate,
                            currency: viewModel.currency)
                    }
                }
                
                Section {
                    ForEach(getCategoriesWithTotal(), id: \.self.0.id) { item in
                        NavigationLink(value: item.0) {
                            CategoryCellView(category: item.0, total: item.1)
                        }
                    }
                } header: {
                    Text("Expenses for the selected period")
                }
            }
            .navigationTitle("Categories")
            .navigationDestination(for: Category.self) {
                CategoryDetailsView(category: $0)
            }
            .navigationDestination(for: Transaction.self, destination: { transaction in
                TransactionDetailsView()
                    .environmentObject(transaction)
            })
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        navigation.newCategory = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.brand)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesListView()
            .environmentObject(NavigationModel())
            .modelContainer(.preview)
    }
}
