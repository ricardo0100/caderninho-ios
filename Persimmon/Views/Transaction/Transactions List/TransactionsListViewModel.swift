import SwiftUI
import SwiftData
import PhotosUI
import Combine

extension TransactionsListView {
    public class ViewModel: ObservableObject {
        @Published var isShowingNewTransaction: Bool = false
        @Published var isShowingCamera = false
        @Published var editingTransaction: Transaction?
        
        @Published var selectedId: UUID?
        @Published var filterStartDate = Date()
        @Published var filterEndDate = Date()
        @Published var searchText: String = ""
        @Published var debouncedSearchText: String = ""
        @Published var ticketData: TicketData?
        
        private var cancellables = Set<AnyCancellable>()
        
        init() {
            $searchText
                .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
                .sink {
                    self.debouncedSearchText = $0
                }
                .store(in: &cancellables)
        }
        
        func didTapAdd() {
            //TODO: Inject NavigationModel
            NavigationModel.shared.newTransaction = true
        }
        
        func didTapCamera() {
            isShowingCamera = true
        }
    }
}
