//
//  DefaultLayout.swift
//  28.10.2024
//

import Foundation

struct DefaultLayout: Layout {
    let sizes: any Sizes = DefaultSizes()
    let spacings: any Spacings = DefaultSpacings()
    let cornerRadiuses: any CornerRadiuses = DefaultCornerRadiuses()
    let borders: any Borders = DefaultBorders()
}
