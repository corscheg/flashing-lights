//
//  DefaultColors.swift
//  28.10.2024
//

import Foundation

struct DefaultColors: Colors {
    let interface: any InterfaceColors = DefaultInterfaceColors()
    let palette: any PaletteColors = DefaultPaletteColors()
    let opacities: any Opacities = DefaultOpacities()
}
