import SwiftUI
import SwiftData

struct SelectAccountView: View {
    @Query var accounts: [Account]
    @Binding var selected: Account?
    
    var body: some View {
        Menu {
            ForEach(accounts, id: \.self) { account in
                Button {
                    selected = account
                } label: {
                    Text(account.name)
                }
            }
        } label: {
            HStack {
                if let account = selected {
                    LettersIconView(text: account.name, color: Color(hex: account.color))
                    Text(account.name).foregroundStyle(Color.brand)
                } else {
                    Text("Select an acocunt")
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var account: Account? = nil
    SelectAccountView(selected: $account)
        .modelContainer(DataController.previewContainer)
}
