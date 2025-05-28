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
            let range = dateRange
            filterStartDate = range.start
            filterEndDate = range.end
        }
        
        var dateRange: (start: Date, end: Date) {
            switch filterType {
            case .last30Days:
                return Date.getLast30DaysBounds()
            case .lastWeek:
                return Date.getLast7DaysBounds()
            case .today:
                return Date.getTodayBounds()
            case .yesterday:
                return Date.getYesterdayBounds()
            case .thisMonth:
                return Date.getThisMonthBounds()
            case .lastMonth:
                return Date.getLastMonthBounds()
            case .all:
                return (Date.distantPast, Date.distantFuture)
            case .custom:
                return (filterStartDate, filterEndDate)
            }
        }
    }
}
