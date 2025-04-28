//
//  CameraView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 27/04/25.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    @State var isProcessing = false
    @Binding var image: UIImage?
    
    private let cameraPreview = CameraPreview()
    
    func didTapClose() {
        dismiss()
    }
    
    func didTapTakePicture() {
        withAnimation {
            isProcessing = true
        }
        cameraPreview.cameraController.captureImage { image in
            self.image = image
            self.dismiss()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                cameraPreview
                    .opacity(isProcessing ? 0.5 : 1)
                
                VStack {
                    HStack {
                        Button(action: didTapClose) {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundStyle(Color.white)
                        }.padding()
                        Spacer()
                    }
                    
                    Spacer()
                    if isProcessing {
                        ProgressView()
                            .frame(width: 42, height: 42)
                    }
                    Spacer()
                    
                    Button(action: didTapTakePicture){
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .fill(Color.white.opacity(0.8))
                            
                    }
                    .disabled(isProcessing)
                    .opacity(isProcessing ? 0.3 : 1)
                    .frame(width: 60, height: 60)
                    .padding(.bottom)
                }.frame(maxWidth: .infinity)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .safeAreaPadding()
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    typealias UIViewType = UIView
    
    fileprivate let cameraController = CameraController()
    
    func makeUIView(context: Context) -> UIView {
        return cameraController
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

fileprivate class CameraController: UIView {
    private var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureCompletion: ((UIImage?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if targetEnvironment(simulator)
        backgroundColor = .systemTeal
        #else
        setupCamera()
        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession?.startRunning()
            }
        }
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func captureImage(completion: @escaping (UIImage?) -> Void) {
        self.captureCompletion = completion
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        photoOutput = AVCapturePhotoOutput()
        if let photoOutput = photoOutput, captureSession?.canAddOutput(photoOutput) ?? false {
            captureSession?.addOutput(photoOutput)
        }
        
        if captureSession?.canAddInput(videoInput) ?? false {
            captureSession?.addInput(videoInput)
        } else {
            return
        }
        
        if let session = captureSession {
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            self.previewLayer = previewLayer
            previewLayer.frame = layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(previewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        if captureSession?.isRunning == true {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession?.stopRunning()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = layer.bounds
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                    didFinishProcessingPhoto photo: AVCapturePhoto,
                    error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            captureCompletion?(nil)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            captureCompletion?(nil)
            return
        }
        
        captureCompletion?(image)
        captureSession?.stopRunning()
    }
}

#Preview {
    CameraView(image: .constant(nil))
}
