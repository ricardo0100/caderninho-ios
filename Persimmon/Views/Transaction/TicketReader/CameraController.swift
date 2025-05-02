//
//  CameraController.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 30/04/25.
//

import UIKit
import AVFoundation

class CameraController: UIView {
    private var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureCompletion: ((UIImage?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if targetEnvironment(simulator)
        backgroundColor = .gray
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
    
    func focus(at point: CGPoint) {
        guard let videoInput = captureSession?.inputs.first as? AVCaptureDeviceInput else { return }
        let device = videoInput.device
        let devicePoint = previewLayer?.captureDevicePointConverted(fromLayerPoint: point) ?? .init(x: 0.5, y: 0.5)
        do {
            try device.lockForConfiguration()
            device.isSubjectAreaChangeMonitoringEnabled = true
            device.exposureMode = .autoExpose
            device.focusMode = .autoFocus
            device.focusPointOfInterest = devicePoint
            device.exposurePointOfInterest = devicePoint
            device.unlockForConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func stopCamera() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.stopRunning()
        }
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
