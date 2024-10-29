//
//  Point+init.swift
//  29.10.2024
//

import Foundation

extension Point {
    init(cgPoint: CGPoint, scale: CGFloat) {
        self.init(x: UInt16(cgPoint.x.scaled(by: Double(scale))), y: UInt16(cgPoint.y.scaled(by: Double(scale))))
    }
}
