import SwiftUI

struct AccountsHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HeaderTitle(
                title: "Accounts",
                systemImage: "creditcard.circle"
            )
            .padding(.horizontal)
            
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
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus")
                })
                .buttonStyle(.borderedProminent)
                .tint(.brand)
            }.padding()
        }
    }
}

struct AccountsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                Text("Test")
            } header: {
                AccountsHeaderView()
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
            }
        }.listStyle(.grouped)
    }
}
