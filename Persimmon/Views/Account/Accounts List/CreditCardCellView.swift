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
            LettersIconView(
                text: card.name.firstLetters(),
                color: Color(hex: card.color),
                size: 32)
            VStack(alignment: .leading) {
                Text(card.name)
                    .font(.headline)
                Text("Due: 10/05")
                    .font(.caption)
                Text("Closing: 03/05")
                    .font(.caption)
            }
            Spacer()
            Text(3184.17.toCurrency(with: card.currency)).bold()
        }
    }
}

#Preview {
    List {
        CreditCardCellView()
            .environment(DataController.createRandomCreditCard())
        CreditCardCellView()
            .environment(DataController.createRandomCreditCard())
        CreditCardCellView()
            .environment(DataController.createRandomCreditCard())
    }
}
