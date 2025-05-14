import SwiftUI
import SwiftData
import MapKit

struct TransactionDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var transaction: Transaction
    @State var editingTransaction: Transaction?
    
    var body: some View {
        List {
            Section {
                LabeledView(labelText: "Type") {
                    HStack(spacing: .spacingMedium) {
                        Image(systemName: transaction.type.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundColor(Color.secondary)
                        Text(transaction.type.text)
                    }
                }
                let name = transaction.account?.name ?? transaction.installments[0].bill.card.name
                let color = transaction.account?.color ?? transaction.installments[0].bill.card.color
                LabeledView(labelText: transaction.type == .installments ? "Credit Card":  "Account") {
                    HStack(spacing: .spacingMedium) {
                        LettersIconView(text: name.firstLetters(),
                                        color: Color(hex: color))
                        Text(name).font(.title3)
                    }
                }
                
                LabeledView(labelText: "Value") {
                    Text(transaction.value.toCurrency(with: transaction.currency ?? "$"))
                        .font(.title3).bold()
                    if transaction.type == .installments {
                        let installmentValue = transaction
                            .installments[0].value.toCurrency(with: transaction.currency ?? "$")
                        Text("\(transaction.installments.count) x \(installmentValue)")
                    }
                }
                
                if let category = transaction.category {
                    LabeledView(labelText: "Category") {
                        CategoryCell()
                            .environmentObject(category)
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
            if transaction.type == .installments {
                Section("Installments") {
                    ForEach(transaction.installments.sorted()) { installment in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(installment.value.toCurrency(with: transaction.currency ?? "$"))
                                Text("\(installment.number) of \(transaction.installments.count)")
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Due Date")
                                    .font(.caption2)
                                Text(installment.bill.dueDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                if installment.bill.payedDate != nil {
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
        .navigationTitle(transaction.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit", action: didTapEdit)
            }
        }
        .sheet(item: $editingTransaction) {
            EditTransactionView(transaction: $0)
        }
        .onChange(of: editingTransaction) {
            if transaction.modelContext == nil {
                dismiss()
            }
        }
    }
    
    func didTapEdit() {
        editingTransaction = transaction
    }
}

#Preview {
    let transaction = {
        let transaction = try! ModelContainer.preview.mainContext.fetch(FetchDescriptor<Transaction>())[0]
        transaction.installments.sorted()[0].bill.payedDate = Date()
        return transaction
    }()
    
    NavigationStack {
        TransactionDetailsView()
            .environmentObject(transaction)
    }
}
