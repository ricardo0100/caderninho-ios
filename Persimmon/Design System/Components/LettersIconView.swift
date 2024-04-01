import SwiftUI

struct LettersIconView: View {
    let text: String
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: 2)
            Text(text)
                .font(.caption)
                .bold()
                .foregroundColor(color)
        }
    }
}

struct LettersIconView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LettersIconView(text: "Action Test".firstLetters(), color: NiceColor.gray.color)
            LettersIconView(text: "Test".firstLetters(), color: NiceColor.blue.color)
        }
    }
}
