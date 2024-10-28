//
//  CategoryDetails.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 29/07/24.
//

import SwiftUI
import SwiftData

struct CategoryDetails: View {
    @State var category: Category
    @State var isShowindEdit: Bool = false
    
    init(category: Category) {
        self.category = category
    }
    
    var body: some View {
        List {
            Section {
                if category.transactions.isEmpty {
                    Text("No transactions yet!").foregroundColor(.gray)
                } else {
                    ForEach(category.transactions) { transaction in
                        NavigationLink(destination: {
                            TransactionDetailsView(transaction: transaction)
                        }) {
                            TransactionCellView(transaction: transaction)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
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
                    Text(category.name)
                        .font(.headline)
                        .tint(.brand)
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Edit") {
                    isShowindEdit = true
                }
            }
        }
        .sheet(isPresented: $isShowindEdit) {
            EditCategoryView(category: category)
        }
        .tint(.brand)
    }
}

#Preview {
    NavigationStack {
        CategoryDetails(category: DataController.createRandomCategory(withIcon: true))
            .modelContainer(DataController.previewContainer)
    }
}
