//
//  TouchEvent.swift
//  29.10.2024
//

import Foundation

enum TouchEvent {
    case began(location: Point)
    case moved(location: Point)
    case ended(location: Point)
}
