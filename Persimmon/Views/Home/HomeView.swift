//
//  HomeView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 19/12/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, Ricardo!")
                .font(.largeTitle)
            Text("Gastos por categorias")
            PizzaGraphicView(values: [
                PizzaGraphicItem(value: 100, color: .blue),
                PizzaGraphicItem(value: 200, color: .pink)])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    HomeView()
}
