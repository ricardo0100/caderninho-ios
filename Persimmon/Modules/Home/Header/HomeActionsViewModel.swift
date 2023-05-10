import Foundation

struct Action: Identifiable {
    var id = UUID()
    let iconName: String
    let text: String
}

protocol HomeActionsViewModelProtocol: ObservableObject {
    var actions: [Action] { get }
    func fetchActions()
}

class HomeActionsViewModelMock: HomeActionsViewModelProtocol {
    @Published var actions: [Action] = []
    
    init() {
        fetchActions()
    }
    
    func fetchActions() {
        actions = [
            Action(iconName: "banknote", text: "Debit Buy"),
            Action(iconName: "creditcard", text: "Credit Buy"),
            Action(iconName: "arrow.down.to.line.circle", text: "Transfer In"),
            Action(iconName: "arrow.up.to.line.circle", text: "Transfer Out"),
            Action(iconName: "plus.forwardslash.minus", text: "Adjust"),
        ]
    }
}
