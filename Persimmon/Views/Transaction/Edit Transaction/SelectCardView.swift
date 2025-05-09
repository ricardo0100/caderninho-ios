//
//  SelectCardView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 07/05/25.
//

import SwiftUI
import SwiftData

struct SelectCardView: View {
    @Query var cards: [CreditCard]
    @Binding var selected: CreditCard?
    
    var body: some View {
        Menu {
            ForEach(cards, id: \.self) { card in
                Button {
                    selected = card
                } label: {
                    Text(card.name)
                }
            }
        } label: {
            HStack {
                if let card = selected {
                    LettersIconView(text: card.name, color: Color(hex: card.color))
                    Text(card.name).foregroundStyle(Color.brand)
                } else {
                    Text("Select a card")
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var card: CreditCard? = nil
    SelectCardView(selected: $card)
        .modelContainer(.preview)
}
