import SwiftUI

struct CategoryCell: View {
    @EnvironmentObject var category: Category
    
    var body: some View {
        HStack {
            Text(category.name)
                .font(.headline)
            Spacer()
            CategoryIcon(name: category.name,
                         color: category.color,
                         icon: category.icon,
                         size: 32)
        }
    }
}



#Preview {
    List {
        CategoryCell().environmentObject(DataController.createRandomCategory())
        CategoryCell().environmentObject(DataController.createRandomCategory(withIcon: true))
    }
}
