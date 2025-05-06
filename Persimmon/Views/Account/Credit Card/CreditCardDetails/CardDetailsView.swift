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
    @State var selectedBill: Bill?
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Bill", selection: $selectedBill) {
                Text("12/2025").tag(0)
                Text("01/2025").tag(1)
                Text("02/2025").tag(2)
                Text("04/2025").tag(4)
                Text("05/2025").tag(5)
                Text("06/2025").tag(6)
                Text("07/2025").tag(7)
                Text("08/2025").tag(8)
                Text("09/2025").tag(9)
            }
            List {
                ForEach(0...10, id: \.self) { _ in
                    InstallmentCellView()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    LettersIconView(text: card.name.firstLetters(),
                                    color: Color(hex: card.color))
                    Text(card.name)
                        .font(.headline)
                }
            }
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
