import SwiftUI
import SwiftData

struct SelectCategoryView: View {
    @Query var categories: [Category]
    @Binding var selected: Category?
    
    var body: some View {
        Menu {
            ForEach(categories, id: \.self) { category in
                Button {
                    selected = category
                } label: {
                    Label(category.name, systemImage: category.icon ?? "")
                }
            }
        } label: {
            if let category = selected {
                CategoryCell()
                    .environmentObject(category)
                    .tint(.brand)
            } else {
                Text("Select a category")
            }
        }
    }
}

#Preview {
    @Previewable @State var category: Category?
    SelectCategoryView(selected: $category)
        .modelContainer(.preview)
}
