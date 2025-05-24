import SwiftUI
import SwiftData
import PhotosUI
import AppIntents

struct TransactionsListView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Menu {
                        ForEach(FilterType.allCases, id: \.self) { filterType in
                            Button {
                                withAnimation {
                                    viewModel.filterType = filterType
                                }
                            } label: {
                                HStack {
                                    Text(filterType.title)
                                    if filterType == viewModel.filterType {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "calendar.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color(.systemBlue))
                    }
                    switch viewModel.filterType {
                    case .custom:
                        HStack {
                            DatePicker("Start Date",
                                       selection: $viewModel.filterStartDate,
                                       displayedComponents: .date).labelsHidden()
                            DatePicker("End Date",
                                       selection: $viewModel.filterEndDate,
                                       displayedComponents: .date).labelsHidden()
                        }.frame(height: 32)
                    case .all:
                        Text("Showing all transactions")
                    default:
                        Text("\(viewModel.filterStartDate.numericDate) - \(viewModel.filterEndDate.numericDate)")
                    }
                }
                List {
                    FilteredTransactionsListView(
                        startDate: viewModel.filterStartDate,
                        endDate: viewModel.filterEndDate,
                        searchText: viewModel.debouncedSearchText
                    )
                }
                .searchable(text: $viewModel.searchText)
            }
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

