import SwiftUI



fileprivate struct SliceItem: Identifiable, Hashable {
    let id = UUID()
    let start: Angle
    let end: Angle
    let color: Color
}

struct PizzaGraphView: View {
    let values: [GraphItem]
    
    private var sum: Double {
        values.map { $0.value }.reduce(.zero, +)
    }
    
    private var slices: [SliceItem] {
        var lastAngle: Angle = .zero
        let multiplier: Double = .pi * 2 / sum
        
        return values.sorted { $0.value < $1.value }.map {
            let end = Angle(radians: lastAngle.radians + $0.value * multiplier)
            let slice = SliceItem(start: lastAngle, end: end, color: $0.color)
            lastAngle = end
            return slice
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(slices, id: \.self) { slice in
                    PizzaSlice(
                        startAngle: slice.start,
                        endAngle: slice.end
                    ).foregroundColor(slice.color)
                }
            }.clipped()
        }
    }
}

fileprivate struct PizzaSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = CGFloat.minimum(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false)
        path.closeSubpath()
        return path
    }
}

#Preview {
    PizzaGraphView(values: [
        .init(title: "Red", value: 1, color: .red),
        .init(title: "Blue", value: 1.3, color: .blue),
        .init(title: "Yellow", value: 1, color: .yellow),
    ])
}
