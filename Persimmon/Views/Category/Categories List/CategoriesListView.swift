import SwiftUI
import SwiftData

struct CategoriesListView: View {
    @Environment(\.modelContext) var modelContext
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if !viewModel.graphItems.isEmpty {
                        PizzaGraphView(values: viewModel.graphItems)
                            .padding(.spacingMedium)
                            .frame(height: 150)
                    } else {
                        Text("Nothing for this period")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                    }
                } header: {
                    HStack {
                        PeriodFilterView(
                            startDate: $viewModel.startDate,
                            endDate: $viewModel.endDate)
                        Spacer()
                        Menu {
                            ForEach(viewModel.currencyOptions, id: \.self) { currency in
                                Button(currency) {
                                    viewModel.currency = currency
                                }
                            }
                        } label: {
                            Text(viewModel.currency)
                        }

                    }.padding(.vertical)
                }
                .listRowInsets(EdgeInsets())
                .textCase(.none)
                
                Section {
                    ForEach(viewModel.items.sorted { $0.total > $1.total }) { item in
                        NavigationLink {
                            CategoryDetailsView(category: item.category)
                        } label: {
                            CategoryCell(category: item.category,
                                         total: item.total.toCurrency(with: viewModel.currency))
                        }
                    }
                } header: {
                    Text("Expenses for the selected period")
                }
            }
            .sheet(isPresented: $viewModel.isShowindEdit) {
                EditCategoryView()
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "briefcase", title: "Categories")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: viewModel.didTapAdd) {
                        Image(systemName: "plus")
                            .foregroundColor(.brand)
                    }
                }
            }
        }
        .onChange(of: [viewModel.startDate, viewModel.endDate]) {
            viewModel.didChangeDateRange(with: modelContext)
        }
        .onChange(of: viewModel.currency) {
            viewModel.didChangeCurrency(with: modelContext)
        }
        .onAppear { viewModel.didAppear(with: modelContext) }
    }
}

#Preview {
    NavigationStack {
        CategoriesListView()
            .modelContainer(.preview)
    }
}
