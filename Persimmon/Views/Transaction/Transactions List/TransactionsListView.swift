import SwiftUI
import SwiftData
import PhotosUI
import AppIntents

struct TransactionsListView: View {
    @ObservedObject var viewModel = ViewModel()
    @EnvironmentObject var navigation: NavigationModel
    
    var body: some View {
        VStack {
            NavigationStack(path: $navigation.transactionsPath) {
                List {
                    Section {
                    } footer: {
                        VStack(alignment: .leading, spacing: .spacingNano) {
                            AccountCardHeader(selectedId: $viewModel.selectedId)
                                .padding(.top, .spacingSmall)
                            PeriodFilterView(
                                startDate: $viewModel.filterStartDate,
                                endDate: $viewModel.filterEndDate)
                            .padding(.top)
                        }
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
                    ToolbarItem(placement: .navigation) {
                        NavigationToolbarView(imageName: "book.pages",
                                              title: "Transactions")
                    }
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
            .onAppear(perform: viewModel.didAppear)
            .fullScreenCover(isPresented: $viewModel.isShowingNewTransaction) {
                NewTransactionView(isPresented: $viewModel.isShowingNewTransaction)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TransactionsListView()
            .modelContainer(.preview)
    }
}

