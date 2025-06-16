//
//  NewTransactionName.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 27/05/25.
//


import SwiftUI
import SwiftData

struct NewTransactionNameView: View {
    @Environment(\.modelContext) var modelContext: ModelContext
    @EnvironmentObject var navigation: NavigationModel
    
    enum Field: Hashable {
        case name
    }
    @FocusState private var focusedField: Field?
    
    let operation: Transaction.EditOperation
    
    @State var name: String = ""
    @State var nameError: String?
    @Query var categories: [Category]
    @State var selectedCategory: Category?
    
    var body: some View {
        List {
            Section {
                LabeledView(labelText: "Name", error: $nameError) {
                    TextField("", text: $name)
                        .font(.title2)
                        .focused($focusedField, equals: .name)
                        .labelsHidden()
                }
                .onAppear {
                    focusedField = .name
                }
            }
            Section {
                LabeledView(labelText: "Category") {
                    SelectCategoryView(selected: $selectedCategory)
                }
            }
            Section {} footer: {
                Button("Save") {
                    if name.isEmpty {
                        nameError = "Give this transaction a name"
                        return
                    }
                    nameError = nil
                    saveTransaction()
                }
                .font(.title2)
                .buttonStyle(.borderedProminent)
            }
            .textCase(.none)
            .frame(maxWidth: .infinity)
        }
    }
    
    private func saveTransaction() {
        do {
            try ModelManager(context: modelContext)
                .createTransaction(
                    name: name,
                    date: Date(),
                    editOperation: operation,
                    category: selectedCategory,
                    place: nil)
            navigation.newTransaction = false
            navigation.newTransactionWithCard = nil
            navigation.newTransactionWithAccount = nil
        } catch {
            print(error.localizedDescription)
        }
    }
}
