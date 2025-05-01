//
//  TicketProcessor.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 28/04/25.
//
import SwiftUI
import Vision
import NaturalLanguage

struct TicketData: Identifiable {
    let id = UUID()
    let establishmentName: String?
    let value: Double?
    let date: Date?
    let type: Transaction.TransactionType?
}

class TicketProcessor {
    private var completion: ((TicketData?) -> Void)?
    
    func process(_ ticketImage: UIImage, completion: @escaping (TicketData?) -> Void) {
        self.completion = completion
        
        do {
            guard let image = ticketImage.cgImage else { completion(nil); return }
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

        let texts = observations.compactMap { $0.topCandidates(1).first?.string }

        // Look for total value
        var foundValue: Double?
        var labelTriggered: Bool = false
        for text in texts {
            if text.lowercased().contains("valor total") {
                labelTriggered = true
                continue
            }
            if labelTriggered {
                if let value = text.toDouble {
                    foundValue = value
                    break
                }
            }
        }
        
        completion?(TicketData(establishmentName: "Hiper", value: foundValue, date: Date(), type: .buyCredit))
    }
}
