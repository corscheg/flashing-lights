//
//  DefaultInterfaceColors.swift
//  28.10.2024
//

import UIKit

struct DefaultInterfaceColors: InterfaceColors {
    let accent: UIColor = UIColor(hexRed: 0xA8, green: 0xDB, blue: 0x10, alpha: 0xFF)
    let background: UIColor = .black
    let disabled: UIColor = UIColor(hexRed: 0x8B, green: 0x8B, blue: 0x8B, alpha: 0xFF)
    let button: UIColor = .white
    var prominentBorder: UIColor = UIColor(hexRed: 0x55, green: 0x54, blue: 0x54, floatAlpha: 0.16)
    let opacities: any Opacities = DefaultOpacities()
}
