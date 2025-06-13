import SwiftUI

struct CategoryCellView: View {
    let category: Category
    let total: String?
    
    var body: some View {
        HStack {
            Text(category.name)
                .font(.headline)
            Spacer()
            if let total = total {
                Text(total)
                    .font(.caption)
            }
            CategoryIcon(name: category.name,
                         color: category.color,
                         icon: category.icon,
                         size: 24)
        }
    }
}

#Preview {
    List {
        CategoryCellView(category: PreviewData.createRandomCategory(), total: "R$ 123,45")
        CategoryCellView(category: PreviewData.createRandomCategory(withIcon: true), total: "R$ 313,55")
    }
}
