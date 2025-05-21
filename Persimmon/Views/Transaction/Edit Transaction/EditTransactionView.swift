import SwiftUI
import SwiftData

struct EditTransactionView: View {
    enum Field: Hashable {
        case name
        case value
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: ViewModel
    @FocusState private var focusedField: Field?
    
    init(transaction: Transaction?) {
        let viewModel = ViewModel(transaction: transaction, modelContainer: .main)
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
                    LabeledView(labelText: "Type") {
                        SelectOperationView(selectedType: $viewModel.type)
                    }
                    
                    if viewModel.showAccountField {
                        LabeledView(labelText: "Account", error: $viewModel.accountError) {
                            SelectAccountView(selected: $viewModel.account)
                        }
                    }
                    
                    if viewModel.showCardField {
                        LabeledView(labelText: "Card", error: $viewModel.cardError) {
                            SelectCardView(selected: $viewModel.card)
                        }
                        LabeledView(labelText: "Number of installments") {
                            Stepper("\(viewModel.numberOfInstallments)",
                                    value: $viewModel.numberOfInstallments,
                                    in: 1...36)
                        }
                    }
                    
                    LabeledView(labelText: "Value") {
                        if let currency = viewModel.account?.currency ?? viewModel.card?.currency {
                            CurrencyTextField(currency: currency,
                                              value: $viewModel.value,
                                              font: .title2)
                            .focused($focusedField, equals: .value)
                            if viewModel.type == .installments {
                                Text(viewModel.installmentsDescription)
                                    .font(.callout)
                            }
                        }
                    }
                    
                    LabeledView(labelText: "Category") {
                        SelectCategoryView(selected: $viewModel.category)
                    }
                    
                    LabeledView(labelText: "Date and Time") {
                        let picker = SelectDateView(isShowing: .constant(true), date: $viewModel.date)
                        NavigationLink(destination: picker) {
                            Text(viewModel.date.formatted(date: .complete, time: .shortened)).font(.footnote)
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
                if viewModel.showDeleteButton {
                    Section {
                        Button("Delete Transaction", action: viewModel.didTapDelete)
                            .tint(.red)
                    }
                }
            }
            .gesture(TapGesture().onEnded({ _ in
                focusedField = nil
            }), isEnabled: focusedField != nil)
            .confirmationDialog("Delete?", isPresented: $viewModel.showDeleteAlert) {
                Button("Delete") {
                    viewModel.didConfirmDelete()
                }.tint(.red)
                Button("Cancel") {
                    viewModel.didTapCancelDelete()
                }
            }
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
    EditTransactionView(transaction: nil)
        .modelContainer(.preview)
}

#Preview {
    let transaction = try! ModelContainer.preview.mainContext
        .fetch(FetchDescriptor<Transaction>())[0]
    EditTransactionView(transaction: transaction)
        .modelContainer(.preview)
}
