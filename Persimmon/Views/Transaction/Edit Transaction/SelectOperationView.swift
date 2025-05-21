import SwiftUI

struct SelectOperationView: View {
    @Binding var selectedType: Transaction.Operation
    
    var body: some View {
        Menu {
            ForEach(Transaction.Operation.allCases) { type in
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
    @Previewable @State var selectedType: Transaction.Operation = .installments
    SelectOperationView(selectedType: $selectedType)
}
