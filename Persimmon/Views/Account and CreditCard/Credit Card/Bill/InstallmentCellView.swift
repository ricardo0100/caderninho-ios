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
                if let transaction = installment.transaction {
                    Text(transaction.name)
                    Text(transaction.value.toCurrency(with: installment.bill?.card?.currency ?? ""))
                        .font(.footnote)
                        .bold()
                    Text(transaction.date.formatted(date: .numeric, time: .omitted))
                        .font(.footnote)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(installment.value.toCurrency(with: installment.bill?.card?.currency ?? ""))
                    .bold()
                if let transaction = installment.transaction {
                    if let category = transaction.category {
                        HStack(spacing: .spacingSmall) {
                            Text(category.name)
                                .font(.caption2)
                            if let icon = transaction.category?.icon {
                                ImageIconView(image: Image(systemName: icon),
                                              color: Color(hex: category.color),
                                              size: 16)
                            }
                        }
                    }
                    Text("Installment \(installment.number) of \(transaction.installments.count)")
                        .font(.footnote)
                }
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
