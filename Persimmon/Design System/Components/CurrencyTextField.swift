import SwiftUI
import Combine

struct CurrencyTextField: View {
    let currency: String
    let font: Font
    @Binding var value: Double
    @State var text: String = ""
    
    init(currency: String, value: Binding<Double>, font: Font = .body) {
        self.currency = currency
        self._value = value
        self.font = font
    }
    
    var body: some View {
        TextField("Hey", text: $text)
            .font(font)
            .keyboardType(.decimalPad)
            .onChange(of: text) {
                self.text = currencyFormattedNumber(text, currency: currency)
                self.value = doubleValueFromCurrencyString(self.text)
            }
            .onAppear {
                text = currencyFormattedNumber(String(value), currency: currency)
            }
    }
    
    private func makeFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency
        formatter.minimumFractionDigits = 2
        return formatter
    }
    
    private func currencyFormattedNumber(_ stringNumber: String, currency: String) -> String {
        let value = stringNumber.toDouble ?? 0
        let formatter = makeFormatter()
        return formatter.string(from: NSNumber(floatLiteral: value)) ?? ""
    }
    
    private func doubleValueFromCurrencyString(_ stringNumber: String) -> Double {
        let number = stringNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var value = Double(number) ?? 0
        value = value / Double(100)
        return value
    }
}

#Preview {
    @Previewable @State var value = Double(46.60)
    Form {
        CurrencyTextField(currency: "R$", value: $value)
    }
}
