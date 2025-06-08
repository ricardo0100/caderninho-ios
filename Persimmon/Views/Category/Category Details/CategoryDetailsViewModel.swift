//
//  CategoryDetailsViewModel.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 03/06/25.
//
import SwiftUI
import Combine

extension CategoryDetailsView {
    class ViewModel: ObservableObject {
        @Published var startDate: Date = Date()
        @Published var endDate: Date = Date()
        @Published var searchText: String = ""
        @Published var debouncedSearchText: String = ""
        
        let category: Category
        
        private var cancelables: [AnyCancellable] = []
        
        init(category: Category) {
            self.category = category
            $searchText.debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .sink { text in
                    self.debouncedSearchText = text
                }
                .store(in: &cancelables)
        }
    }
}
