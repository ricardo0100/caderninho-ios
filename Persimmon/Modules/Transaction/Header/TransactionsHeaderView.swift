import SwiftUI

struct TransactionsHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            BudgetPanel()
            HomeActionsView()
        }
        .textCase(nil)
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                Text("Test")
            } header: {
                TransactionsHeaderView()
            }
        }
    }
}
