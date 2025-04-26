import SwiftUI

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = ObservedObject(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledView(labelText: "Name", error: $viewModel.nameError) {
                        TextField("Transaction Name", text: $viewModel.name)
                    }
                    
                    LabeledView(labelText: "Type") {
                        NavigationLink {
                            SelectTransactionTypeView(selectedType: $viewModel.type)
                        } label: {
                            HStack(spacing: .spacingSmall) {
                                Image(systemName: viewModel.type.iconName)
                                Text(viewModel.type.text)
                            }
                        }
                    }
                    
                    if viewModel.type == .buyCredit {
                        LabeledView(labelText: "Number of shares") {
                            HStack {
                                Stepper("", value: $viewModel.shares, in: 1...36).labelsHidden()
                                Text("\(viewModel.shares)").bold()
                            }
                        }
                    }
                    
                    LabeledView(labelText: "Account", error: $viewModel.accountError) {
                        NavigationLink(destination: {
                            SelectAccountView(selected: $viewModel.account)
                        }, label: {
                            if let account = viewModel.account {
                                AccountCellView().environmentObject(account)
                            } else {
                                Text("Select account").foregroundColor(.secondary)
                            }
                        })
                    }
                    
                    LabeledView(labelText: "Value") {
                        CurrencyTextField(currency: viewModel.account?.currency ?? "",
                                          value: $viewModel.value,
                                          font: .title2)
                        if viewModel.type == .buyCredit {
                            let currency = viewModel.account?.currency ?? ""
                            let value = Double(viewModel.value / Double(viewModel.shares))
                            Text("\(viewModel.shares) x \(value.toCurrency(with: currency))")
                                .font(.callout)
                        }
                    }
                    
                    LabeledView(labelText: "Category") {
                        NavigationLink {
                            SelectCategoryView(selected: $viewModel.category)
                        } label: {
                            if let category = viewModel.category {
                                CategoryCell().environmentObject(category)
                            } else {
                                Text("Select category").foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    LabeledView(labelText: "Date and Time") {
                        let picker = SelectDateView(date: $viewModel.date)
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
    }
}

#Preview {
    EditTransactionView(viewModel: .init())
        .modelContainer(DataController.previewContainer)
}
