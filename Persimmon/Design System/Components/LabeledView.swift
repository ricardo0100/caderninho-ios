import SwiftUI


struct LabeledView<Content: View>: View {
    let labelText: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading) {
            Text(labelText).font(.subheadline).bold().foregroundColor(.brand)
            content()
        }
    }
}

struct LabeledView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LabeledView(labelText: "Label") {
                Text("Hello World!")
            }
        }
    }
}
