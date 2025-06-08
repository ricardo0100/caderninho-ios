//
//  CategoryDetails.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 29/07/24.
//

import SwiftUI
import SwiftData

struct CategoryDetailsView: View {
    @EnvironmentObject var navigation: CategoriesNavigation
    @ObservedObject var viewModel: ViewModel
    
    init(category: Category) {
        _viewModel = ObservedObject(initialValue: ViewModel(category: category))
    }
    
    var body: some View {
        List {
            Section {} header: {
                VStack {
                    Text(viewModel.startDate.formatted())
                    Text(viewModel.endDate.formatted())
                    PeriodFilterView(
                        startDate: $viewModel.startDate,
                        endDate: $viewModel.endDate)
                }
            }
            .listRowInsets(EdgeInsets())
            .textCase(.none)

            FilteredTransactionsListView(
                startDate: viewModel.startDate,
                endDate: viewModel.endDate,
                searchText: viewModel.debouncedSearchText,
                categoryId: viewModel.category.id)
        }
        .searchable(text: $viewModel.searchText)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    if let icon = viewModel.category.icon {
                        ImageIconView(image: Image(systemName: icon),
                                      color: Color(hex: viewModel.category.color),
                                      size: 24)
                    } else {
                        LettersIconView(text: viewModel.category.name,
                                        color: Color(hex: viewModel.category.color),
                                        size: 24)
                    }
                    Text(viewModel.category.name)
                        .font(.headline)
                        .tint(.brand)
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Edit") {
                    navigation.editingCategory = viewModel.category
                }
            }
        }
        .sheet(item: $navigation.editingCategory) {
            EditCategoryView(category: $0)
        }
    }
}

#Preview {
    let category = try! ModelContainer.preview.mainContext
        .fetch(FetchDescriptor<Category>()).first { $0.transactions.count > 0 }!
    
    NavigationStack {
        CategoryDetailsView(category: category)
            .modelContext(ModelContainer.preview.mainContext)
    }
}
