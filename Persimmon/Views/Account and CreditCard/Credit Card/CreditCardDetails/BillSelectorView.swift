//
//  BillSelectorView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 10/05/25.
//
import SwiftUI
import SwiftData

struct BillSelectorView: View {
    @Binding var selected: Bill?
    let card: CreditCard

    init(selected: Binding<Bill?>, card: CreditCard) {
        self._selected = selected
        self.card = card
    }
    
    func bottomColor(for bill: Bill) -> Color {
        let color: Color
        if bill.payedDate != nil {
            color = .green
        } else if bill.isDelayed {
            color = .red
        } else if card.currentBill == bill {
            color = .blue
        } else {
            color = .gray
        }
        return color
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: .spacingMedium) {
                    ForEach(card.bills.filter { !$0.installments.isEmpty }.sorted()) { bill in
                        let year = String(format: "%i", bill.dueYear)
                        let month = Date.shortMonthName(from: bill.dueMonth)
                        let value = bill.total.toCurrency(with: card.currency)
                        VStack(spacing: .spacingNano) {
                            VStack {
                                Text("\(month) \(year)")
                                Text(value)
                                    .font(.caption)
                            }
                            .padding(.spacingSmall)
                            Rectangle()
                                .foregroundStyle(bottomColor(for: bill))
                                .frame(height: 1.5)
                        }
                        .foregroundStyle(Color.primary)
                        .padding(.top, .spacingSmall)
                        .background(bill == selected ? Color.gray.opacity(0.7) : .gray.opacity(0.2))
                        .cornerRadius(.spacingNano)
                        .frame(minWidth: 90)
                        .onTapGesture {
                            withAnimation {
                                selected = bill
                                proxy.scrollTo(bill.id, anchor: .center)
                            }
                        }
                        .id(bill.id)
                    }
                }
                .padding(.bottom, .spacingMedium)
            }
            .onAppear {
                if let selected = selected {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            proxy.scrollTo(selected.id, anchor: .center)
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    @Previewable @State var selected: Bill?
    let card = try! ModelContainer.preview.mainContext.fetch(FetchDescriptor<CreditCard>()).first!
    
    List {
        Section {
            
        } header: {
            BillSelectorView(selected: $selected, card: card)
                .listRowInsets(EdgeInsets())
                .padding(.bottom, .spacingMedium)
        }
    }
}
