import SwiftUI

struct CategoryCell: View {
    @EnvironmentObject var category: Category
    
    var body: some View {
        HStack {
            if let icon = category.icon {
                ImageIconView(image: Image(systemName: icon),
                              color: Color(hex: category.color),
                              size: 32)
            } else {
                LettersIconView(text: category.name,
                                color: Color(hex: category.color),
                                size: 32)
            }
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
