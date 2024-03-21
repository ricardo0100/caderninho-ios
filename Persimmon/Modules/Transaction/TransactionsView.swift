import SwiftUI

struct TransactionsView: View {
    @ObservedObject var viewModel: HomeViewModelMock = .init()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.buys) {
                        TransactionCell(item: $0)
                    }
                } header: {
                    TransactionsHeaderView()
                        .listRowInsets(EdgeInsets(
                            top: .zero,
                            leading: .zero,
                            bottom: .zero,
                            trailing: .zero))
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationToolbarView(
                        imageName: "arrow.up.arrow.down",
                        title: "Transactions")
                }
            }
        }
    }
}

fileprivate struct TransactionCell: View {
    let item: TransactionModel
    
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
                            .foregroundColor(Color(hex: item.account.color))
                            .frame(width: 12, height: 12)
                    }
                }
            }
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TransactionsView(viewModel: HomeViewModelMock())
        }
    }
}
