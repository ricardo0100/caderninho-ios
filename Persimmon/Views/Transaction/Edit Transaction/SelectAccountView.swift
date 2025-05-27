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
                    HStack {
                        Text(account.name)
                        if let icon = account.icon {
                            Image(icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24)
                        } else {
                            LettersIconView(text: account.name, color: Color(hex: account.color))
                        }
                    }
                }
            }
        } label: {
            HStack {
                if let account = selected {
                    Text(account.name).foregroundStyle(Color.brand)
                    if let icon = account.icon {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                    } else {
                        LettersIconView(text: account.name, color: Color(hex: account.color))
                    }
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
        .modelContainer(.preview)
}
