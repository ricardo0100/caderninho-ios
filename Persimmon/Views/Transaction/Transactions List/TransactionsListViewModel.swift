import SwiftUI
import SwiftData
import PhotosUI

extension TransactionsListView {
    public class ViewModel: ObservableObject {
        @Published var isShowingEdit: Bool = false
        
        @Published var isShowingCamera = false
        @Published var filterStartDate = Date()
        @Published var filterEndDate = Date()
        
        @Published var ticketData: TicketProcessor.TicketData?
        @Published var isProcessingTicket: Bool = false
        @Published var ticketImage: UIImage? {
            didSet {
                guard let ticketImage = ticketImage else { return }
                startProcessingTicketImage(ticketImage)
            }
        }
        @Published var filterType: FilterType = .thisMonth {
            didSet {
                updateDates()
            }
        }
        @Published var isShowingFilter = false
        
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
        
        private func startProcessingTicketImage(_ image: UIImage) {
            isProcessingTicket = true
            Task.detached(priority: .userInitiated) {
                let ticketProcessor = TicketProcessor()
                ticketProcessor.process(image) { data in
                    self.didFinishProcessingTicket(data: data)
                }
            }
        }
        
        private func didFinishProcessingTicket(data: TicketProcessor.TicketData?) {
            DispatchQueue.main.async {
                self.isProcessingTicket = false
                self.ticketData = data
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
