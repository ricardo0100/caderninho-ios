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
                    .frame(width: 24)
            } else {
                LettersIconView(
                    text: card.name.firstLetters(),
                    color: Color(hex: card.color),
                    size: 32)
            }
            
            VStack(alignment: .leading) {
                Text(card.name)
                    .font(.subheadline)
                Text("Due: 10/05")
                    .font(.caption)
                Text("Closing: 03/05")
                    .font(.caption)
            }
            Spacer()
            if let bill = card.currentBill {
                VStack(alignment: .leading) {
                    Text("Current bill:")
                        .font(.caption2)
                    Text(bill.total.toCurrency(with: card.currency))
                        .font(.caption)
                        .bold()
                    if bill.isDelayed {
                        Text("Delayed!")
                            .foregroundStyle(Color.red)
                    }
                    Text("Total card debits")
                        .font(.caption2)
                    Text(card.totalDebit.toCurrency(with: card.currency))
                        .font(.caption)
                        .bold()
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
