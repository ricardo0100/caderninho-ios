import SwiftUI

struct TransactionsHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            BudgetPanel()
                .padding()
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(16)
            TransactionsActionsView()
                .padding(.vertical)
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
