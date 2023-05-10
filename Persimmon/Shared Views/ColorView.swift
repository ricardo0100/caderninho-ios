import SwiftUI

enum NiceColor: String, CaseIterable {
    case coral = "#FF7F50"
    case red = "#DC143C"
    case pink = "#FF69B4"
    case blue = "#1E90FF"
    case teal = "#008080"
    case green = "#008000"
    case yellowGreen = "#9ACD32"
    case yellow = "#FFD700"
    case orange = "#FFA500"
    case salmon = "#FA8072"
    case chocolate = "#D2691E"
    case gray = "#808080"
    case red2 = "#FF4136"
    case green2 = "#2ECC40"
    case blue2 = "#0074D9"
    case orange2 = "#FF851B"
    case pink2 = "#F012BE"
    case yellow2 = "#FFDC00"
    case skyBlue = "#7FDBFF"
    case teal2 = "#39CCCC"
    case maroon = "#85144b"
    case olive = "#3D9970"
    case navy = "#2C3E50"
    case paleYellow = "#E6DB74"
    case lightGray = "#D3D3D3"
    case darkGray = "#A9A9A9"
    
    var color: Color {
        Color(hex: rawValue)
    }
}

struct ColorView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(NiceColor.allCases, id: \.self) { col in
                    Text("\(col.rawValue)")
                    Circle()
                        .foregroundColor(col.color)
                        .frame(width: 30, height: 30)
                }
            }
        }    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView()
    }
}
