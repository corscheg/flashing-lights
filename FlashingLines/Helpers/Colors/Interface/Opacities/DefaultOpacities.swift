//
//  DefaultOpacities.swift
//  30.10.2024
//

import Foundation

struct DefaultOpacities { }

// MARK: - Opacities
extension DefaultOpacities: Opacities {
    var assist: CGFloat { 0.3 }
    var disabled: CGFloat { 0.5 }
}
