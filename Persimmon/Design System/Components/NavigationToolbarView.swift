//
//  NavigationToolbarView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 21/03/24.
//

import SwiftUI

struct NavigationToolbarView: View {
    let imageName: String
    let title: LocalizedStringKey
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.brand)
                
            Text(title)
                .foregroundColor(.brand)
                .font(.headline)
        }
    }
}

#Preview {
    NavigationStack {
        List {
            Text("👽")
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                NavigationToolbarView(imageName: "creditcard", title: "Teste")
            }
        }
    }
}
