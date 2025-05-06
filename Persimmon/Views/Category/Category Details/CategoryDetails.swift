//
//  CategoryDetails.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 29/07/24.
//

import SwiftUI
import SwiftData

struct CategoryDetails: View {
    @EnvironmentObject var category: Category
    @State var isShowindEdit: Bool = false
    
    var body: some View {
        List {
            Section {
                if category.transactions.isEmpty {
                    Text("No transactions yet!").foregroundColor(.gray)
                } else {
                    ForEach(category.transactions) { transaction in
                        NavigationLink(destination: {
                            TransactionDetailsView().environmentObject(transaction)
                        }) {
                            TransactionCellView().environmentObject(transaction)
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
    }
}

#Preview {
    NavigationStack {
        CategoryDetails()
            .environmentObject(DataController.createRandomCategory(withIcon: true))
            .modelContainer(.preview)
    }
}
