//
//  UIColor+.swift
//  29.10.2024
//

import UIKit

extension UIColor {
    convenience init(color: Color) {
        self.init(
            hexRed: color.red,
            green: color.green,
            blue: color.blue,
            alpha: color.alpha
        )
    }
    
    convenience init(hexRed: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.init(hexRed: hexRed, green: green, blue: blue, floatAlpha: CGFloat(alpha) / 255)
    }
    
    convenience init(hexRed: UInt8, green: UInt8, blue: UInt8, floatAlpha: CGFloat) {
        self.init(red: CGFloat(hexRed) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: floatAlpha)
    }
}
