//
//  HomeView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 19/12/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(Date().formatted(Date.FormatStyle().day().month()))
                        .padding(.bottom)
                    Text("Expenses by Category").bold()
                    CategoryExpensesView().padding(.bottom)
                    Text("Accounts Balance").bold()
                    AccountsBalancesView().padding(.bottom)
                    Text("").bold()
                }
                .navigationTitle("Hello, Rica!")
                .padding()
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(DataController.previewContainer)
        .tint(.brand)
}
