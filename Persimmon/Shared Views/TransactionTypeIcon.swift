import SwiftUI

struct TransactionTypeIcon: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let type: TransactionType
    
    var icon: Image {
        switch type {
        case .buyCredit:
            return Image(systemName: "creditcard")
        case .buyDebit:
            return Image(systemName: "banknote")
        case .transferIn:
            return Image(systemName: "arrow.down.to.line.circle")
        case .transferOut:
            return Image(systemName: "arrow.up.to.line.circle")
        case .adjustment:
            return Image(systemName: "plus.forwardslash.minus")
        }
    }
    
    var foregroundColor: Color {
        switch type {
        case .buyDebit: return .blue
        case .buyCredit: return .red
        case .transferIn: return .green
        case .transferOut: return .yellow
        case .adjustment: return .gray
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(foregroundColor, lineWidth: 1)
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundColor(foregroundColor)
        }.frame(width: 42, height: 42)
    }
}

struct TransactionIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            ForEach(TransactionType.allCases, id: \.self) { type in
                TransactionTypeIcon(type: type)
            }
        }
    }
}
