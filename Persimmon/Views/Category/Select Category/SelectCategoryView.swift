import SwiftUI
import SwiftData

struct SelectCategoryView: View {
    @Query var categories: [Category]
    
    @Environment(\.dismiss) var dismiss
    @Binding var selected: Category?
    
    var body: some View {
        List(categories, id: \.self, selection: $selected) { category in
            CategoryCell()
            .environmentObject(category)
            .onTapGesture {
                didSelect(category: category)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Clear") {
                    selected = nil
                    dismiss()
                }
            }
        }
        .tint(.brand)
    }
    
    func didSelect(category: Category) {
        selected = category
        dismiss()
    }
}

#Preview {
    NavigationStack {
        SelectCategoryView(selected: .constant(nil))
            .modelContainer(DataController.previewContainer)
    }
}
