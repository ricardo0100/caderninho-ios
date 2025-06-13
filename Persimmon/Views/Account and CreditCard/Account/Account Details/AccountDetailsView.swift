import SwiftUI
import SwiftData

struct AccountDetailsView: View {
    @EnvironmentObject var navigation: NavigationModel
    @EnvironmentObject var account: Account
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        List {
            Section {
                PeriodFilterView(
                    startDate: $viewModel.startDate,
                    endDate: $viewModel.endDate)
            }
            FilteredTransactionsListView(startDate: viewModel.startDate,
                                         endDate: viewModel.endDate,
                                         searchText: viewModel.debouncedSearchText,
                                         selectedAccountOrCardId: account.id)
        }
        .searchable(text: $viewModel.searchText)
        .onAppear(perform: viewModel.didAppear)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    if let icon = account.icon {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                    } else {
                        LettersIconView(text: account.name.firstLetters(),
                                        color: Color(hex: account.color))
                    }
                    Text(account.name)
                        .font(.headline)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit", action: didTapEdit)
            }
        }
    }
    
    func didTapEdit() {
        navigation.editingAccount = account
    }
}

#Preview {
    let account = try! ModelContainer.preview.mainContext
        .fetch(FetchDescriptor<Account>())[0]
    
    NavigationStack {
        AccountDetailsView()
            .environmentObject(account)
    }
}
