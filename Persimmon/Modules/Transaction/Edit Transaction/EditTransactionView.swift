import SwiftUI
import Combine
import MapKit

struct EditTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EditTransactionViewModel
    
    var body: some View {
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
                
                LabeledView(labelText: "Account", error: $viewModel.accountError) {
                    NavigationLink(destination: {
                        SelectAccountView(viewModel: SelectAccountViewModel(selectedAccount: $viewModel.selectedAccount))
                    }, label: {
                        if let account = viewModel.selectedAccount {
                            HStack(spacing: .spacingSmall) {
                                LettersIconView(text: account.name.firstLetters(),
                                                color: Color(hex: account.color))
                                Text(account.name)
                            }
                        } else {
                            Text("Select account").foregroundColor(.secondary)
                        }
                    })
                }
                
                LabeledView(labelText: "Value") {
                    CurrencyTextField(currency: viewModel.selectedAccount?.currency ?? "",
                                      value: $viewModel.value)
                }
                
                LabeledView(labelText: "Date and Time") {
                    let picker = SelectDateView(date: $viewModel.date)
                    NavigationLink(destination: picker) {
                        VStack(alignment: .leading) {
                            Text(viewModel.date.formatted(date: .complete, time: .omitted))
                            Text(viewModel.date.formatted(date: .omitted, time: .shortened)).font(.footnote)
                        }
                    }
                }
                
                LabeledView(labelText: "Location") {
                    NavigationLink {
                        SelectLocationView(viewModel: SelectLocationViewModel(selectedLocation: $viewModel.place))
                    } label: {
                        if let place = viewModel.place {
                            VStack(alignment: .leading) {
                                Text(place.title).foregroundColor(.primary)
                                Text(place.subtitle).font(.footnote)
                            }
                        } else {
                            Text("Select a Place").foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("Cancel", action: viewModel.didTapCancel)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: viewModel.didTapSave)
            }
        }
        .onReceive(viewModel.$shouldDismiss) { shouldDismiss in
            if shouldDismiss { dismiss() }
        }
        .tint(.brand)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: viewModel.didAppear)
    }
}

struct EditTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditTransactionView(viewModel: EditTransactionViewModel(transactionId: TransactionInteractorMock.exampleTransactions.first!.id))
        }
    }
}
