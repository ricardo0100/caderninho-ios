//
//  ImageIconView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 11/05/23.
//

import SwiftUI

struct ImageIconView: View {
    let image: Image
    let color: Color
    let size: CGFloat
    
    var body: some View {
        image
            .resizable()
            .symbolRenderingMode(.multicolor)
            .foregroundStyle(color)
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
    }
}

#Preview {
    ImageIconView(image: Image(systemName: "dog.fill"), color: NiceColor.orange.color, size: 32)
    ImageIconView(image: Image(systemName: "rainbow"), color: NiceColor.orange.color, size: 32)
}
