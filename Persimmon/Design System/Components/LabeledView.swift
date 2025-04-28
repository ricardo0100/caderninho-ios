import SwiftUI

struct LabeledView<Content: View>: View {
    let labelText: String
    let alignRight: Bool
    @Binding var error: String?
    @ViewBuilder var content: () -> Content
    
    init(labelText: String, alignRight: Bool = false, error: Binding<String?>? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.labelText = labelText
        self.alignRight = alignRight
        self._error = error ?? .constant(nil)
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: alignRight ? .trailing : .leading, spacing: .zero) {
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
        .frame(maxWidth: .infinity, alignment: alignRight ? .trailing : .leading)
    }
}

#Preview {
    List {
        LabeledView(labelText: "Label", error: .constant("Error message")) {
            Text("Hello World!")
        }
        
        LabeledView(labelText: "Right Aligned", alignRight: true, error: .constant("Error message")) {
            Text("Bye bye World!")
        }
    }
}
