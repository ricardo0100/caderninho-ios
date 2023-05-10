import SwiftUI

struct HomeActionsView: View {
    @ObservedObject var viewModel = HomeActionsViewModelMock()
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(viewModel.actions) { button in
                    VerticalButton(iconName: button.iconName, text: button.text, action: {

                    })
                }
            }
            .padding()
        }
        .background(.bar)
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
                        .font(.title)
                }
                .frame(width: 48, height: 48)
                
                Text(text)
                    .font(.subheadline)
                    .lineLimit(2)
                    .frame(maxHeight: .infinity)
            }
            .foregroundColor(Color.primary)
            .padding(.horizontal, .spacingSmall)
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
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.grouped)
    }
}
