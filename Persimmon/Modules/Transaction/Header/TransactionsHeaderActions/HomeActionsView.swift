import SwiftUI

struct HomeActionsView: View {
    @ObservedObject var viewModel = HomeActionsViewModelMock()
    
    var body: some View {
        HStack(alignment: .top) {
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
                        .foregroundColor(.secondary)
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
            } header: {
                HomeActionsView()
                    .textCase(nil)
            }
        }
    }
}
