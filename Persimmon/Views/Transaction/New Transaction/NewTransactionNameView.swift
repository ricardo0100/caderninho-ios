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
            } header: {
                HStack {
                    if let icon = operation.accountOrCardIcon {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: operation.operation.iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18)
                            Text(operation.operation.text)
                        }
                        Text(operation.description)
                            .font(.caption)
                    }
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

#Preview {
    NewTransactionNameView(
        operation: .installments(
            card: CreditCard(id: UUID(),
                             name: "Credit Card",
                             color: "#0077FF",
                             icon: "caixa",
                             currency: "R$",
                             closingCycleDay: 3,
                             dueDay: 10),
            numberOfInstallments: 3,
            value: 1234))
}
