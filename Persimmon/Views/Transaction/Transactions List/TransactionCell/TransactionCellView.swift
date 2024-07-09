//import SwiftUI
//
//struct TransactionCellView: View {
//    @ObservedObject var viewModel: TransactionCellViewModel
//    
//    init(transactionID: UUID) {
//        viewModel = TransactionCellViewModel(transactionId: transactionID)
//    }
//    
//    var body: some View {
//        if let account = viewModel.account, let transaction = viewModel.transaction {
//            HStack(spacing: .spacingBig) {
//                Image(systemName: transaction.type.iconName)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 24, height: 24)
//                VStack(alignment: .leading, spacing: .spacingSmall) {
//                    HStack {
//                        Text(transaction.name)
//                            .font(.headline)
//                        Spacer()
//                        Text(transaction.type.text)
//                            .font(.caption)
//                    }
//                    HStack {
//                        Text("\(account.currency) \(transaction.value.formatted())")
//                            .font(.subheadline)
//                        Spacer()
//                        HStack(spacing: .spacingSmall) {
//                            Text("\(account.name)")
//                                .font(.subheadline)
//                            LettersIconView(text: account.name.firstLetters(), color: Color(hex: account.color), size: 16)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct TransactionCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        List {
//            TransactionCellView(transactionID: TransactionModel.randomID()).padding()
//            TransactionCellView(transactionID: TransactionModel.randomID()).padding()
//        }
//    }
//}
