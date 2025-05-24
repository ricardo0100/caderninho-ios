//
//  Image+Extension.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 24/05/25.
//
import SwiftUI
import UIKit

extension UIImage {
    /// Analyze predominant color from a backing UIImage
    func predominantColor(sampledPixelCount: Int = 1000) -> Color? {
        guard let cgImage = self.cgImage else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let data = context.data else { return nil }
        
        let ptr = data.bindMemory(to: UInt8.self, capacity: width * height * bytesPerPixel)
        
        var colorCounts: [UInt32: Int] = [:]
        
        let pixelCount = width * height
        let step = max(1, pixelCount / sampledPixelCount)
        
        for i in stride(from: 0, to: pixelCount, by: step) {
            let pixelIndex = i * bytesPerPixel
            let r = ptr[pixelIndex]
            let g = ptr[pixelIndex + 1]
            let b = ptr[pixelIndex + 2]
            
            let colorKey = (UInt32(r) << 16) | (UInt32(g) << 8) | UInt32(b)
            colorCounts[colorKey, default: 0] += 1
        }
        
        if let (dominantKey, _) = colorCounts.max(by: { $0.value < $1.value }) {
            let r = CGFloat((dominantKey >> 16) & 0xFF) / 255.0
            let g = CGFloat((dominantKey >> 8) & 0xFF) / 255.0
            let b = CGFloat(dominantKey & 0xFF) / 255.0
            
            return Color(red: r, green: g, blue: b)
        }
        
        return nil
    }
}
