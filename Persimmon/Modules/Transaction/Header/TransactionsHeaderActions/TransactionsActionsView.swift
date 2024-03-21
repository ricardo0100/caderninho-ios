import SwiftUI

struct TransactionsActionsView: View {
    @ObservedObject var viewModel = TransactionsActionsViewModelMock()
    
    var body: some View {
        HStack(alignment: .top, spacing: .spacingMedium) {
            ForEach(viewModel.actions) { button in
                VerticalButton(iconName: button.iconName, text: button.text, action: {

                }).frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}

struct VerticalButton: View {
    let iconName: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button (action: action, label: {
            VStack {
                ZStack {
                    Circle()
                        .foregroundColor(.brand)
                    Image(systemName: iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.brandText)
                }
                
                Text(text)
                    .font(.caption2)
                    .lineLimit(2)
            }
            .foregroundColor(Color.primary)
        })
    }
}

struct HomeActionsView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                Text("Hi")
            } header: {
                TransactionsActionsView()
                    .textCase(nil)
                    .listRowInsets(EdgeInsets(
                        top: .zero,
                        leading: .zero,
                        bottom: .zero,
                        trailing: .zero))
            }
        }
    }
}
