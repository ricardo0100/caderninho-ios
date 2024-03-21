import Foundation

extension Double {
    func toCurrency(with symbol: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = symbol
        return formatter.string(from: self as NSNumber)!
    }
}
