import SwiftUI
import Combine

struct CurrencyTextField: View {
    let currency: String
    @Binding var value: Double
    @State var text: String = ""
    
    init(currency: String, value: Binding<Double>) {
        self.currency = currency
        self._value = value
    }
    
    var body: some View {
        TextField("Hey", text: $text)
            .keyboardType(.decimalPad)
            .onChange(of: text) { newValue in
                self.text = currencyFormattedNumber(newValue, currency: currency)
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
        return formatter
    }
    
    private func currencyFormattedNumber(_ stringNumber: String, currency: String) -> String {
        let number = stringNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var value = Double(number) ?? 0
        value = value / Double(100)
        let formatter = makeFormatter()
        return formatter.string(from: NSNumber.init(floatLiteral: value)) ?? ""
    }
    
    private func doubleValueFromCurrencyString(_ stringNumber: String) -> Double {
        let number = stringNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var value = Double(number) ?? 0
        value = value / Double(100)
        return value
    }
}

struct CurrencyTextField_Previews: PreviewProvider {
    @State static var value = Double(0)
    
    static var previews: some View {
        Form {
            CurrencyTextField(currency: "R$", value: .constant(2))
        }
    }
}
