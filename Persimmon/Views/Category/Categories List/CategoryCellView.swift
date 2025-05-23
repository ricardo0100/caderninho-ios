import SwiftUI

struct CategoryCell: View {
    @EnvironmentObject var category: Category
    
    var body: some View {
        HStack {
            CategoryIcon(name: category.name,
                         color: category.color,
                         icon: category.icon,
                         size: 32)
            VStack(alignment: .leading) {
                Text(category.name)
                    .font(.headline)
            }
        }
    }
}



#Preview {
    List {
        CategoryCell().environmentObject(DataController.createRandomCategory())
        CategoryCell().environmentObject(DataController.createRandomCategory(withIcon: true))
    }
}
