//
//  AccountDetailsViewModel.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 29/05/25.
//
import SwiftUI
import Combine

extension AccountDetailsView {
    class ViewModel: ObservableObject {
        @Published var isShowingEdit: Bool = false
        @Published var startDate: Date = .distantPast
        @Published var endDate: Date = .distantFuture
        @Published var searchText = ""
        @Published var debouncedSearchText = ""
        @Published var filterType: FilterType = .last30Days {
            didSet {
                updateDates()
            }
        }
        
        private var cancelables = Set<AnyCancellable>()
        
        init() {
            $searchText
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .sink {
                    self.debouncedSearchText = $0
                }
                .store(in: &cancelables)
        }
        
        func didAppear() {
            updateDates()
        }
        
        private func updateDates() {
            guard filterType != .custom else { return }
            let period = filterType.dateRange
            startDate = period.start
            endDate = period.end
        }
    }
}
