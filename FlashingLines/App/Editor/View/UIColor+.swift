//
//  UIColor+.swift
//  29.10.2024
//

import UIKit

extension UIColor {
    convenience init(color: Color) {
        self.init(
            red: CGFloat(color.red) / 255,
            green: CGFloat(color.green) / 255,
            blue: CGFloat(color.blue) / 255,
            alpha: CGFloat(color.alpha) / 255
        )
    }
}
