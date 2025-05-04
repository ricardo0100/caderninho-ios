import SwiftUI

struct SelectTransactionTypeView: View {
    @Binding var selectedType: Transaction.TransactionType
    
    var body: some View {
        Menu {
            ForEach(Transaction.TransactionType.allCases) { type in
                Button {
                    selectedType = type
                } label: {
                    Label(type.text, systemImage: type.iconName)
                }
            }
        } label: {
            Label(selectedType.text, systemImage: selectedType.iconName)
        }
    }
}

#Preview {
    @Previewable @State var selectedType: Transaction.TransactionType = .buyDebit
    SelectTransactionTypeView(selectedType: $selectedType)
}
