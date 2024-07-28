import SwiftUI
import SwiftData

struct CategoriesListView: View {
    @Query(sort: [SortDescriptor(\Category.name)]) var categories: [Category]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(categories) { category in
                        NavigationLink {
                            Text("👽")
                        } label: {
                            CategoryCell(category: category)
                        }

                        
                    }
                }
            }
//            .sheet(isPresented: $showingSheet) {
//                AddCategoryView()
//            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "briefcase", title: "Categories")
                }
            }
        }
    }
    
    func didTapAdd() {
        
    }
}

struct CategoryCell: View {
    let category: Category
    
    var body: some View {
        HStack {
            if let icon = category.icon {
                ImageIconView(image: Image(systemName: icon), color: Color(hex: category.color))
            } else {
                LettersIconView(text: category.name, color: Color(hex: category.color))
            }
            VStack(alignment: .leading) {
                Text(category.name)
                    .font(.headline)
                Text("R$ \(category.total.formatted())")
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesListView()
            .modelContainer(DataController.previewContainer)
    }
}
