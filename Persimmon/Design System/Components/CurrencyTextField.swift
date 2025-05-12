import SwiftUI
import Combine

struct CurrencyTextField: View {
    @Binding var value: Double
    let currency: String
    @State var text: String = ""
    
    private let currencyFormatter: NumberFormatter
    private let decimalPlaces = 2
    
    private let font: Font
    
    init(currency: String, value: Binding<Double>, font: Font = .body) {
        self.currency = currency
        self._value = value
        self.font = font
        currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = currency
        currencyFormatter.minimumFractionDigits = decimalPlaces
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
                text = currencyFormattedNumber(currencyFormatter.string(from: NSNumber(floatLiteral: value))!, currency: currency)
            }
    }
    
    private func currencyFormattedNumber(_ doubleString: String, currency: String) -> String {
        let newValue = Double(doubleString.filter { $0.isNumber })! / pow(10, Double(decimalPlaces))
        return currencyFormatter.string(from: NSNumber(floatLiteral: newValue))!
    }
    
    private func doubleValueFromCurrencyString(_ stringNumber: String) -> Double {
        currencyFormatter.number(from: stringNumber)!.doubleValue
    }
}

#Preview {
    @Previewable @State var value = Double(460.20)
    Form {
        CurrencyTextField(currency: "R$", value: $value)
    }
}
