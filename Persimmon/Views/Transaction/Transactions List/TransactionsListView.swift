import SwiftUI
import SwiftData
import PhotosUI
import AppIntents

struct TransactionsListView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    AccountCardHeader()
                } footer: {
                    PeriodFilterView(
                        startDate: $viewModel.filterStartDate,
                        endDate: $viewModel.filterEndDate,
                        filterType: $viewModel.filterType
                    ).padding(.top)
                }
                
                FilteredTransactionsListView(
                    startDate: viewModel.filterStartDate,
                    endDate: viewModel.filterEndDate,
                    searchText: viewModel.debouncedSearchText
                )
            }
            .searchable(text: $viewModel.searchText)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "book.pages",
                                          title: "Transactions")
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: viewModel.didTapAdd) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear(perform: viewModel.didAppear)
        .sheet(isPresented: $viewModel.isShowingEdit) {
            EditTransactionView(transaction: nil)
        }
        .foregroundColor(.brand)
    }
}

#Preview {
    NavigationStack {
        TransactionsListView()
            .modelContainer(.preview)
    }
}

