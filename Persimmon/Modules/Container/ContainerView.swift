import SwiftUI

struct ContainerView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "arrow.up.arrow.down")
                    }
                AccountsView()
                    .tabItem {
                        Label("Accounts", systemImage: "creditcard")
                    }
                CategoriesView()
                    .tabItem {
                        Label("Categories", systemImage: "briefcase")
                    }
                SavingsView()
                    .tabItem {
                        Label("Savings", systemImage: "chart.line.uptrend.xyaxis")
                    }
            }
            .tint(Color.brand)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
