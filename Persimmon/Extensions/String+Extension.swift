import Foundation

extension String {
    func firstLetters() -> String {
        let excludedWords = ["of", "do", "de", "in", "da", "the", "and", "or", "is", "are", "to"]
        
        let words = components(separatedBy: .whitespacesAndNewlines)
            .filter { !excludedWords.contains($0.lowercased()) }
            .compactMap { $0.first }
        
        return String(words).uppercased()
    }
    
    var removingCurrencySymbols: String {
        return self.replacingOccurrences(
            of: "[\\p{Sc}]",
            with: "",
            options: .regularExpression
        )
    }
    
    var toDouble: Double? {
        let pattern = #"([-+]?\d*[.,]?\d+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: self, range: NSRange(self.startIndex..., in: self)) else {
            return nil
        }
        
        let matchedString = String(self[Range(match.range, in: self)!])
            .replacingOccurrences(of: ",", with: ".")
        
        return Double(matchedString)
    }
}
