import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel = CategoriesViewModelMock()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.categories) { category in
                        NavigationLink {
                            Text("👽")
                        } label: {
                            CategoryCell(category: category)
                        }

                        
                    }
                } header: {
                    CategoriesHeaderView(addAction: viewModel.didTapAdd)
                        .textCase(nil)
                }
            }
            .sheet(isPresented: $viewModel.showingSheet) {
                AddCategoryView()
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    HStack {
                        Image(systemName: "briefcase")
                            .foregroundColor(.brand)
                        Text("Categories")
                            .foregroundColor(.brand)
                            .font(.title)
                    }
                }
            }
        }
    }
}

struct CategoryCell: View {
    let category: CategoryItem
    
    var body: some View {
        HStack {
            ImageIconView(image: Image(systemName: category.icon), color: category.color.color)
            VStack(alignment: .leading) {
                Text(category.name)
                    .font(.headline)
                Text("R$ \(category.total.formatted())")
                    .font(.subheadline)
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CategoriesView(viewModel: CategoriesViewModelMock())
        }
    }
}
