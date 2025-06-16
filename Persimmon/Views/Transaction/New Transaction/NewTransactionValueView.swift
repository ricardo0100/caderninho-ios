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
            }
            header: {
                HStack {
                    if let icon = icon {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32)
                    }
                    Text(name)
                        .font(.headline)
                }
                .textCase(.none)
                .padding(.bottom)
            }
            footer: {
                if !isCard {
                   HStack {
                       Spacer()
                       VStack {
                           Button(action: {
                               isOut = false
                           }) {
                               Image(systemName: "arrow.down.circle")
                                   .resizable()
                                   .frame(width: 36, height: 36)
                                   .padding()
                           }
                           .foregroundStyle(isOut ? Color.blue : .white)
                           .background(isOut ? Color.clear : .blue)
                           .clipShape(RoundedRectangle(cornerRadius: .spacingLarge))
                           Text("Transfer In")
                       }
                       Spacer()
                       VStack {
                           Button(action: {
                               isOut = true
                           }) {
                               Image(systemName: "arrow.up.circle")
                                   .resizable()
                                   .frame(width: 36, height: 36)
                                   .padding()
                           }
                           .foregroundStyle(isOut ? Color.white : .blue)
                           .background(isOut ? Color.blue : .clear)
                           .clipShape(RoundedRectangle(cornerRadius: .spacingLarge))
                           Text("Transfer Out")
                       }
                       Spacer()
                   }.padding(.top)
               }
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
            }
            Section {} footer: {
                NavigationLink("Next") {
                    NewTransactionNameView(operation: operation)
                }
                .font(.title2)
                .buttonStyle(.borderedProminent)
            }
            .textCase(.none)
            .frame(maxWidth: .infinity)
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
