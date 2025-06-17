import SwiftUI
import SwiftData

struct TransactionCellView: View {
    @EnvironmentObject var transaction: Transaction
    
    var body: some View {
        let operation = Transaction.Operation(rawValue:  transaction.operation)!
        
        HStack(spacing: .spacingSmall) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: operation.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12)
                    Text(transaction.name)
                        .font(.headline)
                }
                Text(transaction.value.toCurrency(with: transaction.currency ?? "$"))
                    .font(.subheadline)
                    .bold()
                if operation == .installments {
                    let val = transaction.installments.first?.value ?? 0
                    Text("\(transaction.installments.count) x \(val.toCurrency(with: transaction.currency ?? "$"))")
                        .font(.caption2)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack(spacing: .spacingSmall) {
                    let name = transaction.accountOrCardName ?? ""
                    Text("\(name)")
                        .font(.subheadline)
                    if let icon = transaction.accountOrCardIcon {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                    } else {
                        let color = transaction.accountOrCardColor ?? ""
                        LettersIconView(text: name.firstLetters(),
                                        color: Color(hex: color),
                                        size: 16)
                    }
                }
                if let category = transaction.category {
                    HStack(spacing: .spacingSmall) {
                        Text(category.name)
                            .font(.caption2)
                        if let icon = transaction.category?.icon {
                            ImageIconView(image: Image(systemName: icon),
                                          color: Color(hex: category.color),
                                          size: 16)
                        } else {
                            LettersIconView(text: category.name.firstLetters(),
                                            color: Color(hex: category.color),
                                            size: 16)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let transactions = try! ModelContainer.preview.mainContext
        .fetch(FetchDescriptor<Transaction>())
    List(transactions, id: \.self) {
        TransactionCellView()
            .environmentObject($0)
    }.modelContainer(.preview)
}
