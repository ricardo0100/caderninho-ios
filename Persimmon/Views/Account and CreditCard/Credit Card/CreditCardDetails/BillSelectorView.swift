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
    let bills: [Bill]
    let card: CreditCard

    init(selected: Binding<Bill?>, bills: [Bill], card: CreditCard) {
        self._selected = selected
        self.card = card
        self.bills = bills.sorted()
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
                    ForEach(bills) { bill in
                        let year = String(format: "%i", bill.dueYear)
                        let month = Date.shortMonthName(from: bill.dueMonth)
                        VStack(spacing: .spacingNano) {
                            Text("\(month) \(year)")
                                .frame(height: 32)
                                .padding([.leading, .trailing], .spacingMedium)
                                .foregroundStyle(Color.primary)
                            Rectangle()
                                .foregroundStyle(bottomColor(for: bill))
                                .frame(height: 1.5)
                        }
                        .padding(.top, .spacingSmall)
                        .background(bill == selected ? Color.gray.opacity(0.7) : .gray.opacity(0.2))
                        .cornerRadius(.spacingSmall)
                        .onTapGesture {
                            selected = bill
                            withAnimation {
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
    @Previewable @State var selected: Bill? = try!
        ModelContainer.preview.mainContext.fetch(FetchDescriptor<CreditCard>()).first!.currentBill
    let bills = try! ModelContainer.preview.mainContext.fetch(FetchDescriptor<Bill>())

    List {
        Section {
            
        } header: {
            BillSelectorView(selected: $selected, bills: bills, card: bills.first!.card)
                .listRowInsets(EdgeInsets())
                .padding(.bottom, .spacingMedium)
        }
    }
}
