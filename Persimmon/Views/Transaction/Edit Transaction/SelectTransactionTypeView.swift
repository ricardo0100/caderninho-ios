import SwiftUI

struct SelectTransactionTypeView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedType: Transaction.TransactionType
    
    var body: some View {
        List {
            ForEach(Transaction.TransactionType.allCases) { type in
                HStack {
                    Image(systemName: type.iconName)
                    Text(type.text)
                    if selectedType == type {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }.onTapGesture {
                    selectedType = type
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SelectTransactionTypeView(selectedType: .constant(.buyDebit))
    }
}
