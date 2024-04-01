import SwiftUI
import Combine

struct EditTransactionView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: EditTransactionViewModel
    @State var value = ""
    
    var body: some View {
        Form {
            LabeledView(labelText: "Name") {
                TextField("John", text: $viewModel.name)
            }
            
            NavigationLink(destination: {
                SelectAccountView(viewModel: SelectAccountViewModel(selectedAccount: $viewModel.selectedAccount))
            }, label: {
                LabeledView(labelText: "Account") {
                    HStack {
                        LettersIconView(text: viewModel.accountName.firstLetters(), color: Color(hex: viewModel.accountColor)).frame(width: 24)
                        Text(viewModel.accountName)
                    }
                }
            })
            
            LabeledView(labelText: "Value") {
                CurrencyTextField(currency: viewModel.selectedAccount?.currency ?? "", value: $viewModel.value)
            }
            Text(String(viewModel.value))
        }
//            LabelTextField(keyboardType: .decimalPad, label: "Value", placeholder: "", errorMessage: .constant(nil), text: .constant("R$ 1,99"))
//            LabelTextField(keyboardType: .decimalPad, label: "Datetime", placeholder: "", errorMessage: .constant(nil), text: $viewModel.datetime)
//            VStack(alignment: .leading) {
//                Text("Account").font(.subheadline).bold().foregroundColor(.brand)
//                Text(viewModel.location)
//            }

        .toolbar {
            ToolbarItem(placement: .navigation) {
                HStack {
                    Image(systemName: viewModel.type.iconName)
                    Text(viewModel.type.text)
                }.foregroundColor(.brand)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: viewModel.didTapSave).foregroundColor(.brand)
            }
        }.onReceive(viewModel.$shouldDismiss) { shouldDismiss in
            if shouldDismiss { dismiss() }
        }
    }
}

struct EditTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditTransactionView(viewModel: EditTransactionViewModel(transactionId: TransactionInteractorMock.exampleTransactions.randomElement()!.id))
        }
    }
}
