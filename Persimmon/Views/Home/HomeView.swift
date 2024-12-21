//
//  HomeView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 19/12/24.
//

import SwiftUI

let categoryItems: [GraphItem] = [
    .init(title: "Orange", value: 3, color: .orange),
    .init(title: "Pink", value: 30, color: .pink),
    .init(title: "Blue", value: 9, color: .blue),
    .init(title: "Yellow", value: 17, color: .yellow),
]

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(Date().formatted(Date.FormatStyle().day().month().year()))
                        .padding(.bottom)
                    Text("Expenses by Category").bold()
                    CategoryExpensesView().padding(.bottom)
                    Text("Accounts").bold()
                    AccountsBalancesView().padding(.bottom)
                    Text("Expenses by Category").bold()
                    CategoryExpensesView().padding(.bottom)
                    CategoryExpensesView().padding(.bottom)
                    CategoryExpensesView().padding(.bottom)
                    CategoryExpensesView().padding(.bottom)
                }
                .navigationTitle("Hello, Rica!")
                .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}

struct CategoryExpensesView: View {
    var body: some View {
        HStack {
            PizzaGraphView(values: categoryItems)
                .frame(width: 120, height: 120)
            VStack(alignment: .leading) {
                ForEach(categoryItems) { item in
                    Text(item.title)
                }
            }
            Spacer()
        }
    }
}

struct AccountsBalancesView: View {
    var body: some View {
        BarsGraphView(values: categoryItems)
            .frame(height: 120)
    }
}
