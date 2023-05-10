import SwiftUI

struct SavingsView: View {
    @ObservedObject var viewModel = SavingsViewModelMock()
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.savings) { item in
                    SavingsCell(item: item)
                }
            } header: {
                SavingsHeaderView(savings: viewModel.savings)
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.grouped)
    }
}

struct SavingsCell: View {
    let item: SavingsItem
    
    var body: some View {
        HStack {
            LettersIconView(
                text: item.name.firstLetters(),
                color: item.color.color)
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text("\(item.currency) \(item.amount.formatted())")
                    .font(.subheadline)
            }
        }
    }
}

struct SavingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SavingsView(viewModel: SavingsViewModelMock())
        }
    }
}
