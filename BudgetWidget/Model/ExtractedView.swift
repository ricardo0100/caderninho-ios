//
//  ExtractedView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 31/12/24.
//
import SwiftUI

struct AccountBalanceWidgetView: View {
    let entry: MainAccountBalanceEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            if let account = entry.accountData {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            LettersIconView(text: account.name, color: account.color, size: 16)
                            Text(account.name)
                        }
                        Text(account.balance.toCurrency(with: account.currency))
                            .font(.footnote)
                            .bold()
                    }
                    Spacer()
                }
            } else {
                Text("Select an account")
                    .tint(Color.brand)
                    .font(.caption2)
            }
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "plus")
            }
        }
        .tint(.brand)
        .containerBackground(for: .widget) {
            Color.brand.opacity(0.2)
        }
    }
}
