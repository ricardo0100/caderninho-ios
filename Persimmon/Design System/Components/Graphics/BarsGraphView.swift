//
//  BarsGraphView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 21/12/24.
//

import SwiftUI

fileprivate struct BarItem: Identifiable, Hashable {
    let id = UUID()
    let start: Angle
    let end: Angle
    let color: Color
}

fileprivate struct BarShape: Shape {
    let value: Double
    
    func path(in rect: CGRect) -> Path {
        let yTranslation: CGFloat = rect.height - rect.height * value
        return Path(rect)
            .applying(CGAffineTransform(scaleX: 1, y: value))
            .applying(CGAffineTransform(translationX: .zero,
                                        y: yTranslation))
    }
}

struct BarsGraphView: View {
    let values: [GraphItem]
    
    private var max: Double {
        values.map(\.value).max() ?? 0
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(values) { value in
                BarShape(value: value.value / max)
                    .foregroundStyle(value.color)
            }
        }
    }
}

#Preview {
    BarsGraphView(values: [
        .init(title: "Red", value: 2.2, color: .red),
        .init(title: "Blue", value: 1.3, color: .blue),
        .init(title: "Yellow", value: 1.4, color: .yellow),
        .init(title: "Purple", value: 3, color: .purple),
    ]).padding()
}
