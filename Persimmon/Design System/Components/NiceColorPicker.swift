import SwiftUI

enum NiceColor: String, CaseIterable {
    case coral = "#FF7F50"
    case red = "#DC143C"
    case salmon = "#FA8072"
    case red2 = "#FF4136"
    case pink = "#FF69B4"
    case pink2 = "#F012BE"
    case blue = "#1E90FF"
    case blue2 = "#0074D9"
    case skyBlue = "#7FDBFF"
    case navy = "#2C3E50"
    case teal = "#008080"
    case green = "#008000"
    case yellowGreen = "#9ACD32"
    case green2 = "#2ECC40"
    case olive = "#3D9970"
    case yellow = "#FFD700"
    case yellow2 = "#FFDC00"
    case paleYellow = "#E6DB74"
    case orange = "#FFA500"
    case orange2 = "#FF851B"
    case chocolate = "#D2691E"
    case maroon = "#85144b"
    case gray = "#808080"
    case lightGray = "#D3D3D3"
    case darkGray = "#A9A9A9"
    
    var color: Color {
        Color(hex: rawValue)
    }
}

struct NiceColorPicker: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selected: NiceColor
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(NiceColor.allCases, id: \.self) { color in
                        Circle()
                            .stroke(color.color, lineWidth: 4)
                            .background(Circle().foregroundColor(color == selected ? color.color : Color.clear))
                            .frame(width: geo.size.width / 10,
                                   height: geo.size.width / 10)
                            .onTapGesture {
                                selected = color
                                dismiss()
                            }.padding()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var selected: NiceColor = .red
    NiceColorPicker(selected: $selected)
}
