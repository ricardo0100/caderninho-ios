import SwiftUI
import SwiftData

struct TransactionCellView: View {
    @EnvironmentObject var transaction: Transaction
    
    var body: some View {
        HStack(spacing: .spacingSmall) {
            VStack(alignment: .leading) {
                Text(transaction.name)
                    .font(.headline)
                Text(transaction.value.toCurrency(with: transaction.currency ?? "$"))
                    .font(.subheadline)
                HStack(spacing: .spacingSmall) {
                    Image(systemName: transaction.operation.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12)
                    Text(transaction.operation.text)
                        .font(.caption2)
                }
                if transaction.operation == .installments {
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
                Text(transaction.date.formatted(date: .numeric, time: .omitted))
                    .font(.caption2)
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
