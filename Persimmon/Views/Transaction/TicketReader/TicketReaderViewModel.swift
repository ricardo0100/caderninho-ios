//
//  TicketReaderViewModel.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 30/04/25.
//
import SwiftUI
import PhotosUI

extension TicketReader {
    class ViewModel: ObservableObject {
        @Published var image: UIImage?
        @Published var isProcessing = false
        @Published var selectedItems: [PhotosPickerItem] = [] {
            didSet {
                loadSelectedImage()
            }
        }
        @Published var dismiss: Bool = false
        @Binding var ticketData: TicketData?
        
        init(ticketData: Binding<TicketData?>) {
            _ticketData = ticketData
        }
        
        let cameraController = CameraController()
        private let ticketProcessor = TicketProcessor()
        
        private func loadSelectedImage() {
            guard let item = selectedItems.first else { return }
            isProcessing = true
            Task.detached(priority: .userInitiated) {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    self.startProcessingTicketImage(image)
                }
            }
        }
        
        func didTapClose() {
            dismiss = true
        }
        
        func didTapTakePicture() {
            withAnimation {
                isProcessing = true
            }
            cameraController.captureImage { image in
                self.image = image
                self.dismiss = true
            }
        }
        
        private func startProcessingTicketImage(_ image: UIImage) {
            self.ticketProcessor.process(image) { data in
                DispatchQueue.main.async {
                    self.didFinishProcessingTicket(data: data)
                }
            }
        }
        
        private func didFinishProcessingTicket(data: TicketData?) {
            self.dismiss = true
            self.isProcessing = false
            self.ticketData = data
        }
    }
}
