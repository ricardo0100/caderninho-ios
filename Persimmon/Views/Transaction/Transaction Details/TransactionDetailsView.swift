import SwiftUI
import MapKit

struct TransactionDetailsView: View {
    @State var transaction: Transaction
    @State var editingTransaction: Transaction?
    
    var body: some View {
        List {
            Section {
                LabeledView(labelText: "Name") {
                    Text(transaction.name)
                }
                
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
                
                LabeledView(labelText: "Account") {
                    HStack(spacing: .spacingMedium) {
                        LettersIconView(text: transaction.account.name.firstLetters(),
                                        color: Color(hex: transaction.account.color))
                        Text(transaction.account.name).font(.title3)
                    }
                }
                
                LabeledView(labelText: "Value") {
                    Text(transaction.value.toCurrency(with: transaction.account.currency)).font(.title3)
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
                if let place = transaction.place, let coordinate = place.coordinate {
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
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit", action: didTapEdit)
            }
        }
        .sheet(item: $editingTransaction) {
            EditTransactionView(transaction: $0)
        }
    }
    
    func didTapEdit() {
        editingTransaction = transaction
    }
}

#Preview {
    NavigationStack {
        TransactionDetailsView(transaction: DataController.createRandomTransaction())
    }
}
