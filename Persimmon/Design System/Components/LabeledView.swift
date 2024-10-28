import SwiftUI

struct LabeledView<Content: View>: View {
    let labelText: String
    @Binding var error: String?
    @ViewBuilder var content: () -> Content
    
    init(labelText: String, error: Binding<String?>? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.labelText = labelText
        self._error = error ?? .constant(nil)
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(labelText)
                .font(.subheadline)
                .bold()
                .foregroundColor(.brand)
                .padding(.bottom, .spacingSmall)
            content()
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 1)
            }
        }
    }
}

#Preview {
    List {
        LabeledView(labelText: "Label", error: .constant("Error message")) {
            Text("Hello World!")
        }
    }
}
