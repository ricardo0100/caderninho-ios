//
//  InstallmentCellView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 05/05/25.
//

import SwiftUI
import SwiftData

struct InstallmentCellView: View {
    @EnvironmentObject var installment: Installment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(installment.transaction.name)
                Text("Total: \(installment.transaction.value.toCurrency(with: installment.bill.card.currency))")
                    .font(.footnote)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(installment.value.toCurrency(with: installment.bill.card.currency))
                    .bold()
                Text("Installment \(installment.number) of \(installment.transaction.installments.count)")
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    let card = try! ModelContainer.preview.mainContext.fetch(FetchDescriptor<CreditCard>()).first!
    List(card.bills.first?.installments ?? []) { item in
        InstallmentCellView()
            .environmentObject(item)
    }
}
