//
//  CategoryDetails.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 29/07/24.
//

import SwiftUI
import SwiftData

struct CategoryDetailsView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(category: Category) {
        _viewModel = ObservedObject(initialValue: ViewModel(category: category))
    }
    
    var body: some View {
        List {
            Section {} header: {
                PeriodFilterView(
                    startDate: $viewModel.startDate,
                    endDate: $viewModel.endDate)
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
                                      size: 32)
                    } else {
                        LettersIconView(text: viewModel.category.name,
                                        color: Color(hex: viewModel.category.color),
                                        size: 32)
                    }
                    Text(viewModel.category.name)
                        .font(.headline)
                        .tint(.brand)
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Edit") {
                    viewModel.isShowindEdit = true
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowindEdit) {
            EditCategoryView(category: viewModel.category)
        }
    }
}

#Preview {
    let category = try! ModelContainer.preview.mainContext
        .fetch(FetchDescriptor<Category>()).first!
    
    NavigationStack {
        CategoryDetailsView(category: category)
            .modelContext(ModelContainer.preview.mainContext)
    }
}
