//
//  Point+init.swift
//  29.10.2024
//

import Foundation

extension Point {
    init(cgPoint: CGPoint, scale: CGFloat) {
        let clampedX = max(.zero, cgPoint.x)
        let clampedY = max(.zero, cgPoint.y)
        self.init(x: UInt16(clampedX.scaled(by: Double(scale))), y: UInt16(clampedY.scaled(by: Double(scale))))
    }
}
