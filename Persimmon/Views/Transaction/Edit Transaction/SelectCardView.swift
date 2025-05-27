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
                    if let icon = card.icon {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                    } else {
                        LettersIconView(text: card.name, color: Color(hex: card.color))
                    }
                    Text(card.name).foregroundStyle(Color.brand)
                }
            }
        } label: {
            HStack {
                if let card = selected {
                    Text(card.name).foregroundStyle(Color.brand)
                    if let icon = card.icon {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                    } else {
                        LettersIconView(text: card.name, color: Color(hex: card.color))
                    }
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
