import Foundation

extension String {
    func firstLetters() -> String {
        let excludedWords = ["of", "do", "de", "in", "da", "the", "and", "or", "is", "are", "to"]
        
        let words = components(separatedBy: .whitespacesAndNewlines)
            .filter { !excludedWords.contains($0.lowercased()) }
            .compactMap { $0.first }
        
        return String(words).uppercased()
    }
}
