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

    init(
        startDate: Date,
        endDate: Date,
        searchText: String,
        selectedAccountOrCardId: UUID? = nil,
        categoryId: UUID? = nil
    ) {
        let basePredicate = #Predicate<Transaction> { transaction in
            transaction.date >= startDate &&
            transaction.date <= endDate &&
            (searchText.isEmpty || transaction.name.localizedStandardContains(searchText))
        }

        var predicates: [Predicate<Transaction>] = [basePredicate]

        if let selectedId = selectedAccountOrCardId {
            let accountMatch = #Predicate<Transaction> { transaction in
                transaction.account?.id == selectedId
            }

            let installmentMatch = #Expression<Transaction, Bool> { transaction in
                !transaction.installments.filter { $0.bill.card.id == selectedId }.isEmpty
            }

            let combined = #Predicate<Transaction> { transaction in
                accountMatch.evaluate(transaction) || installmentMatch.evaluate(transaction)
            }

            predicates.append(combined)
        }

        if let catId = categoryId {
            predicates.append(
                #Predicate<Transaction> { transaction in
                    transaction.category?.id == catId
                }
            )
        }

        let finalPredicate = predicates.reduce(basePredicate) { result, next in
            #Predicate<Transaction> { transaction in
                result.evaluate(transaction) && next.evaluate(transaction)
            }
        }

        _transactions = Query(filter: finalPredicate, sort: \.date, order: .reverse)
    }

    
    private var groupedItems: [Date: [Transaction]] {
        Dictionary(grouping: transactions) {
            Calendar.current.startOfDay(for: $0.date)
        }
    }
    
    private var sectionDates: [Date] {
        groupedItems.keys.sorted(by: >)
    }
    
    private func sectionHeader(for date: Date) -> some View {
        Text(date.formatted(date: .numeric, time: .omitted))
    }
    
    var body: some View {
        if transactions.isEmpty {
            Text("No transactions!")
                .foregroundStyle(Color.secondary)
        }
        ForEach(sectionDates, id: \.self) { date in
            Section(header: sectionHeader(for: date)) {
                ForEach(groupedItems[date] ?? []) { transaction in
                    NavigationLink(value: transaction) {
                        TransactionCellView()
                            .environmentObject(transaction)
                    }
                }
            }
        }
    }
}

#Preview {
    let cat = try! ModelContext.preview.fetch(FetchDescriptor<Category>())
        .first { $0.transactions.count > 0 }!
    List {
        FilteredTransactionsListView(
            startDate: .distantPast,
            endDate: .distantFuture,
            searchText: "",
            selectedAccountOrCardId: nil,
            categoryId: cat.id)
    }
    .modelContainer(.preview)
}
