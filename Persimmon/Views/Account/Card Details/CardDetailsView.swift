//
//  CardDetailsView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 05/05/25.
//

import SwiftUI

struct CardDetailsView: View {
    @EnvironmentObject var card: CreditCard
    @State var showEditing = false
    
    var body: some View {
        List {
            Text(card.name)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Edit") {
                    showEditing = true
                }
            }
        }
        .sheet(isPresented: $showEditing) {
            EditCreditCardView(creditCard: card)
        }
    }
}

#Preview {
    NavigationStack {
        CardDetailsView()
            .environment(DataController.createRandomCreditCard())
    }
}
