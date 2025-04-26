//
//  EditTransactionViewModel.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 22/12/24.
//
import SwiftUI
import SwiftData
import Vision
import PhotosUI
import NaturalLanguage

extension EditTransactionView {
    public class ViewModel: ObservableObject {
        let transaction: Transaction?
        
        // Model vars
        @Published var name: String
        @Published var account: Account?
        @Published var value: Double
        @Published var category: Category?
        @Published var type: Transaction.TransactionType
        @Published var date: Date
        @Published var place: Transaction.Place?
        @Published var shares: Int
        
        // UI only vars
        @Published var nameError: String? = ""
        @Published var accountError: String? = ""
        @Published var showDeleteAlert = false
        @Published var shouldDismiss: Bool = false
        @Published var isRecognizingImage: Bool = false
        
        init(transaction: Transaction? = nil) {
            self.transaction = transaction
            _name = Published(initialValue: transaction?.name ?? "")
            _account = Published(initialValue: transaction?.account)
            _value = Published(initialValue: transaction?.value ?? .zero)
            _category = Published(initialValue: transaction?.category)
            _type = Published(initialValue: transaction?.type ?? .buyCredit)
            _date = Published(initialValue: transaction?.date ?? Date())
            _place = Published(initialValue: transaction?.place)
            _shares = Published(initialValue: transaction?.shares.count ?? 1)
        }
        
        init(item: PhotosPickerItem) {
            transaction = nil
            _name = Published(initialValue: "")
            _account = Published(initialValue: nil)
            _value = Published(initialValue: .zero)
            _category = Published(initialValue: nil)
            _type = Published(initialValue: .buyCredit)
            _date = Published(initialValue: Date())
            _place = Published(initialValue: nil)
            _shares = Published(initialValue: 1)
            loadPhotosItem(item: item)
        }
        
        func loadPhotosItem(item: PhotosPickerItem) {
            self.isRecognizingImage = true
            Task.detached(priority: .userInitiated) {
                do {
                    guard let item = try await item.loadTransferable(type: ImageTransferable.self) else {
                        throw ImageTransferable.ImageTransferableError.importError
                    }
                    guard let image = item.image.cgImage else { return }
                    let requestHandler = VNImageRequestHandler(cgImage: image, orientation: .up)
                    let request = VNRecognizeTextRequest(completionHandler: self.recognizeTextHandler)
                    request.recognitionLevel = .accurate
                    try requestHandler.perform([request])
                } catch {
                    await self.onRecognitionError(error: error)
                }
                
            }
        }
        
        @MainActor
        func onRecognitionError(error: Error) {
            print(error)
            self.isRecognizingImage = false
        }
        
        func didTapCancel() {
            shouldDismiss = true
        }
        
        func didTapDelete() {
            showDeleteAlert = true
        }
        
        func didTapCancelDelete() {
            showDeleteAlert = false
        }
        
        @MainActor func didConfirmDelete() {
            guard let transaction = transaction else { return }
            let context = ModelContainer.shared.mainContext
            context.delete(transaction)
            try? context.save()
            shouldDismiss = true
        }
        
        @MainActor func didTapSave() {
            withAnimation {
                clearErrors()
                guard !name.isEmpty else {
                    nameError = "Mandatory field"
                    return
                }
                guard account != nil else {
                    accountError = "Select an account"
                    return
                }
            }
            saveTransaction()
        }
        
        private func clearErrors() {
            nameError = nil
            accountError = nil
        }
        
        @MainActor private func saveTransaction() {
            let context = ModelContainer.shared.mainContext
            guard let account = account else {
                return
            }
            if let transaction = transaction {
                transaction.name = name
                transaction.account = account
                transaction.category = category
                transaction.value = value
                transaction.date = date
                transaction.place = place
            } else {
                let transaction = Transaction(
                    id: UUID(),
                    name: name,
                    value: value,
                    account: account,
                    category: category,
                    date: date,
                    type: type,
                    place: place)
                context.insert(transaction)
            }
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            shouldDismiss = true
        }
        
        //MARK: Image Recognition
        
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
}

struct ImageTransferable: Transferable, Identifiable {
    var id = UUID()
    
    let image: UIImage
    
    enum ImageTransferableError: Error {
        case importError
    }
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw ImageTransferableError.importError
            }
            return ImageTransferable(image: uiImage)
        }
    }
}
