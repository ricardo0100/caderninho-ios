//
//  FilteredCategoriesList.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 07/06/25.
//

import SwiftUI
import SwiftData

struct FilteredCategoriesListView: View {
    @Query var categories: [Category]
    
    init(
        startDate: Date,
        endDate: Date,
        currency: String
    ) {
        
    }
    
    var body: some View {
        if categories.isEmpty {
            Text("No categories!")
        }
        ForEach(categories, id: \.self) { category in
            NavigationLink(value: category) {
                CategoryCellView(category: category, total: "sdsds")
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            FilteredCategoriesListView(
                startDate: .distantPast,
                endDate: .distantFuture,
                currency: "R$")
        }
        .modelContainer(.preview)
    }
}
