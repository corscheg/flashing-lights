//
//  EditorInterfaceState.swift
//  30.10.2024
//

import Foundation

struct EditorInterfaceState {
    var undoButton: ButtonState
    var redoButton: ButtonState
    
    static var initial: EditorInterfaceState {
        .init(undoButton: .init(isSelected: false, isEnabled: false), redoButton: .init(isSelected: false, isEnabled: false))
    }
}

// MARK: -  ButtonState
extension EditorInterfaceState {
    struct ButtonState {
        var isSelected: Bool
        var isEnabled: Bool
    }
}
