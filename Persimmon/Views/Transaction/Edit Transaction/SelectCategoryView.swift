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
                    HStack {
                        Image(systemName: category.icon ?? "")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                        Text(category.name)
                    }
                }
            }
        } label: {
            if let category = selected {
                CategoryCell(category: category, total: nil)
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
