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
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: 1)
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(color)
        }.frame(width: 42, height: 42)
    }
}

struct ImageIconView_Previews: PreviewProvider {
    static var previews: some View {
        ImageIconView(image: Image(systemName: "bag"), color: .primary)
    }
}
