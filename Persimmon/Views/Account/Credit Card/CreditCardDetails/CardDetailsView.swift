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
    @State var isPayed = false
    
    var body: some View {
        List {
            Section {
                ForEach(selectedBill?.installments ?? [], id: \.self) { installment in
                    InstallmentCellView()
                        .environmentObject(installment)
                }
            } header: {
                VStack(alignment: .leading) {
                    BillSelectorView(selected: $selectedBill, bills: card.bills, card: card)
                    if let bill = selectedBill {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Bill value:")
                                    Text(bill.total.toCurrency(with: card.currency)).bold()
                                }
                                .foregroundStyle(Color.primary)
                                .font(.subheadline)
                                Spacer()
                                HStack {
                                    Text("Closing date:")
                                    Text(bill.closingCycleDate.formatted(date: .abbreviated, time: .omitted)).bold()
                                }
                                HStack {
                                    Text("Due date")
                                    Text(bill.dueDate.formatted(date: .abbreviated, time: .omitted)).bold()
                                }
                            }.font(.caption)
                            Spacer()
                            VStack {
                                if let payedDate = bill.payedDate {
                                    Button("Payed in \(payedDate.formatted(date: .abbreviated, time: .omitted))") {
                                        bill.payedDate = nil
                                    }.font(.caption)
                                } else {
                                    Button("Set Payed") {
                                        bill.payedDate = Date()
                                    }
                                    .font(.footnote)
                                    .buttonStyle(BorderedProminentButtonStyle())
                                    .buttonBorderShape(.capsule)
                                }
                                if bill.isDelayed {
                                    Text("Delayed!")
                                        .foregroundStyle(Color.red)
                                }
                            }
                        }
                    }
                }
                .textCase(.none)
                .listRowInsets(EdgeInsets())
                .padding(.bottom)
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
            selectedBill = card.currentBill
        }
    }
}

#Preview {
    let card = try! ModelContainer.preview.mainContext
        .fetch( FetchDescriptor<CreditCard>())[0]
    NavigationStack {
        CardDetailsView()
            .environmentObject(card)
    }
}
