import SwiftUI

struct BudgetPanel: View {
    var body: some View {
        HStack(spacing: 18) {
            PizzaGraphicView(values: [
                .init(value: 20, color: Color.brand.opacity(0.7)),
                .init(value: 40, color: Color.brand)
            ]).frame(width: 80, height: 80)
            
            VStack(alignment: .leading) {
                Text("Available for May")
                    .foregroundColor(Color.brand)
                    .bold()
                Text("R$ 623,43 of R$ 1234,32").textCase(nil)
                Text("R$ 23,43 / day").textCase(nil)
            }
        }
        .foregroundColor(Color.primary)
    }
}

struct BudgetPanel_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.horizontal) {
            BudgetPanel()
        }
    }
}
