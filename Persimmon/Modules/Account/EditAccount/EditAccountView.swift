import SwiftUI

struct EditAccountItemView: View {
    @Environment(\.dismiss) var dismiss
    @State var isShowingColorPicker = false
    
    @ObservedObject var viewModel: EditAccountViewModel

    var body: some View {
        List {
            LabelTextField(label: "Account Name:",
                           placeholder: "Bank of Earth",
                           errorMessage: $viewModel.nameErroMessage,
                           text: $viewModel.name)
            LabelTextField(label: "Currency",
                           placeholder: "R$",
                           errorMessage: $viewModel.currencyErroMessage,
                           text: $viewModel.currency)
            HStack {
                Text("Color")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.brand)
                Circle()
                    .fill()
                    .foregroundColor(viewModel.color)
                    .frame(width: 20, height: 20)
            }.onTapGesture {
                isShowingColorPicker = true
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: viewModel.didTapSave)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: { dismiss() })
            }
        }
        .sheet(isPresented: $isShowingColorPicker) {
            NiceColorPicker(selected: $viewModel.niceColor)
        }
    }
}

struct EditAccountItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            let viewModel = EditAccountViewModel(accountBinding: .constant(nil))
            EditAccountItemView(viewModel: viewModel)
        }
    }
}
