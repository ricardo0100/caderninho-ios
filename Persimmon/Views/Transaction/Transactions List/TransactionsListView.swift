import SwiftUI
import SwiftData
import PhotosUI
import AppIntents

struct TransactionsListView: View {
    @ObservedObject var viewModel = ViewModel()
    @StateObject var navigation = TransactionsNavigation()
    
    var body: some View {
        VStack {
            NavigationStack(path: $navigation.path) {
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
                    .environmentObject(navigation)
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
                        .environmentObject(navigation)
                }
                .sheet(item: $viewModel.editingTransaction) { transaction in
                    EditTransactionView(transaction: transaction, navigation: navigation)
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

