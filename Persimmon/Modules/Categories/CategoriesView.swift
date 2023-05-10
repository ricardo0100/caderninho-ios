import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel = CategoriesViewModelMock()
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.categories) { category in
                    CategoryCell(category: category)
                }
            } header: {
                CategoriesHeaderView()
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.grouped)
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
