//
//  CategoryDetails.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 29/07/24.
//

import SwiftUI

struct CategoryDetails: View {
    @State var category: Category
    @State var isShowindEdit: Bool = false
    
    var body: some View {
        VStack {
            if let icon = category.icon {
                ImageIconView(image: Image(systemName: icon),
                              color: Color(hex: category.color),
                              size: 54)
            } else {
                LettersIconView(text: category.name, color: Color(hex: category.color), size: 54)
            }
            Text(category.name)
                .font(.headline)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Edit") {
                    isShowindEdit = true
                }
            }
        }
        .sheet(isPresented: $isShowindEdit) {
            EditCategoryView(category: category)
        }
    }
}

#Preview {
    CategoryDetails(category: DataController.createRandomCategory(withIcon: false))
}
