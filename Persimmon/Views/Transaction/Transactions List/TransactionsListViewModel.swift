import SwiftUI
import SwiftData
import PhotosUI

extension TransactionsListView {
    public class ViewModel: ObservableObject {
        @Published var isShowingEdit: Bool = false
        @Published var isShowingCamera = false
        @Published var filterStartDate = Date()
        @Published var filterEndDate = Date()
        @Published var ticketData: TicketData?
        @Published var isShowingFilter = false
        @Published var filterType: FilterType = .thisMonth {
            didSet {
                updateDates()
            }
        }
        
        init() {
            updateDates()
        }
        
        func didTapAdd() {
            isShowingEdit = true
        }
        
        func didTapCamera() {
            isShowingCamera = true
        }
        
        func didTapFilter() {
            withAnimation {
                isShowingFilter.toggle()
            }
        }
        
        private func updateDates() {
            if filterType == .custom {
                filterStartDate = Date.getTodayBounds().start
                filterEndDate = Date()
            } else {
                let range = dateRange
                filterStartDate = range.start
                filterEndDate = range.end
            }
        }
        
        var dateRange: (start: Date, end: Date) {
            switch filterType {
            case .today:
                return Date.getTodayBounds()
            case .yesterday:
                return Date.getYesterdayBounds()
            case .thisMonth:
                return Date.getThisMonthBounds()
            case .lastMonth:
                return Date.getLastMonthBounds()
            case .all, .custom:
                return (Date.distantPast, Date.distantFuture)
            }
        }
    }
}
