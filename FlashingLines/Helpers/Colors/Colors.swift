//
//  Colors.swift
//  28.10.2024
//

import UIKit

protocol Colors {
    var interface: any InterfaceColors { get }
    var palette: any PaletteColors { get }
    var opacities: any Opacities { get }
}
