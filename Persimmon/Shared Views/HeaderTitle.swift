import SwiftUI

struct HeaderTitle: View {
    let title: String
    let systemImage: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .spacingHuge)
            Text(title)
                .font(.title)
        }
        .foregroundColor(.brand)
        .padding(.vertical, .spacingBig)
    }
}

struct HeaderTitle_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                Text("Test")
            } header: {
                VStack(alignment: .leading, spacing: .zero) {
                    HeaderTitle(title: "Transactions",
                                systemImage: "creditcard")
                    .padding(.horizontal)
                }
                .textCase(nil)
                .listRowInsets(EdgeInsets())
            }
        }.listStyle(.grouped)
    }
}
