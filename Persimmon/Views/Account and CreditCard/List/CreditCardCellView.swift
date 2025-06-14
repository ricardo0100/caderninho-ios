//
//  CreditCardCellView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 04/05/25.
//

import SwiftUI
import SwiftData

struct CreditCardCellView: View {
    @EnvironmentObject var card: CreditCard
    
    var body: some View {
        HStack {
            if let icon = card.icon {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32)
            } else {
                LettersIconView(
                    text: card.name.firstLetters(),
                    color: Color(hex: card.color),
                    size: 32)
            }
            
            VStack(alignment: .leading) {
                Text(card.name)
                    .font(.headline)
                if let bill = card.currentBill {
                    Text(bill.total.toCurrency(with: card.currency))
                        .font(.subheadline)
                }
            }
            
            if let bill = card.currentBill {
                Spacer()
                VStack(alignment: .trailing) {
                    HStack(spacing: .spacingNano) {
                        Text("Due:")
                            .font(.caption)
                        Text(bill.dueDate.formatted(date: .numeric, time: .omitted))
                            .font(.caption)
                            .bold()
                    }
                    HStack(spacing: .spacingNano) {
                        Text("Closing:")
                            .font(.caption)
                        Text(bill.closingCycleDate.formatted(date: .numeric, time: .omitted))
                            .foregroundStyle(bill.isDelayed ? Color(.systemRed) : .primary)
                            .font(.caption)
                            .bold()
                    }
                }
            }
        }
    }
}

#Preview {
    let card = try! ModelContainer.preview.mainContext
        .fetch(FetchDescriptor<CreditCard>())[0]
    List {
        CreditCardCellView()
            .environmentObject(card)
    }
}
