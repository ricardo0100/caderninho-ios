import SwiftUI
import SwiftData
import PhotosUI

extension TransactionsListView {
    public class ViewModel: ObservableObject {
        @Published var isShowingEdit: Bool = false
        @Published var editingTransaction: Transaction?
        @Published var isLoading: Bool = false
        @Published var photosItem: PhotosPickerItem?
        
        func didTapAdd() {
            editingTransaction = nil
            isShowingEdit = true
        }
    }
}
