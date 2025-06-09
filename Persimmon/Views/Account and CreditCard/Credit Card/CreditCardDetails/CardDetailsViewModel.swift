//
//  CardDetailsViewModel.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 29/05/25.
//

import SwiftUI
import Combine

extension CardDetailsView {
    class ViewModel: ObservableObject {
        @Published var installments: [Installment] = []
        @Published var searchText = ""
        @Published var debouncedSearchText = ""
        @Published var selectedBill: Bill? {
            didSet {
                installments = selectedBill?.installments ?? []
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
        
        func didTapSetPaid() {
            withAnimation {
                self.selectedBill?.payedDate = Date()
            }
            try? self.selectedBill?.modelContext?.save()
        }
        
        func didTapPayedDate() {
            withAnimation {
                self.selectedBill?.payedDate = nil
            }
            try? self.selectedBill?.modelContext?.save()
        }
    }
}
