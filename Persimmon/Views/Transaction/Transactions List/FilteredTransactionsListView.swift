//
//  FilteredTransactionsListView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 24/05/25.
//

import SwiftUI
import SwiftData

struct FilteredTransactionsListView: View {
    @Query var transactions: [Transaction]
    
    init(startDate: Date, endDate: Date, searchText: String) {
        _transactions = Query(filter: #Predicate<Transaction> { transaction in
            transaction.date <= endDate &&
            transaction.date >= startDate &&
            (searchText.isEmpty || transaction.name.localizedStandardContains(searchText))
        }, sort: \.date, order: .reverse)
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
        Text(date.formatted(date: .numeric, time: .omitted))
    }
    
    var body: some View {
        if transactions.isEmpty {
            Text("No transactions for this period!")
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
    List {
        FilteredTransactionsListView(
            startDate: .distantPast,
            endDate: .distantFuture,
            searchText: "")
    }
    .modelContainer(.preview)
}
