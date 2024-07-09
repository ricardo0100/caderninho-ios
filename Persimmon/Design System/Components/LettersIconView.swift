import SwiftUI

struct LettersIconView: View {
    let text: String
    let color: Color
    let size: CGFloat
    
    init(text: String, color: Color, size: CGFloat = 24) {
        self.size = size
        self.text = String(text.prefix(2)).uppercased()
        self.color = color
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: 1)
            Text(text)
                .font(.system(size: size / 2, weight: .light, design: .rounded))
                .bold()
                .foregroundColor(color)
        }.frame(width: size, height: size)
    }
}

struct LettersIconView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LettersIconView(text: "Action Test".firstLetters(), color: NiceColor.gray.color, size: 44)
            LettersIconView(text: "Maya Regina".firstLetters(), color: NiceColor.blue.color, size: 44)
            LettersIconView(text: "Ric".firstLetters(), color: NiceColor.pink2.color, size: 14)
            LettersIconView(text: "Ric G".firstLetters(), color: NiceColor.pink2.color, size: 12)
        }
    }
}
