//
//  TouchEvent.swift
//  29.10.2024
//

import Foundation

enum TouchEvent {
    case began(location: CGPoint)
    case moved(location: CGPoint)
    case ended(location: CGPoint)
}
