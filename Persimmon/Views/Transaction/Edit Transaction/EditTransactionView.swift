import SwiftUI

struct EditTransactionView: View {
    enum Field: Hashable {
        case name
        case value
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: ViewModel
    @FocusState private var focusedField: Field?
    
    init(viewModel: ViewModel) {
        _viewModel = ObservedObject(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledView(labelText: "Name", error: $viewModel.nameError) {
                        TextField("Transaction Name", text: $viewModel.name)
                            .focused($focusedField, equals: .name)
                    }
                    
                    LabeledView(labelText: "Account", error: $viewModel.accountError) {
                        SelectAccountView(selected: $viewModel.account)
                    }
                    
                    LabeledView(labelText: "Type") {
                        SelectTransactionTypeView(selectedType: $viewModel.type)
                    }
                    
                    if viewModel.type == .buyCredit {
                        LabeledView(labelText: "Number of installments") {
                            Stepper("\(viewModel.shares)",
                                    value: $viewModel.shares,
                                    in: 1...36)
                        }
                    }
                    
                    LabeledView(labelText: "Value") {
                        CurrencyTextField(currency: viewModel.account?.currency ?? "",
                                          value: $viewModel.value,
                                          font: .title2)
                            .focused($focusedField, equals: .value)
                        
                        if viewModel.type == .buyCredit {
                            let currency = viewModel.account?.currency ?? ""
                            let value = Double(viewModel.value / Double(viewModel.shares))
                            Text("\(viewModel.shares) x \(value.toCurrency(with: currency))")
                                .font(.callout)
                        }
                    }
                    
                    LabeledView(labelText: "Category") {
                        SelectCategoryView(selected: $viewModel.category)
                    }
                    
                    LabeledView(labelText: "Date and Time") {
                        let picker = SelectDateView(isShowing: .constant(true), date: $viewModel.date)
                        NavigationLink(destination: picker) {
                            VStack(alignment: .leading) {
                                Text(viewModel.date.formatted(date: .complete, time: .omitted))
                                Text(viewModel.date.formatted(date: .omitted, time: .shortened))
                            }.font(.footnote)
                        }
                    }
                    
                    LabeledView(labelText: "Location") {
                        NavigationLink {
                            SelectLocationView(place: $viewModel.place)
                        } label: {
                            if let place = viewModel.place {
                                VStack(alignment: .leading) {
                                    Text(place.name ?? "")
                                        .foregroundColor(.primary)
                                    if let subtitle = place.title {
                                        Text(subtitle).font(.footnote)
                                    }
                                }
                            } else {
                                Text("Select a Place")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                if viewModel.transaction != nil {
                    Section {
                        Button("Delete Transaction", action: viewModel.didTapDelete)
                            .tint(.red)
                    }
                }
            }
            .gesture(TapGesture().onEnded({ _ in
                focusedField = nil
            }), isEnabled: focusedField != nil)
            .confirmationDialog("Delete?", isPresented: $viewModel.showDeleteAlert, actions: {
                Button("Delete") {
                    viewModel.didConfirmDelete()
                }.tint(.red)
                Button("Cancel") {
                    viewModel.didTapCancelDelete()
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Cancel", action: viewModel.didTapCancel)
                }
                if viewModel.isRecognizingImage {
                    ToolbarItem(placement: .secondaryAction) {
                        ProgressView()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: viewModel.didTapSave)
                }
            }
        }
        .tint(.brand)
        .onChange(of: viewModel.shouldDismiss) {
            dismiss()
        }
        .onAppear(perform: viewModel.viewDidAppear)
    }
}

#Preview {
    EditTransactionView(viewModel: .init())
        .modelContainer(DataController.previewContainer)
}
