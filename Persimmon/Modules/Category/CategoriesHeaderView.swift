import SwiftUI

struct CategoriesHeaderView: View {
    let addAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack {
                VStack(alignment:.leading) {
                    Text("Total: ")
                        .font(.title3)
                        .foregroundColor(.brand)
                    Text("R$ 432,18")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("US$ 1442,86")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                Spacer()
                Button(action: addAction, label: {
                    Image(systemName: "plus")
                })
                .buttonStyle(.borderedProminent)
                .tint(.brand)
            }
        }
    }
}

struct CategoriesHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                Text("Test")
            } header: {
                CategoriesHeaderView(addAction: {})
                    .textCase(nil)
                    .listRowInsets(EdgeInsets(
                        top: .spacingHuge,
                        leading: .zero,
                        bottom: .spacingHuge,
                        trailing: .zero))
            }
        }
    }
}
