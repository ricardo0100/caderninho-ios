import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HeaderTitle(
                title: "Transactions",
                systemImage: "arrow.up.arrow.down.circle"
            )
            .padding(.horizontal)
            
            BudgetPanel()
                .padding()
            
            HomeActionsView()
        }
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                Text("Test")
            } header: {
                HomeHeaderView()
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
            }
        }.listStyle(.grouped)
    }
}
