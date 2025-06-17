//
//  NewTransactionValueView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 27/05/25.
//


import SwiftUI
import SwiftData

struct NewTransactionValueView: View {
    enum Field: Hashable {
        case value
    }
    @FocusState private var focusedField: Field?
    @State var value: Double = .zero
    @State var installments: Int = 1
    @State var isOut = true
    
    let account: Account?
    let card: CreditCard?
    
    init(account: Account) {
        self.account = account
        self.card = nil
    }
    
    init (card: CreditCard) {
        self.card = card
        self.account = nil
    }
    
    var name: String {
        account?.name ?? card?.name ?? ""
    }
    
    var currency: String {
        account?.currency ?? card?.currency ?? "$"
    }
    
    var icon: String? {
        account?.icon ?? card?.icon
    }
    
    var isCard: Bool {
        card != nil
    }
    
    var body: some View {
        List {
            Section {
                LabeledView(labelText: "Value") {
                    CurrencyTextField(currency: currency, value: $value, font: .title)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .value)
                        .onAppear {
                            focusedField = .value
                        }
                }
            } header: {
                HStack {
                    if let icon = icon {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    Text(name)
                        .font(.headline)
                }
                .textCase(.none)
                .padding(.bottom)
            }
            Section {
                if isCard {
                    LabeledView(labelText: "Installments") {
                        HStack {
                            Text("\(installments) x \((value / Double(installments)).toCurrency(with: currency))")
                                .font(.title2)
                            Spacer()
                            Stepper("", value: $installments, in: 1...120)
                                .labelsHidden()
                        }
                    }
                }
            } footer: {
                if let account = account {
                    HStack {
                        Spacer()
                        NavigationLink {
                            NewTransactionNameView(operation: .transferOut(account: account, value: value))
                        } label: {
                            VStack {
                                Image(systemName: "tray.and.arrow.up.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32)
                                Text("Transfer Out")
                            }
                        }
                        Spacer()
                        NavigationLink {
                            NewTransactionNameView(operation: .transferIn(account: account, value: value))
                        } label: {
                            VStack {
                                Image(systemName: "tray.and.arrow.down.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32)
                                Text("Transfer In")
                            }
                        }
                        Spacer()
                    }
                    .disabled(value == 0)
                } else if let card = card {
                    HStack {
                        Spacer()
                        NavigationLink("Continue") {
                            NewTransactionNameView(operation: .installments(card: card, numberOfInstallments: installments, value: value))
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                        .disabled(value == 0)
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var operation: Transaction.EditOperation {
        if isCard {
            return .installments(card: card!, numberOfInstallments: installments, value: value)
        } else if isOut {
            return .transferOut(account: account!, value: value)
        } else {
            return .transferIn(account: account!, value: value)
        }
    }
}


#Preview {
    NavigationStack {
        NewTransactionValueView(card: CreditCard(id: UUID(),
                                                 name: "Credit Card",
                                                 color: "#567F7F",
                                                 icon: "bb",
                                                 currency: "R$",
                                                 closingCycleDay: 3,
                                                 dueDay: 10))
    }
}
