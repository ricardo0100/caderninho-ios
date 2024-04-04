import SwiftUI
import Combine

struct EditTransactionView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: EditTransactionViewModel
    @State var value = ""
    
    var body: some View {
        Form {
            LabeledView(labelText: "Name") {
                TextField("Transaction Name", text: $viewModel.name)
            }
            
            NavigationLink {
                SelectTransactionTypeView(selectedType: $viewModel.type)
            } label: {
                if let type = viewModel.type {
                    HStack {
                        Image(systemName: type.iconName)
                        Text(type.text)
                    }
                } else {
                    Text("Select type").foregroundColor(.secondary)
                }
            }

            
            NavigationLink(destination: {
                SelectAccountView(viewModel: SelectAccountViewModel(selectedAccount: $viewModel.selectedAccount))
            }, label: {
                LabeledView(labelText: "Account") {
                    if let account = viewModel.selectedAccount {
                        HStack {
                            LettersIconView(text: account.name.firstLetters(),
                                            color: Color(hex: account.color))
                            .frame(width: 24)
                            Text(account.name)
                        }
                    } else {
                        Text("Select account").foregroundColor(.secondary)
                    }
                }
            })
            
            LabeledView(labelText: "Value") {
                CurrencyTextField(currency: viewModel.selectedAccount?.currency ?? "", value: $viewModel.value)
            }
        }
//            LabelTextField(keyboardType: .decimalPad, label: "Value", placeholder: "", errorMessage: .constant(nil), text: .constant("R$ 1,99"))
//            LabelTextField(keyboardType: .decimalPad, label: "Datetime", placeholder: "", errorMessage: .constant(nil), text: $viewModel.datetime)
//            VStack(alignment: .leading) {
//                Text("Account").font(.subheadline).bold().foregroundColor(.brand)
//                Text(viewModel.location)
//            }

        .toolbar {
            ToolbarItem(placement: .navigation) {
                if let type = viewModel.type {
                    HStack {
                        Image(systemName: type.iconName)
                        Text(type.text)
                    }.foregroundColor(.brand)
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: viewModel.didTapSave).foregroundColor(.brand)
            }
        }.onReceive(viewModel.$shouldDismiss) { shouldDismiss in
            if shouldDismiss { dismiss() }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct EditTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditTransactionView(viewModel: EditTransactionViewModel(transactionId: TransactionInteractorMock.exampleTransactions.randomElement()!.id))
        }
    }
}
