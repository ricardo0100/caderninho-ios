//
//  CameraView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 27/04/25.
//

import SwiftUI
import AVFoundation
import PhotosUI

struct TicketReaderView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    CameraPreview(cameraController: viewModel.cameraController)
                        .onTapGesture { point in
                            Task {
                                viewModel.cameraController.focus(at: point)
                            }
                        }
                }
                if viewModel.image == nil {
                    HStack {
                        HStack {
                            PhotosPicker(selection: $viewModel.selectedItems,
                                         maxSelectionCount: 1,
                                         matching: .images) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36, height: 36, alignment: .center)
                                    .foregroundStyle(Color.white)
                            }.disabled(viewModel.isProcessing)
                        }.frame(maxWidth: .infinity)
                        Button(action: viewModel.didTapTakePicture){
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .fill(Color.white.opacity(0.8))
                        }
                        .disabled(viewModel.isProcessing)
                        .frame(width: 60, height: 60)
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: viewModel.didTapClose)
                }
            }
            .overlay {
                if viewModel.isProcessing {
                    ProgressView()
                }
            }
            .onChange(of: viewModel.dismiss) {
                dismiss()
            }
        }
    }
}

fileprivate struct CameraPreview: UIViewRepresentable {
    typealias UIViewType = UIView
    
    fileprivate let cameraController: CameraController
    
    func makeUIView(context: Context) -> UIView {
        return cameraController
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    TicketReaderView(viewModel: .init(ticketData: .constant(nil)))
}
