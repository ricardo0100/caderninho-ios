//
//  NavigationToolbarView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 21/03/24.
//

import SwiftUI

struct NavigationToolbarView: View {
    let imageName: String
    let title: String
    
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

struct NavigationToolbarView_Previews: PreviewProvider {
    static var previews: some View {
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
}
