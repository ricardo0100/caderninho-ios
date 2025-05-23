//
//  CategoryIcon.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 22/05/25.
//

import SwiftUI

struct CategoryIcon: View {
    let name: String
    let color: String
    let icon: String?
    let size: CGFloat
    
    var body: some View {
        if let icon = icon {
            ImageIconView(image: Image(systemName: icon),
                          color: Color(hex: color),
                          size: size)
        } else {
            LettersIconView(text: name,
                            color: Color(hex: color),
                            size: size)
        }
    }
}

#Preview {
    CategoryIcon(name: "Maya Bank",
                 color: "#0086FF",
                 icon: "airplane",
                 size: 32)
}
