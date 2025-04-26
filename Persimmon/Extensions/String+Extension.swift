import Foundation

extension String {
    func firstLetters() -> String {
        let excludedWords = ["of", "do", "de", "in", "da", "the", "and", "or", "is", "are", "to"]
        
        let words = components(separatedBy: .whitespacesAndNewlines)
            .filter { !excludedWords.contains($0.lowercased()) }
            .compactMap { $0.first }
        
        return String(words).uppercased()
    }
    
    var isTextOrDoubleValue: Bool {
        let normalized = self.replacingOccurrences(of: ",", with: ".")
        
        // Check if it's a double
        if Double(normalized) != nil {
            return true
        }
        
        // If it's not an integer, assume it's text
        return Int64(self) == nil
    }
}
