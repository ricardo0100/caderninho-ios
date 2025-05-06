import SwiftUI
import SwiftData

struct CategoriesListView: View {
    @Query(sort: [SortDescriptor(\Category.name)])
    var categories: [Category]
    
    @State var isShowindEdit: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(categories) { category in
                        NavigationLink {
                            CategoryDetails().environmentObject(category)
                        } label: {
                            CategoryCell().environmentObject(category)
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowindEdit) {
                EditCategoryView()
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(imageName: "briefcase", title: "Categories")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: didTapAdd) {
                        Image(systemName: "plus")
                            .foregroundColor(.brand)
                    }
                }
            }
        }
    }
    
    func didTapAdd() {
        isShowindEdit = true
    }
}

#Preview {
    NavigationStack {
        CategoriesListView()
            .modelContainer(.preview)
    }
}
