//
//  DrawablePictureView.swift
//  29.10.2024
//

import UIKit

final class DrawablePictureView: PictureView {
    func addLine(from start: CGPoint, to end: CGPoint, brushWidth: CGFloat, color: CGColor) {
        imageView.image = UIGraphicsImageRenderer(size: bounds.size).image { context in
            let cgContext = context.cgContext
            image?.draw(in: bounds)
            cgContext.move(to: start)
            cgContext.addLine(to: end)
            
            cgContext.setLineCap(.round)
            cgContext.setBlendMode(.normal)
            cgContext.setLineWidth(brushWidth)
            cgContext.setStrokeColor(color)
            
            cgContext.strokePath()
        }
    }
}
