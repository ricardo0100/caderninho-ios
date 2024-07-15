import SwiftUI
import SwiftData

struct TransactionCellView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: .spacingBig) {
            Image(systemName: transaction.type.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
            VStack(alignment: .leading, spacing: .spacingSmall) {
                HStack {
                    Text(transaction.name)
                        .font(.headline)
                    Spacer()
                    Text(transaction.type.text)
                        .font(.caption)
                }
                HStack {
                    Text(transaction.value.toCurrency(with: transaction.account.currency))
                        .font(.subheadline)
                    Spacer()
                    HStack(spacing: .spacingSmall) {
                        Text("\(transaction.account.name)")
                            .font(.subheadline)
                        LettersIconView(text: transaction.account.name.firstLetters(), color: Color(hex: transaction.account.color), size: 16)
                    }
                }
            }
        }
    }
}

#Preview {
    List {
        TransactionCellView(transaction: DataController.createRandomTransaction())
        TransactionCellView(transaction: DataController.createRandomTransaction())
        TransactionCellView(transaction: DataController.createRandomTransaction())
    }
}
