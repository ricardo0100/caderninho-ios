//
//  NewTransactionView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 25/05/25.
//
import SwiftUI
import SwiftData

struct NewTransactionView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            NewTransactionSelectAccountView(isPresented: $isPresented)
        }
    }
}

#Preview {
    NewTransactionView(isPresented: .constant(true))
        .modelContainer(.preview)
}
