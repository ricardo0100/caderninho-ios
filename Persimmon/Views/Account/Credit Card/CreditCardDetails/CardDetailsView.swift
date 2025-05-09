//
//  CardDetailsView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 05/05/25.
//

import SwiftUI
import SwiftData

struct CardDetailsView: View {
    @EnvironmentObject var card: CreditCard
    @State var showEditing = false
    @State var selectedBill: Bill?
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Bill", selection: $selectedBill) {
                ForEach(card.bills.sorted(
                    by: { $1.year > $0.year || $1.month > $0.month }
                )) { bill in
                    Text("\(bill.month) / \(bill.year)").tag(bill)
                }
            }
            
            List {
                ForEach(selectedBill?.installments ?? [], id: \.self) { installment in
                    InstallmentCellView()
                        .environmentObject(installment)
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
        .onAppear {
            selectedBill = card.bills.first
        }
    }
}

#Preview {
    let card = try! ModelContainer.preview.mainContext
        .fetch( FetchDescriptor<CreditCard>())[0]
    NavigationStack {
        CardDetailsView().environmentObject(card)
    }
}
