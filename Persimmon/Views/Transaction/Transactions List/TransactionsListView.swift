import SwiftUI
import SwiftData
import PhotosUI
import AppIntents

struct TransactionsListView: View {
    @StateObject var viewModel = ViewModel()
    @EnvironmentObject var navigation: NavigationModel
    
    var body: some View {
        NavigationStack(path: $navigation.transactionsPath) {
            List {
                Section {
                    AccountCardHeaderView(selectedId: $viewModel.selectedId)
                }
                
                Section {} footer: {
                    PeriodFilterView(
                        startDate: $viewModel.filterStartDate,
                        endDate: $viewModel.filterEndDate)
                }
                .listRowInsets(EdgeInsets())
                
                FilteredTransactionsListView(
                    startDate: viewModel.filterStartDate,
                    endDate: viewModel.filterEndDate,
                    searchText: viewModel.debouncedSearchText,
                    selectedAccountOrCardId: viewModel.selectedId)
            }
            .searchable(text: $viewModel.searchText)
            .toolbar {
                #if DEBUG
                ToolbarItem(placement: .automatic) {
                    Menu("Debug") {
                        Button("Create Preview Data") {
                            try? PreviewData.createRandomData(.main)
                        }
                    }
                }
                #endif
            }
            .navigationTitle("Transactions")
            .overlay(alignment: .bottomTrailing) {
                Button(action: viewModel.didTapAdd) {
                    Image(systemName: "plus")
                        .padding(10)
                }
                .tint(.accentColor.opacity(0.95))
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .shadow(radius: .spacingNano, x: 1, y: 1)
                .padding()
            }
            .navigationDestination(for: Transaction.self) { transaction in
                TransactionDetailsView()
                    .environmentObject(transaction)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TransactionsListView()
            .environmentObject(NavigationModel())
            .modelContainer(.preview)
    }
}

