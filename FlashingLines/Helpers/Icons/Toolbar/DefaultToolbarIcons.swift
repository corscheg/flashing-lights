//
//  DefaultToolbarIcons.swift
//  28.10.2024
//

import UIKit

struct DefaultToolbarIcons: ToolbarIcons {
    let brush: UIImage = UIImage(resource: .brush)
    let erase: UIImage = UIImage(resource: .erase)
    let instruments: UIImage = UIImage(resource: .instruments)
    let palette: UIImage = UIImage(resource: .palette)
    let pencil: UIImage = UIImage(resource: .pencil).withRenderingMode(.alwaysTemplate)
}
