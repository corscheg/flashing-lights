//
//  Color.swift
//  29.10.2024
//

import Foundation

struct Color: Equatable {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    let alpha: UInt8
    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(red: UInt8, green: UInt8, blue: UInt8, floatAlpha: CGFloat) {
        self.init(red: red, green: green, blue: blue, alpha: UInt8(max(floatAlpha * 255, 1.0)))
    }
}
