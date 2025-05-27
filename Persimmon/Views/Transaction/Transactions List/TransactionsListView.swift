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
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: viewModel.didTapAdd) {
                    Image(systemName: "plus")
                        .padding(.spacingSmall)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .onAppear(perform: viewModel.didAppear)
        .fullScreenCover(isPresented: $viewModel.isShowingNewTransaction) {
            NewTransactionView(isPresented: $viewModel.isShowingNewTransaction)
        }
    }
}

#Preview {
    NavigationStack {
        TransactionsListView()
            .modelContainer(.preview)
    }
}

