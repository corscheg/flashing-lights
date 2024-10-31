//
//  InterfaceColors.swift
//  28.10.2024
//

import UIKit

protocol InterfaceColors {
    var accent: UIColor { get }
    var background: UIColor { get }
    var disabled: UIColor { get }
    var button: UIColor { get }
    var prominentBorder: UIColor { get }
    var opacities: any Opacities { get }
}
