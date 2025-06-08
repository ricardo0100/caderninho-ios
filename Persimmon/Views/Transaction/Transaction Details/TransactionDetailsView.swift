import SwiftUI
import SwiftData
import MapKit

struct TransactionDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var transaction: Transaction
    @EnvironmentObject var navigation: TransactionsNavigation
    
    var body: some View {
        let operation = Transaction.Operation(rawValue: transaction.operation)!
        List {
            Section {
                LabeledView(labelText: "Type") {
                    HStack(spacing: .spacingMedium) {
                        Image(systemName: operation.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundColor(Color.secondary)
                        Text(operation.text)
                    }
                }
                let name = transaction.accountOrCardName ?? ""
                let color = transaction.accountOrCardColor ?? ""
                LabeledView(labelText: operation == .installments ? "Credit Card" : "Account") {
                    HStack(spacing: .spacingMedium) {
                        if let icon = transaction.accountOrCardIcon {
                            Image(icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                        } else {
                            LettersIconView(text: name.firstLetters(),
                                            color: Color(hex: color))
                        }
                        Text(name).font(.title3)
                    }
                }
                
                LabeledView(labelText: "Value") {
                    Text(transaction.value.toCurrency(with: transaction.currency ?? "$"))
                        .font(.title3).bold()
                    if operation == .installments {
                        let installmentValue = transaction.installments.first?.currencyValue ?? ""
                        Text("\(transaction.installments.count) x \(installmentValue)")
                    }
                }
                
                if let category = transaction.category {
                    LabeledView(labelText: "Category") {
                        //TODO: Do not use cell
                        CategoryCellView(category: category, total: nil)
                    }
                }
                
                LabeledView(labelText: "Date") {
                    Text(transaction.date.formatted(date: .complete, time: .shortened)).font(.subheadline)
                }
                
                if let place = transaction.place {
                    LabeledView(labelText: "Location") {
                        VStack(alignment: .leading) {
                            Text(place.name ?? "")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.primary)
                            Text(place.title ?? "")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.primary)
                            Text(place.subtitle ?? "").font(.caption2)
                        }
                    }
                }
            } header: {
                //TODO: Move map to own View
                if let place = transaction.place, let coordinate = place.location?.coordinate {
                        Map(bounds: MapCameraBounds(minimumDistance: 500)) {
                            Marker(place.title ?? "", coordinate: coordinate)
                        }
                        .mapStyle(.standard)
                        .frame(height: 180)
                        .listRowInsets(.init(top: .spacingBig,
                                             leading: .zero,
                                             bottom: .spacingBig,
                                             trailing: .zero))
                        .cornerRadius(12)
                    }
                }
            if operation == .installments {
                Section("Installments") {
                    ForEach(transaction.installments.sorted()) { installment in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(installment.value.toCurrency(with: transaction.currency ?? "$"))
                                Text("\(installment.number) of \(transaction.installments.count)")
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Due date")
                                    .font(.caption2)
                                if let bill = installment.bill {
                                    Text(bill.dueDate.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                    if bill.payedDate != nil {
                                        Text("Payed")
                                            .font(.caption2)
                                            .foregroundStyle(.green)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(transaction.name)
        .sheet(item: $navigation.editingTransaction) {
            EditTransactionView(transaction: $0, navigation: navigation)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit", action: didTapEdit)
            }
        }
    }
    
    func didTapEdit() {
        navigation.editingTransaction = transaction
    }
}

#Preview {
    let transaction = {
        let transaction = try! ModelContainer.preview.mainContext.fetch(FetchDescriptor<Transaction>())[0]
        transaction.installments.sorted()[0].bill?.payedDate = Date()
        return transaction
    }()
    
    NavigationStack {
        TransactionDetailsView()
            .environmentObject(transaction)
    }
}
