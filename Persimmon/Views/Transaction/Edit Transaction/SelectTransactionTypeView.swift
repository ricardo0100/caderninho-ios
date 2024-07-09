//import SwiftUI
//
//struct SelectTransactionTypeView: View {
//    @Environment(\.dismiss) var dismiss
//    @Binding var selectedType: TransactionType
//    
//    var body: some View {
//        List {
//            ForEach(TransactionType.allCases) { type in
//                HStack {
//                    Image(systemName: type.iconName)
//                    Text(type.text)
//                    if selectedType == type {
//                        Spacer()
//                        Image(systemName: "checkmark")
//                    }
//                }.onTapGesture {
//                    selectedType = type
//                    dismiss()
//                }
//            }
//        }
//    }
//}
//
//struct SelectTransactionTypeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectTransactionTypeView(selectedType: .constant(.transferIn))
//    }
//}
