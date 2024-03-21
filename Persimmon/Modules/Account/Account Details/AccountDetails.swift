import SwiftUI

struct AccountDetails: View {
    let account: AccountModel
    
    var body: some View {
        Text(account.name)
            .foregroundColor(Color(hex: account.color))
    }
}

struct AccountDetails_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetails(account: AccountInteractor.exampleAccounts[.zero])
    }
}
