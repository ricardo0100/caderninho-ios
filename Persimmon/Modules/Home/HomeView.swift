import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModelMock = .init()
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.buys) {
                    TransactionCell(item: $0)
                }
            } header: {
                HomeHeaderView()
                    .textCase(nil)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.grouped)
    }
}

fileprivate struct TransactionCell: View {
    let item: Transaction
    
    var body: some View {
        HStack {
            TransactionTypeIcon(type: item.type)
            VStack(alignment: .leading, spacing: .spacingSmall) {
                HStack {
                    Text(item.name)
                        .font(.headline)
                    Spacer()
                    Text(item.type.text)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text(item.currency)
                        .font(.subheadline)
                    Spacer()
                    HStack {
                        Text("\(item.account.name)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Circle()
                            .foregroundColor(item.account.color.color)
                            .frame(width: 12, height: 12)
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView(viewModel: HomeViewModelMock())
        }
    }
}
