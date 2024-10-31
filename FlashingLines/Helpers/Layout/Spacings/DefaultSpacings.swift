//
//  DefaultSpacings.swift
//  28.10.2024
//

import Foundation

struct DefaultSpacings { }

// MARK: - Spacings
extension DefaultSpacings: Spacings {
    var tiny: CGFloat { 2 }
    var small: CGFloat { 8 }
    var regular: CGFloat { 16 }
    var margin: CGFloat { 16 }
    var largeVertical: CGFloat { 32 }
    var moderateVertical: CGFloat { 22 }
}
