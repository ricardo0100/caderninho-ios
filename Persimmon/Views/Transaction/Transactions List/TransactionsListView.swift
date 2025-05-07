import SwiftUI
import SwiftData
import PhotosUI

struct TransactionsListView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.isShowingFilter {
                    Section {
                        FilterView(selectedFilter: $viewModel.filterType,
                                   startDate: $viewModel.filterStartDate,
                                   endDate: $viewModel.filterEndDate)
                    }
                }
                DynamicTransactionsListView(startDate: viewModel.filterStartDate,
                                            endDate: viewModel.filterEndDate)
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "arrow.up.arrow.down",
                                          title: "Transactions")
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: viewModel.didTapFilter) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundColor(.brand)
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: viewModel.didTapCamera) {
                        Image(systemName: "camera")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: viewModel.didTapAdd) {
                        Image(systemName: "plus")
                            .foregroundColor(.brand)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingEdit) {
            EditTransactionView(transaction: nil)
        }
        .sheet(item: $viewModel.ticketData, content: { data in
//            EditTransactionView(viewModel: .init(ticketData: data))
        })
        .sheet(isPresented: $viewModel.isShowingCamera) {
            TicketReaderView(viewModel: .init(ticketData: $viewModel.ticketData))
        }
    }
}

struct DynamicTransactionsListView: View {
    @Query var transactions: [Transaction]
    
    init(startDate: Date, endDate: Date) {
        _transactions = Query(filter: #Predicate<Transaction> { transaction in
            transaction.date <= endDate &&
            transaction.date >= startDate
        }, sort: \Transaction.date)
    }
    
    private var groupedItems: [Date: [Transaction]] {
        Dictionary(grouping: transactions) {
            Calendar.current.startOfDay(for: $0.date)
        }
    }
    
    // Sorted section dates (newest first)
    private var sectionDates: [Date] {
        groupedItems.keys.sorted(by: >)
    }
    
    private func sectionHeader(for date: Date) -> some View {
        Text(date.formatted(date: .abbreviated, time: .omitted))
    }
    
    var body: some View {
        if transactions.isEmpty {
            Text("Oops! No transactions yet")
        }
        ForEach(sectionDates, id: \.self) { date in
            Section(header: sectionHeader(for: date)) {
                ForEach(groupedItems[date] ?? []) { transaction in
                    NavigationLink {
                        TransactionDetailsView()
                            .environmentObject(transaction)
                    } label: {
                        TransactionCellView()
                            .environmentObject(transaction)
                    }
                }
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

