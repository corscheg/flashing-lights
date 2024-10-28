//
//  DefaultIcons.swift
//  28.10.2024
//

import Foundation

struct DefaultIcons: Icons {
    let navbar: any NavbarIcons = DefaultNavbarIcons()
    let shape: any ShapeIcons = DefaultShapeIcons()
    let toolbar: any ToolbarIcons = DefaultToolbarIcons()
}
