import SwiftUI

struct LabelTextField: View {
    let label: String
    let placeholder: String
    @Binding var errorMessage: String?
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacingZero) {
            Text(label).font(.subheadline).bold().foregroundColor(.brand)
            TextField(placeholder, text: $text).font(.title3)
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption2)
                    .foregroundColor(.red)
            }
        }
    }
}

struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LabelTextField(label: "Nome",
                           placeholder: "John",
                           errorMessage: .constant(nil),
                           text: .constant("Ricardo"))
            LabelTextField(label: "Sobrenome",
                           placeholder: "Maria",
                           errorMessage: .constant("Campo obrigatório"),
                           text: .constant(""))
        }
    }
}
