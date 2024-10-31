//
//  Layout.swift
//  28.10.2024
//

import Foundation

protocol Layout {
    var sizes: any Sizes { get }
    var spacings: any Spacings { get }
    var cornerRadiuses: any CornerRadiuses { get }
    var borders: any Borders { get }
}
