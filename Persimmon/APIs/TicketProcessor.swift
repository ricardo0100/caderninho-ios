//
//  TicketProcessor.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 28/04/25.
//
import SwiftUI
import Vision
import NaturalLanguage

class TicketProcessor {
    struct TicketData: Identifiable {
        let id = UUID()
        let establishmentName: String
        let value: Double
        let date: Date
    }
    
    private var completion: ((TicketData?) -> Void)?
    
    func process(_ ticketImage: UIImage, completion: @escaping (TicketData?) -> Void) {
        self.completion = completion
        do {
            guard let image = ticketImage.cgImage else { return }
            let requestHandler = VNImageRequestHandler(cgImage: image, orientation: .up)
            let request = VNRecognizeTextRequest(completionHandler: self.recognizeTextHandler)
            request.recognitionLevel = .accurate
            try requestHandler.perform([request])
        } catch {
            completion(nil)
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let texts = observations
            .compactMap { $0.topCandidates(1).first?.string }
            .filter { $0.isTextOrDoubleValue }
            .flatMap { text in
                let tagger = NLTagger(tagSchemes: [.nameTypeOrLexicalClass])
                tagger.string = text
                tagger.setLanguage(.portuguese, range: text.startIndex..<text.endIndex)
                var tags = [(String, String)]()
                tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .sentence, scheme: .nameTypeOrLexicalClass) { tag, range in
                    let word = String(text[range])
                    let label = tag?.rawValue ?? "="
                    print("\(word): \(label)")
                    tags.append((word, label))
                    return true
                }
                return tags
            }

//                    tagger.enumerateTokens(in: text.startIndex..<text.endIndex) { sentenceRange, _ in
//                        let sentence = text[sentenceRange]
//                        print("🔹 Sentence: \(sentence)")
//
//                        // Step 2: Tag words in this sentence
//                        tagger.setLanguage(.english, range: sentenceRange)
//                        return tagger.enumerateTags(in: sentenceRange, unit: .word, scheme: .nameTypeOrLexicalClass, options: [.omitPunctuation, .omitWhitespace]) { tag, tokenRange in
//                            let word = String(text[tokenRange])
//                            let label = tag?.rawValue ?? "Other"
//                            print("  \(word): \(label)")
//                            return true
//                        }.map(\.1) ?? []
//                    }
//
//                    return tagger.tags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameTypeOrLexicalClass)
//                        .map { tag, range in
//                            return (String(text[range]), tag?.rawValue ?? "Other")
//                        }
//                }
        
        texts.forEach {
            print($0)
        }
        
        completion?(TicketData(establishmentName: "Hiper", value: 12, date: Date.yesterday()))
        

//            tagger.enumerateTags(in: text.startIndex..<text.endIndex,
//                                 unit: .sentence,
//                                 scheme: .lexicalClass,
//                                 options: [.omitWhitespace, .omitPunctuation, .joinNames]) { tag, tokenRange in
//                let word = String(text[tokenRange])
//                let label = tag?.rawValue ?? "Other"
//                print("\(word) -> \(label)")
//                return true
//            }

        
//            DispatchQueue.main.async {
//                if let requestResults = request.results as? [VNRecognizedTextObservation] {
//                    self.isRecognizingImage = false
//                    requestResults.forEach {
//                        print($0.topCandidates(1)[0].string, $0.boundingBox)
//                    }
//                }
//            }
    }
}
