//
//  EditCreditCardView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 04/05/25.
//

import SwiftUI
import SwiftData

struct EditCreditCardView: View {
    enum Field: Hashable {
        case name
        case currency
    }
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @FocusState private var focusedField: Field?
    @ObservedObject var viewModel: ViewModel
    
    init(creditCard: CreditCard?) {
        viewModel = .init(creditCard: creditCard)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                LabeledView(labelText: "Card name", error: $viewModel.nameError) {
                    TextField("Name", text: $viewModel.name)
                        .focused($focusedField, equals: .name)
                }
                
                LabeledView(labelText: "Currency", error: $viewModel.currencyError) {
                    TextField("$", text: $viewModel.currency)
                        .focused($focusedField, equals: .currency)
                }
                
                LabeledView(labelText: "Color") {
                    Circle()
                        .fill()
                        .foregroundColor(viewModel.niceColor.color)
                        .frame(width: 20, height: 20)
                }.onTapGesture {
                    viewModel.isShowingColorPicker = true
                }
                
                LabeledView(labelText: "Closing cycle") {
                    Menu {
                        ForEach(1..<31) { day in
                            Button {
                                viewModel.closingCycleDay = day
                            } label: {
                                Text("Day \(day)")
                            }
                        }
                    } label: {
                        Text("Day \(viewModel.closingCycleDay)")
                            .foregroundStyle(Color.brand)
                    }
                }
                
                LabeledView(labelText: "Due") {
                    Menu {
                        ForEach(1..<31) { day in
                            Button {
                                viewModel.dueDay = day
                            } label: {
                                Text("Day \(day)")
                            }
                        }
                    } label: {
                        Text("Day \(viewModel.dueDay)")
                            .foregroundStyle(Color.brand)
                    }
                }
                
                if viewModel.creditCard != nil {
                    Section {
                        Button("Delete card") {
                            viewModel.showDeleteAlert = true
                        }.tint(.red)
                    }
                }
            }
            .onChange(of: viewModel.shouldDismiss) {
                dismiss()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: viewModel.didTapSave)
                }
            }
            .sheet(isPresented: $viewModel.isShowingColorPicker) {
                NiceColorPicker(selected: $viewModel.niceColor)
            }
            .confirmationDialog("Delete?",
                                isPresented: $viewModel.showDeleteAlert) {
                Button("Delete", role: .destructive, action: viewModel.didConfirmDelete)
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

#Preview {
    EditCreditCardView(creditCard: nil)
}

#Preview {
    @Previewable @Query var cards: [CreditCard]
    
    EditCreditCardView(creditCard: cards.first!)
}
