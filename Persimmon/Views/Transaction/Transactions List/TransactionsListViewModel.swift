import SwiftUI
import SwiftData
import PhotosUI
import Combine

extension TransactionsListView {
    public class ViewModel: ObservableObject {
        @Published var isShowingNewTransaction: Bool = false
        @Published var isShowingCamera = false
        
        @Published var selectedId: UUID?
        @Published var filterStartDate = Date()
        @Published var filterEndDate = Date()
        @Published var searchText: String = ""
        @Published var debouncedSearchText: String = ""
        @Published var filterType: FilterType = .last30Days {
            didSet {
                updateDates()
            }
        }
        @Published var ticketData: TicketData?
        
        private var cancellables = Set<AnyCancellable>()
        
        init() {
            updateDates()
            $searchText
                .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
                .sink {
                    self.debouncedSearchText = $0
                }
                .store(in: &cancellables)
        }
        
        func didTapAdd() {
            isShowingNewTransaction = true
        }
        
        func didTapCamera() {
            isShowingCamera = true
        }
        
        func didAppear() {
            updateDates()
        }
        
        private func updateDates() {
            guard filterType != .custom else {
                return
            }
            let range = filterType.dateRange
            filterStartDate = range.start
            filterEndDate = range.end
        }
    }
}
