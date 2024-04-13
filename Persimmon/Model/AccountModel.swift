import Foundation

struct AccountModel: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var color: String
    var currency: String
}
