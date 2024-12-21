import SwiftUI

struct BudgetPanel: View {
    var body: some View {
        HStack(spacing: .spacingBig) {
            PizzaGraphView(values: [
//                .init(value: 20, color: Color.red.opacity(0.7)),
//                .init(value: 40, color: Color.blue)
            ]).frame(width: 120, height: 120)
            VStack(alignment: .leading) {
                Text("Some interesting information and graph")
                    .bold()
                Text("R$ 123,43 of R$ 1234,56")
                Text("R$ 123,43 / day")
            }
            Spacer()
        }
        .foregroundColor(Color.primary)
    }
}

struct BudgetPanel_Previews: PreviewProvider {
    static var previews: some View {
        BudgetPanel()
    }
}
