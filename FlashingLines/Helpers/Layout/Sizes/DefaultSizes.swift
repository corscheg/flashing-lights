//
//  DefaultSizes.swift
//  28.10.2024
//

import Foundation

struct DefaultSizes { }

// MARK: - Sizes
extension DefaultSizes: Sizes {
    var regularButton: CGSize { CGSize(width: 32, height: 32) }
    var smallButton: CGSize { CGSize(width: 24, height: 24) }
    var minimalTapArea: CGSize { CGSize(width: 44, height: 44) }
}
