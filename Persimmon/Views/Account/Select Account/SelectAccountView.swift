import SwiftUI
import SwiftData

struct SelectAccountView: View {
    @Query
    var accounts: [Account]
    
    @Environment(\.dismiss) var dismiss
    @Binding var selected: Account?
    
    var body: some View {
        List(accounts, id: \.self, selection: $selected) { account in
            HStack {
                LettersIconView(text: account.name, color: Color(hex: account.color))
                Text(account.name)
                Spacer()
                if selected?.id == account.id {
                    Image(systemName: "checkmark")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                didSelect(account: account)
            }
        }
    }
    
    func didSelect(account: Account) {
        selected = account
        dismiss()
    }
}

struct SelectAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SelectAccountView(selected: .constant(nil))
    }
}
