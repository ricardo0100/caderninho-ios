import AppIntents

struct SelectAccountEntity: AppEntity {
    var id: String
    let name: String
    
    static var defaultQuery = AccountQuery()
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Account"
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}
